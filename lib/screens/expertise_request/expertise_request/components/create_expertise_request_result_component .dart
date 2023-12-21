import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/screens/common/fail_dialog.dart';
import 'package:socialv/screens/common/loading_dialog.dart';
import 'package:video_player/video_player.dart';

import '../../../../components/file_picker_dialog_component.dart';
import '../../../../components/loading_widget.dart';
import '../../../../controllers/expertise_request_controller.dart';
import '../../../../main.dart';
import '../../../../models/common_models.dart';
import '../../../../models/posts/media_model.dart';
import '../../../../utils/app_constants.dart';
import '../../../post/components/show_selected_media_component.dart';

class CreateExpertiseRequestResultComponent extends StatefulWidget {
  final Function(int)? onNextPage;

  CreateExpertiseRequestResultComponent({Key? key, this.onNextPage})
      : super(key: key);

  @override
  State<CreateExpertiseRequestResultComponent> createState() =>
      _CreateExpertiseRequestResultComponentState();
}

int? albumId;

class _CreateExpertiseRequestResultComponentState
    extends State<CreateExpertiseRequestResultComponent> {
  final albumKey = GlobalKey<FormState>();

  List<PostMedia> mediaList = [];
  TextEditingController discCont = TextEditingController();
  FocusNode discNode = FocusNode();

  late ExpertiseRequestController expertiseRequestController =
      Get.put(ExpertiseRequestController());

  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    discNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(defaultRadius)),
              color: context.cardColor,
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  24.height,
                  Text(
                    language.createExpertiseRequest,
                    style: primaryTextStyle(
                        color: appStore.isDarkMode ? bodyDark : bodyWhite,
                        size: 18),
                  ),
                  16.height,
                  Form(
                    key: albumKey,
                    child: Column(
                      children: [
                        16.height,
                        TextFormField(
                          focusNode: discNode,
                          controller: discCont,
                          autofocus: false,
                          maxLines: 5,
                          decoration: inputDecorationFilled(
                            context,
                            fillColor: context.scaffoldBackgroundColor,
                            label: language.msgExpertiseRequest,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter message';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ],
                    ).paddingSymmetric(vertical: 8),
                  ),
                  8.height,
                  Stack(
                    children: [
                      DottedBorderWidget(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        radius: defaultAppButtonRadius,
                        dotsWidth: 8,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            16.height,
                            AppButton(
                              elevation: 0,
                              color: appColorPrimary,
                              text: language.selectFiles,
                              textStyle: boldTextStyle(color: Colors.white),
                              onTap: () async {
                                onSelectMedia();
                              },
                            ),
                            8.height,
                            Text(
                              language.selectFileExpertiseRequest,
                              style: secondaryTextStyle(),
                            ).center(),
                            16.height,
                          ],
                        ),
                      ),
                    ],
                  ).paddingAll(16),
                  if (mediaList.isNotEmpty)
                    ShowSelectedMediaComponent(
                      mediaList: mediaList,
                      mediaType: MediaModel(
                          type: 'photo', title: 'Photo', isActive: true),
                      videoController: List.generate(mediaList.length, (index) {
                        return VideoPlayerController.networkUrl(
                            Uri.parse(mediaList[index].file!.path.validate()));
                      }),
                    ),
                  8.height,
                  Align(
                    alignment: Alignment.center,
                    child: appButton(
                      text: language.create,
                      onTap: () async {
                        hideKeyboard(context);
                        if (albumKey.currentState!.validate()) {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return LoadingDialog();
                              });
                          await expertiseRequestController
                              .createExpertiseRequest(discCont.text, mediaList);

                          if (expertiseRequestController
                              .isCreateSuccess.value) {
                            expertiseRequestController.fetchExpetiseRequests(2);
                            Navigator.pop(context);
                            toast('Request Created Successfully');
                            Navigator.pop(context);
                          } else {
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return FailDialog(
                                    text: 'Create Request Failed');
                              },
                            );
                          }
                        }
                      },
                      context: context,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            child: Observer(
                builder: (_) =>
                    LoadingWidget().center().visible(appStore.isLoading)),
          ),
        ],
      ),
    );
  }

  Future<void> onSelectMedia() async {
    FileTypes? file = await showInDialog(
      context,
      contentPadding: EdgeInsets.symmetric(vertical: 16),
      title: Text(language.chooseAnAction, style: boldTextStyle()),
      builder: (p0) {
        return FilePickerDialog(isSelected: true);
      },
    );

    if (file != null) {
      if (file == FileTypes.CAMERA) {
        appStore.setLoading(true);
        await getImageSource(isCamera: true, isVideo: false).then((value) {
          appStore.setLoading(false);
          mediaList.add(PostMedia(file: value));
          setState(() {});
        }).catchError((e) {
          log('Error: ${e.toString()}');
          appStore.setLoading(false);
        });
      } else {
        appStore.setLoading(true);
        await getImageSource(isCamera: false, isVideo: false).then((value) {
          appStore.setLoading(false);
          mediaList.add(PostMedia(file: value));
          setState(() {});
        }).catchError((e) {
          log('Error: ${e.toString()}');
          appStore.setLoading(false);
        });
      }
    }
  }
}

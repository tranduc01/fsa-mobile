import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/controllers/gallery_controller.dart';
import 'package:socialv/screens/gallery/screens/create_album_screen.dart';
import 'package:video_player/video_player.dart';
import '../../../components/file_picker_dialog_component.dart';
import '../../../components/loading_widget.dart';
import '../../../components/no_data_lottie_widget.dart';
import '../../../main.dart';
import '../../../models/common_models.dart';
import '../../../models/gallery/media_active_statuses_model.dart';
import '../../../models/posts/media_model.dart';
import '../../../utils/colors.dart';
import '../../../utils/common.dart';
import '../../../utils/constants.dart';
import '../../post/components/show_selected_media_component.dart';

class CreateAlbumComponent extends StatefulWidget {
  final List<MediaModel> mediaTypeList;
  final Function(int)? onNextPage;
  final int? groupId;

  CreateAlbumComponent(
      {Key? key, required this.mediaTypeList, this.onNextPage, this.groupId})
      : super(key: key);

  @override
  State<CreateAlbumComponent> createState() => _CreateAlbumComponentState();
}

int? albumId;

class _CreateAlbumComponentState extends State<CreateAlbumComponent> {
  final albumKey = GlobalKey<FormState>();
  MediaModel dropdownTypeValue = MediaModel(
      allowedType: ['image', 'video'], title: 'Image', type: 'image');
  List<PostMedia> mediaList = [];
  MediaActiveStatusesModel dropdownStatusValue = MediaActiveStatusesModel();
  TextEditingController titleCont = TextEditingController();
  TextEditingController discCont = TextEditingController();
  FocusNode titleNode = FocusNode();
  FocusNode discNode = FocusNode();

  List<MediaActiveStatusesModel> mediaStatusList = [
    MediaActiveStatusesModel(
        id: 4,
        label: "111",
        singularName: "BBB",
        pluralName: "CCC",
        ttId: 1,
        callback: "DDD",
        activityPrivacy: "EEE"),
    MediaActiveStatusesModel(
        id: 5,
        label: "222",
        singularName: "BBB",
        pluralName: "CCC",
        ttId: 2,
        callback: "DDD",
        activityPrivacy: "EEE"),
    MediaActiveStatusesModel(
        id: 6,
        label: "333",
        singularName: "BBB",
        pluralName: "CCC",
        ttId: 3,
        callback: "DDD",
        activityPrivacy: "EEE"),
  ];

  bool isError = false;
  late GalleryController galleryController = Get.put(GalleryController());

  @override
  void initState() {
    super.initState();
    getMediaStatusList();

    if (widget.mediaTypeList.validate().isNotEmpty) {
      dropdownTypeValue =
          widget.mediaTypeList[(widget.groupId != null) ? 2 : 1];
      selectedAlbumMedia =
          widget.mediaTypeList[(widget.groupId != null) ? 2 : 1];
    }

    // Set dropdownStatusValue to the first item in mediaStatusList
    if (mediaStatusList.isNotEmpty) {
      dropdownStatusValue = mediaStatusList.first;
    }
  }

  Future<List<MediaActiveStatusesModel>> getMediaStatusList() async {
    // appStore.setLoading(true);
    // await getMediaStatus(type: widget.groupId == null ? Component.members : Component.groups).then(
    //   (value) {
    //     mediaStatusList.addAll(value);
    //     dropdownStatusValue = mediaStatusList.first;
    //     appStore.setLoading(false);
    //     isError = false;
    //     setState(() {});
    //   },
    // ).catchError(
    //   (e) {
    //     isError = true;
    //     appStore.setLoading(false);
    //     setState(() {});
    //   },
    // );
    return mediaStatusList;
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    titleNode.dispose();
    discNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (isError)
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: NoDataWidget(
                imageWidget: NoDataLottieWidget(),
                title: isError
                    ? language.somethingWentWrong
                    : language.noDataFound,
                onRetry: () {
                  getMediaStatusList();
                },
                retryText: '   ${language.clickToRefresh}   ',
              ).center(),
            )
          else
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
                      "${language.addAlbumDetails}",
                      style: primaryTextStyle(
                          color: appStore.isDarkMode ? bodyDark : bodyWhite,
                          size: 18),
                    ),
                    16.height,
                    Form(
                      key: albumKey,
                      child: Column(
                        children: [
                          TextFormField(
                            focusNode: titleNode,
                            controller: titleCont,
                            autofocus: false,
                            maxLines: 1,
                            textInputAction: TextInputAction.next,
                            decoration: inputDecorationFilled(
                              context,
                              fillColor: context.scaffoldBackgroundColor,
                              label: language.title,
                            ),
                            onFieldSubmitted: (value) {
                              titleNode.unfocus();
                              FocusScope.of(context).requestFocus(discNode);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return language.pleaseEnterTitle;
                              } else {
                                return null;
                              }
                            },
                          ),
                          16.height,
                          TextFormField(
                            focusNode: discNode,
                            controller: discCont,
                            autofocus: false,
                            maxLines: 5,
                            decoration: inputDecorationFilled(
                              context,
                              fillColor: context.scaffoldBackgroundColor,
                              label: language.description,
                            ),
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
                              16.height,
                              Text(
                                '${language.add} files',
                                style: secondaryTextStyle(size: 16),
                              ).center(),
                              8.height,
                              Text(
                                'Please select files',
                                style: secondaryTextStyle(),
                              ).center(),
                              16.height,
                            ],
                          ),
                        ),
                        // Positioned(
                        //   child: Icon(Icons.cancel_outlined,
                        //           color: appColorPrimary, size: 18)
                        //       .onTap(() {
                        //     finish(context);
                        //     finish(context);
                        //   },
                        //           splashColor: Colors.transparent,
                        //           highlightColor: Colors.transparent),
                        //   right: 6,
                        //   top: 6,
                        // ),
                      ],
                    ).paddingAll(16),
                    if (mediaList.isNotEmpty)
                      ShowSelectedMediaComponent(
                        mediaList: mediaList,
                        mediaType: MediaModel(
                            type: 'photo', title: 'Photo', isActive: true),
                        videoController:
                            List.generate(mediaList.length, (index) {
                          return VideoPlayerController.networkUrl(Uri.parse(
                              mediaList[index].file!.path.validate()));
                        }),
                      ),
                    Align(
                      alignment: Alignment.center,
                      child: appButton(
                        text: language.create,
                        onTap: () {
                          hideKeyboard(context);
                          if (albumKey.currentState!.validate()) {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return Dialog(
                                    shadowColor: Colors.transparent,
                                    backgroundColor: Colors.transparent,
                                    child: Image.asset(
                                      'assets/icons/loading.gif',
                                      height: 180,
                                      width: 180,
                                    ),
                                  );
                                });
                            galleryController.createAlbum(
                                titleCont.text, discCont.text, mediaList);
                            Future.delayed(Duration(seconds: 3), () {
                              if (galleryController.isCreateSuccess.value) {
                                galleryController.fetchAlbums();
                                Navigator.pop(context);
                                toast('Album Created Successfully');
                                Navigator.pop(context);
                              } else {
                                Navigator.pop(context);
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Container(
                                        width: 200,
                                        padding: EdgeInsets.all(16),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Image.asset(
                                                'assets/images/fail.gif'),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              'Create Failed',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                            SizedBox(height: 20),
                                            Text(
                                              'Please try again!',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: const Color.fromARGB(
                                                    106, 0, 0, 0),
                                              ),
                                            ),
                                            SizedBox(height: 20),
                                            Center(
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  'Try Again',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black),
                                                ),
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateColor
                                                          .resolveWith(
                                                              (states) {
                                                    if (states.contains(
                                                        MaterialState
                                                            .pressed)) {
                                                      return const Color
                                                              .fromARGB(
                                                          137, 244, 67, 54);
                                                    }
                                                    return Colors.white;
                                                  }),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        side: BorderSide(
                                                            color: Colors.red,
                                                            width: 2)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            });
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
        await getImageSource(
                isCamera: true,
                isVideo: selectedAlbumMedia!.type == MediaTypes.video)
            .then((value) {
          appStore.setLoading(false);
          mediaList.add(PostMedia(file: value));
          setState(() {});
        }).catchError((e) {
          log('Error: ${e.toString()}');
          appStore.setLoading(false);
        });
      } else {
        appStore.setLoading(true);
        getMultipleFiles(mediaType: MediaModel(type: 'photo', isActive: true))
            .then((value) {
          value.forEach((element) {
            mediaList.add(PostMedia(file: element));
          });
        }).catchError((e) {
          log('Error: ${e.toString()}');
        }).whenComplete(() {
          setState(() {});
          appStore.setLoading(false);
        });
      }
    }
  }
}

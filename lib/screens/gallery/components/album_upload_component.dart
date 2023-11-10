import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/controllers/gallery_controller.dart';
import 'package:socialv/models/posts/media_model.dart';
import 'package:socialv/screens/gallery/screens/create_album_screen.dart';
import 'package:video_player/video_player.dart';

import '../../../components/file_picker_dialog_component.dart';
import '../../../components/loading_widget.dart';
import '../../../main.dart';
import '../../../models/common_models.dart';
import '../../../models/gallery/albums.dart';
import '../../../utils/colors.dart';
import '../../../utils/common.dart';
import '../../../utils/constants.dart';
import '../../post/components/show_selected_media_component.dart';

// ignore: must_be_immutable
class AlbumUploadScreen extends StatefulWidget {
  final String? fileType;
  final Album? album;

  AlbumUploadScreen({this.fileType, this.album});

  @override
  State<AlbumUploadScreen> createState() => _AlbumUploadScreenState();
}

class _AlbumUploadScreenState extends State<AlbumUploadScreen> {
  List<PostMedia> mediaList = [];
  late GalleryController galleryController = Get.put(GalleryController());
  @override
  void initState() {
    super.initState();
    mediaList.clear();
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

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 16),
          child: Container(
            decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(defaultRadius))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                24.height,
                if (widget.fileType == null)
                  Text("${language.addMediaFile}",
                          style: primaryTextStyle(
                              color: appStore.isDarkMode ? bodyDark : bodyWhite,
                              size: 18))
                      .paddingSymmetric(horizontal: 16),
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
                            '${language.add} ${widget.fileType == null ? selectedAlbumMedia?.title.capitalizeFirstLetter() : widget.fileType} files',
                            style: secondaryTextStyle(size: 16),
                          ).center(),
                          8.height,
                          Text(
                            '${language.pleaseSelectOnly} ${widget.fileType == null ? selectedAlbumMedia?.type : widget.fileType} ${language.files} ',
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
                    videoController: List.generate(mediaList.length, (index) {
                      return VideoPlayerController.networkUrl(
                          Uri.parse(mediaList[index].file!.path.validate()));
                    }),
                  ),
                8.height,
                Align(
                  alignment: Alignment.center,
                  child: appButton(
                    text: language.upload,
                    onTap: () async {
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
                      await galleryController.updateAlbum(
                          widget.album!, mediaList, null);
                      Future.delayed(Duration(seconds: 3), () {
                        if (galleryController.isUpdateSuccess.value) {
                          galleryController.fetchAlbum(widget.album!.id!);
                          Navigator.pop(context);
                          toast('Medias Added Successfully');
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
                                      Image.asset('assets/images/fail.gif'),
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
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateColor.resolveWith(
                                                    (states) {
                                              if (states.contains(
                                                  MaterialState.pressed)) {
                                                return const Color.fromARGB(
                                                    137, 244, 67, 54);
                                              }
                                              return Colors.white;
                                            }),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
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
                    },
                    context: context,
                  ),
                ),
              ],
            ),
          ),
        ),
        Observer(builder: (_) => LoadingWidget().visible(appStore.isLoading))
      ],
    );
  }
}

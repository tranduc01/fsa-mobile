import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/controllers/gallery_controller.dart';
import 'package:socialv/models/posts/media_model.dart';
import 'package:socialv/screens/common/fail_dialog.dart';
import 'package:socialv/screens/common/loading_dialog.dart';
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
import 'package:path/path.dart' as path;
import '../../../utils/images.dart';
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
  List<PostMedia> mediaImageList = [];
  List<PostMedia> mediaVideoList = [];
  late GalleryController galleryController = Get.put(GalleryController());
  late CameraController _cameraController;
  bool _isVideoCameraSelected = false;
  bool _isRecordingInProgress = false;

  @override
  void initState() {
    super.initState();
    mediaImageList.clear();
    mediaVideoList.clear();
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
        await onCaptureImage();
        _cameraController.dispose();
      } else {
        appStore.setLoading(true);
        await getMediasSource(isCamera: false, isVideo: false).then((value) {
          appStore.setLoading(false);

          value.forEach(
            (element) {
              path.extension(element.path) == '.mp4'
                  ? mediaVideoList.add(PostMedia(
                      file: element, link: path.extension(element.path)))
                  : mediaImageList.add(PostMedia(
                      file: element, link: path.extension(element.path)));
            },
          );
          setState(() {});
        }).catchError((e) {
          log('Error: ${e.toString()}');
          appStore.setLoading(false);
        });
      }
    }
  }

  Future<void> onCaptureImage() async {
    //appStore.setLoading(true);

    final cameras = await availableCameras();
    final camera = cameras[0];
    _cameraController = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _cameraController.initialize();

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => PopScope(
          onPopInvoked: (didPop) {
            if (didPop) {
              _cameraController.dispose();
            }
          },
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: CameraPreview(_cameraController),
              ),
              Positioned(
                top: 30,
                left: 10,
                child: Material(
                  type: MaterialType.transparency,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              Positioned(
                bottom: 100,
                left: 0,
                right: 0,
                child: _isVideoCameraSelected
                    ? GestureDetector(
                        child: Icon(
                          _isRecordingInProgress
                              ? Icons.stop_circle_outlined
                              : Icons.fiber_manual_record_outlined,
                          color: Colors.red,
                          size: 50,
                        ),
                        onTap: () async {
                          if (_isRecordingInProgress) {
                            var value = await stopVideoRecording();
                            mediaVideoList
                                .add(PostMedia(file: File(value!.path)));
                            setState(() {
                              _isRecordingInProgress = false;
                            });
                            Navigator.pop(context);
                          } else {
                            startVideoRecording();
                            setState(() {
                              _isRecordingInProgress = true;
                            });
                          }
                        },
                      )
                    : GestureDetector(
                        child: Image.asset(
                          ic_camera_post,
                          height: 50,
                          width: 50,
                        ),
                        onTap: () async {
                          var value = await _cameraController.takePicture();
                          mediaImageList.add(PostMedia(file: File(value.path)));
                          setState(() {});
                          Navigator.pop(context);
                        },
                      ),
              ),
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          right: 4.0,
                        ),
                        child: TextButton(
                          onPressed: _isRecordingInProgress
                              ? null
                              : () {
                                  if (_isVideoCameraSelected) {
                                    setState(() {
                                      _isVideoCameraSelected = false;
                                    });
                                  }
                                },
                          style: TextButton.styleFrom(
                            foregroundColor: _isVideoCameraSelected
                                ? Colors.black54
                                : Colors.black,
                            backgroundColor: _isVideoCameraSelected
                                ? Colors.white30
                                : Colors.white,
                          ),
                          child: Text('IMAGE'),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4.0, right: 8.0),
                        child: TextButton(
                          onPressed: () {
                            if (!_isVideoCameraSelected) {
                              setState(() {
                                _isVideoCameraSelected = true;
                              });
                            }
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: _isVideoCameraSelected
                                ? Colors.black
                                : Colors.black54,
                            backgroundColor: _isVideoCameraSelected
                                ? Colors.white
                                : Colors.white30,
                          ),
                          child: Text('VIDEO'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> startVideoRecording() async {
    final CameraController? cameraController = _cameraController;
    if (_cameraController.value.isRecordingVideo) {
      // A recording has already started, do nothing.
      return;
    }
    try {
      await cameraController!.startVideoRecording();
      setState(() {
        _isRecordingInProgress = true;
        print(_isRecordingInProgress);
      });
    } on CameraException catch (e) {
      print('Error starting to record video: $e');
    }
  }

  Future<XFile?> stopVideoRecording() async {
    if (!_cameraController.value.isRecordingVideo) {
      // Recording is already is stopped state
      return null;
    }
    try {
      XFile file = await _cameraController.stopVideoRecording();
      setState(() {
        _isRecordingInProgress = false;
        print(_isRecordingInProgress);
      });
      return file;
    } on CameraException catch (e) {
      print('Error stopping video recording: $e');
      return null;
    }
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    _cameraController.dispose();
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
                  ],
                ).paddingAll(16),
                if (mediaImageList.isNotEmpty)
                  ShowSelectedMediaComponent(
                    mediaList: mediaImageList,
                    mediaType: MediaModel(
                        type: 'photo', title: 'Photo', isActive: true),
                    videoController:
                        List.generate(mediaImageList.length, (index) {
                      return VideoPlayerController.networkUrl(Uri.parse(
                          mediaImageList[index].file!.path.validate()));
                    }),
                  ),
                if (mediaVideoList.isNotEmpty)
                  ShowSelectedMediaComponent(
                    mediaList: mediaVideoList,
                    mediaType: MediaModel(
                        type: 'video', title: 'Photo', isActive: true),
                    videoController:
                        List.generate(mediaVideoList.length, (index) {
                      return VideoPlayerController.networkUrl(Uri.parse(
                          mediaVideoList[index].file!.path.validate()));
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
                            return LoadingDialog();
                          });

                      var mediaList = [...mediaImageList, ...mediaVideoList];
                      await galleryController.updateAlbum(
                          widget.album!, mediaList, null);

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
                            return FailDialog(text: 'Create Failed');
                          },
                        );
                      }
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

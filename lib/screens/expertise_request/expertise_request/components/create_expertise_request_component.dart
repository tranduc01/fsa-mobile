import 'dart:io';

import 'package:camera/camera.dart';
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
import 'package:path/path.dart' as path;

class CreateExpertiseRequestComponent extends StatefulWidget {
  final Function(int)? onNextPage;

  CreateExpertiseRequestComponent({Key? key, this.onNextPage})
      : super(key: key);

  @override
  State<CreateExpertiseRequestComponent> createState() =>
      _CreateExpertiseRequestComponentState();
}

int? albumId;

class _CreateExpertiseRequestComponentState
    extends State<CreateExpertiseRequestComponent> {
  final albumKey = GlobalKey<FormState>();

  List<PostMedia> mediaImageList = [];
  List<PostMedia> mediaVideoList = [];
  TextEditingController discCont = TextEditingController();
  late CameraController _cameraController;
  bool _isVideoCameraSelected = false;
  bool _isRecordingInProgress = false;

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
    _cameraController.dispose();
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

                          var mediaList = [
                            ...mediaImageList,
                            ...mediaVideoList
                          ];

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
}

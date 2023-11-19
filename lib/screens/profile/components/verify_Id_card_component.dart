import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/controllers/user_controller.dart';
import 'package:socialv/screens/common/fail_dialog.dart';
import 'package:socialv/screens/common/loading_dialog.dart';
import 'package:socialv/screens/profile/screens/verify_face_screen.dart';
import '../../../components/loading_widget.dart';
import '../../../main.dart';
import '../../../models/common_models.dart';
import '../../../utils/cached_network_image.dart';
import '../../../utils/colors.dart';
import '../../../utils/common.dart';
import '../../../utils/constants.dart';

class VerifyIdCardComponent extends StatefulWidget {
  final Function(int)? onNextPage;

  VerifyIdCardComponent({Key? key, this.onNextPage}) : super(key: key);

  @override
  State<VerifyIdCardComponent> createState() => _VerifyIdCardComponentState();
}

class _VerifyIdCardComponentState extends State<VerifyIdCardComponent> {
  PostMedia? frontIdMedia;
  PostMedia? backIdMedia;

  late UserController userController = Get.put(UserController());
  late CameraController _cameraController;

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
    _cameraController.dispose();
    _cameraController.stopImageStream();
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
                    "Take a photo of the front of your ID card",
                    style: primaryTextStyle(
                        color: appStore.isDarkMode ? bodyDark : bodyWhite,
                        size: 18),
                  ),
                  16.height,
                  Stack(
                    children: [
                      DottedBorderWidget(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        radius: defaultAppButtonRadius,
                        dotsWidth: 8,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            frontIdMedia == null
                                ? IconButton(
                                    color: appColorPrimary,
                                    icon: Icon(Icons.camera_alt_outlined),
                                    iconSize: 40,
                                    onPressed: () async {
                                      onCaptureImage('frontId');
                                    },
                                  ).center()
                                : Stack(
                                    children: [
                                      cachedImage(
                                              frontIdMedia!.isLink
                                                  ? frontIdMedia!.link
                                                  : frontIdMedia!.file!.path
                                                      .validate(),
                                              height: 150,
                                              width: 330,
                                              fit: BoxFit.cover)
                                          .cornerRadiusWithClipRRect(
                                              commonRadius),
                                      Positioned(
                                        child: Icon(Icons.cancel_outlined,
                                                color: Colors.white, size: 18)
                                            .onTap(() {
                                          frontIdMedia = null;
                                          setState(() {});
                                        },
                                                splashColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent),
                                        right: 4,
                                        top: 4,
                                      ),
                                    ],
                                  ).center(),
                          ],
                        ),
                      ),
                    ],
                  ).paddingAll(16),
                  20.height,
                  Text(
                    "Take a photo of the back of your ID card",
                    style: primaryTextStyle(
                        color: appStore.isDarkMode ? bodyDark : bodyWhite,
                        size: 18),
                  ),
                  16.height,
                  Stack(
                    children: [
                      DottedBorderWidget(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        radius: defaultAppButtonRadius,
                        dotsWidth: 8,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            backIdMedia == null
                                ? IconButton(
                                    color: appColorPrimary,
                                    icon: Icon(Icons.camera_alt_outlined),
                                    iconSize: 40,
                                    onPressed: () async {
                                      onCaptureImage('backId');
                                    },
                                  ).center()
                                : Stack(
                                    children: [
                                      cachedImage(
                                              backIdMedia!.isLink
                                                  ? backIdMedia!.link
                                                  : backIdMedia!.file!.path
                                                      .validate(),
                                              height: 150,
                                              width: 330,
                                              fit: BoxFit.cover)
                                          .cornerRadiusWithClipRRect(
                                              commonRadius),
                                      Positioned(
                                        child: Icon(Icons.cancel_outlined,
                                                color: Colors.white, size: 18)
                                            .onTap(() {
                                          backIdMedia = null;
                                          setState(() {});
                                        },
                                                splashColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent),
                                        right: 4,
                                        top: 4,
                                      ),
                                    ],
                                  ).center(),
                          ],
                        ),
                      ),
                    ],
                  ).paddingAll(16),
                  30.height,
                  Align(
                    alignment: Alignment.center,
                    child: appButton(
                      text: 'Continue',
                      onTap: () async {
                        if (frontIdMedia != null && backIdMedia != null) {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return LoadingDialog();
                              });
                          await userController.verifyIdCard(
                              frontIdMedia!, backIdMedia!);

                          if (userController.isVerifySuccess.value) {
                            Navigator.pop(context);
                            VerifyFaceScreen(frontIdMedia: frontIdMedia!)
                                .launch(context);
                          } else {
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return FailDialog(
                                    text: userController.message.value);
                              },
                            );
                          }
                        } else {
                          toast(
                              'Pleases take a photo of your front and back Identity Card');
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

  Future<void> onCaptureImage(String mediaType) async {
    //appStore.setLoading(true);
    bool isDataDetected = false;
    int frameCount = 0;
    StreamController<bool> dataDetectedController = StreamController<bool>();
    final cameras = await availableCameras();
    final camera = cameras[0];

    _cameraController = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );
    await _cameraController.initialize();

    _cameraController.startImageStream((CameraImage image) async {
      frameCount++;
      if (frameCount % 10 == 0) {
        // process every 10th frame
        isDataDetected = await checkImageData(image, mediaType);
        dataDetectedController.add(isDataDetected);
      }
    });

    await showDialog(
      context: context,
      builder: (context) => Stack(
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
          Center(
            child: StreamBuilder<bool>(
              stream: dataDetectedController.stream,
              initialData: false,
              builder: (context, snapshot) {
                bool isDataDetected = snapshot.data ?? false;
                return Container(
                  padding: EdgeInsets.all(30),
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  decoration: BoxDecoration(
                    color: isDataDetected
                        ? Color.fromARGB(75, 76, 175, 79)
                        : Color.fromARGB(75, 244, 67, 54),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isDataDetected ? Colors.green : Colors.red,
                      width: 3.0,
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: GestureDetector(
              child: Image.asset(
                'assets/icons/ic_capture.png',
                height: 60,
                width: 60,
                color: Colors.white,
              ),
              onTap: () async {
                if (isDataDetected) {
                  var value = await _cameraController.takePicture();

                  mediaType == 'frontId'
                      ? frontIdMedia = PostMedia(file: File(value.path))
                      : backIdMedia = PostMedia(file: File(value.path));

                  setState(() {});
                  Navigator.pop(context);
                } else {
                  toast('Please place your ID card in the frameeee!');
                }
              },
            ),
          ),
        ],
      ),
    );

    if (_cameraController.value.isStreamingImages) {
      _cameraController.stopImageStream();
    }
    dataDetectedController.close();
  }

  Future<bool> checkImageData(CameraImage image, String type) async {
    // Convert the CameraImage to InputImage
    final WriteBuffer allBytes = WriteBuffer();
    for (Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
        Size(image.width.toDouble(), image.height.toDouble());

    final InputImageRotation rotation = InputImageRotation.rotation0deg;

    final InputImageFormat format =
        image.format.group == ImageFormatGroup.yuv420
            ? InputImageFormat.yuv420
            : InputImageFormat.bgra8888;

    final inputImage = InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: imageSize,
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes[0].bytesPerRow,
      ),
    );

    // Create an instance of TextRecognizer
    TextRecognizer textRecognizer = TextRecognizer();

    // Process the image and get the detected text
    RecognizedText text = await textRecognizer.processImage(inputImage);

    // Close the TextRecognizer
    textRecognizer.close();

    // Check if the detected text is not null or empty
    bool hasData = type == 'frontId'
        ? text.text.toLowerCase().contains('citizen') ||
            text.text.toLowerCase().contains('căn cước công dân') ||
            text.text.toLowerCase().contains('căn cước')
        : text.text.toLowerCase().contains('Personal identification') ||
            text.text.toLowerCase().contains('Personal') ||
            text.text.toLowerCase().contains('identification');
    return hasData;
  }
}

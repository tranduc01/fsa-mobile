import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/screens/common/fail_dialog.dart';
import 'package:socialv/screens/common/loading_dialog.dart';
import '../../../components/loading_widget.dart';
import '../../../controllers/user_controller.dart';
import '../../../main.dart';
import '../../../models/common_models.dart';
import '../../../utils/cached_network_image.dart';
import '../../../utils/colors.dart';
import '../../../utils/common.dart';
import '../../../utils/constants.dart';

class VerifyFaceComponent extends StatefulWidget {
  final Function(int)? onNextPage;
  final PostMedia frontIdMedia;

  VerifyFaceComponent({required this.frontIdMedia, Key? key, this.onNextPage})
      : super(key: key);

  @override
  State<VerifyFaceComponent> createState() => _VerifyFaceComponentState();
}

class _VerifyFaceComponentState extends State<VerifyFaceComponent> {
  PostMedia? portraitMedia;

  late UserController userController = Get.put(UserController());
  late CameraController _cameraController;
  final faceDetector = FaceDetector(options: FaceDetectorOptions());

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
    //_cameraController.stopImageStream();
    faceDetector.close();
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
                    "Take a photo of your portrait",
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
                            portraitMedia == null
                                ? IconButton(
                                    color: appColorPrimary,
                                    icon: Icon(Icons.camera_alt_outlined),
                                    iconSize: 40,
                                    onPressed: () async {
                                      onCaptureImage('potraitMedia');
                                    },
                                  ).center()
                                : Stack(
                                    children: [
                                      cachedImage(
                                              portraitMedia!.isLink
                                                  ? portraitMedia!.link
                                                  : portraitMedia!.file!.path
                                                      .validate(),
                                              height: 400,
                                              width: 330,
                                              fit: BoxFit.cover)
                                          .cornerRadiusWithClipRRect(
                                              commonRadius),
                                      Positioned(
                                        child: Icon(Icons.cancel_outlined,
                                                color: Colors.white, size: 18)
                                            .onTap(() {
                                          portraitMedia = null;
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
                      text: 'Verify',
                      onTap: () async {
                        if (portraitMedia != null) {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return LoadingDialog();
                              });
                          await userController.verifyFace(
                              widget.frontIdMedia, portraitMedia!);
                          if (userController.isVerifySuccess.value) {
                            Navigator.pop(context);
                            userController.user.value.isVerified = true;
                            toast('User Verify Successfully!');
                            Navigator.pop(context);
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
                          toast('Please take a photo of your portrait!');
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
    final camera = cameras[1];
    _cameraController = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _cameraController.initialize();

    await _cameraController.startImageStream((CameraImage image) async {
      frameCount++;
      if (frameCount % 10 == 0) {
        // process every 10th frame
        var faces = await detectFace(image, faceDetector);
        isDataDetected = faces.isNotEmpty;
        dataDetectedController.add(isDataDetected);
        setState(() {});
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
          // for (final face in faces)
          //   Positioned(
          //       left: face.boundingBox.left,
          //       top: face.boundingBox.top,
          //       width: face.boundingBox.width,
          //       height: face.boundingBox.height,
          //       child: CustomPaint(
          //         painter: FaceRectanglePainter(face.boundingBox),
          //       )),
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
                  _cameraController.stopImageStream();
                  var value = await _cameraController.takePicture();
                  portraitMedia = PostMedia(file: File(value.path));
                  setState(() {});
                  Navigator.pop(context);
                } else {
                  toast('Please keep your face on the camera!');
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
    faceDetector.close();
    dataDetectedController.close();
  }

  Future<List<Face>> detectFace(
      CameraImage image, FaceDetector faceDetector) async {
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

    // Create an instance of FaceDetector
    print('detectFace');
    // Process the image and get the detected face
    final List<Face> faces = await faceDetector.processImage(inputImage);
    faces.forEach((element) {
      print('BB: ' + element.boundingBox.toString());
    });
    print(faces.length);
    // Close the FaceDetector
    //faceDetector.close();

    return faces;
  }
}

class FaceRectanglePainter extends CustomPainter {
  final Rect boundingBox;

  FaceRectanglePainter(this.boundingBox);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Calculate the adjusted bounding box coordinates based on the canvas size
    final adjustedBoundingBox = Rect.fromLTRB(
      boundingBox.left * size.width,
      boundingBox.top * size.height,
      boundingBox.right * size.width,
      boundingBox.bottom * size.height,
    );

    // Draw the rectangle on the canvas
    canvas.drawRect(adjustedBoundingBox, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

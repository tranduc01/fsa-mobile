import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/controllers/gallery_controller.dart';
import '../../../components/loading_widget.dart';
import '../../../main.dart';
import '../../../models/common_models.dart';
import '../../../utils/cached_network_image.dart';
import '../../../utils/colors.dart';
import '../../../utils/common.dart';
import '../../../utils/constants.dart';

class VerifyUserComponent extends StatefulWidget {
  final Function(int)? onNextPage;

  VerifyUserComponent({Key? key, this.onNextPage}) : super(key: key);

  @override
  State<VerifyUserComponent> createState() => _VerifyUserComponentState();
}

int? albumId;

class _VerifyUserComponentState extends State<VerifyUserComponent> {
  PostMedia? frontIdMedia;
  PostMedia? backIdMedia;
  PostMedia? portraitMedia;
  TextEditingController titleCont = TextEditingController();
  TextEditingController discCont = TextEditingController();
  FocusNode titleNode = FocusNode();
  FocusNode discNode = FocusNode();

  late GalleryController galleryController = Get.put(GalleryController());
  late CameraController _cameraController;

  @override
  void initState() {
    super.initState();
  }

  bool detectPhraseMatch(String paragraph, String target) {
    List<String> words = paragraph.split(' ');
    for (String word in words) {
      if (word.length >= 12 && word.contains(target)) {
        return true;
      }
    }
    return false;
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    titleNode.dispose();
    discNode.dispose();
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
                                      onCaptureImage('portraitId');
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
                        // showDialog(
                        //     context: context,
                        //     barrierDismissible: false,
                        //     builder: (context) {
                        //       return Dialog(
                        //         shadowColor: Colors.transparent,
                        //         backgroundColor: Colors.transparent,
                        //         child: Image.asset(
                        //           'assets/icons/loading.gif',
                        //           height: 180,
                        //           width: 180,
                        //         ),
                        //       );
                        //     });
                        // await galleryController.createAlbum(
                        //     titleCont.text, discCont.text, mediaList);
                        Future.delayed(Duration(seconds: 3), () async {
                          String path = "";
                          await getImageSource(isCamera: false, isVideo: false)
                              .then((value) {
                            appStore.setLoading(false);
                            path = value!.path;
                            setState(() {});
                          }).catchError((e) {
                            log('Error: ${e.toString()}');
                            appStore.setLoading(false);
                          });
                          final textDetector =
                              GoogleMlKit.vision.textRecognizer();
                          final inputImage = InputImage.fromFilePath(path);
                          final RecognizedText recognisedText =
                              await textDetector.processImage(inputImage);
                          //Navigator.pop(context);

                          var text = recognisedText.text;
                          print(text);
                          detectPhraseMatch(text.toLowerCase(),
                                  'CĂN CƯỚC CÔNG DÂN'.toLowerCase())
                              ? toast('Match')
                              : toast('Not Match');

                          // if (galleryController.isCreateSuccess.value) {
                          //   galleryController.fetchAlbums();
                          //   Navigator.pop(context);
                          //   toast('Album Created Successfully');
                          //   Navigator.pop(context);
                          // } else {
                          //   Navigator.pop(context);
                          //   showDialog(
                          //     context: context,
                          //     barrierDismissible: false,
                          //     builder: (context) {
                          //       return Dialog(
                          //         shape: RoundedRectangleBorder(
                          //           borderRadius: BorderRadius.circular(20),
                          //         ),
                          //         child: Container(
                          //           width: 200,
                          //           padding: EdgeInsets.all(16),
                          //           child: Column(
                          //             mainAxisSize: MainAxisSize.min,
                          //             children: [
                          //               Image.asset('assets/images/fail.gif'),
                          //               SizedBox(
                          //                 height: 20,
                          //               ),
                          //               Text(
                          //                 'Create Failed',
                          //                 textAlign: TextAlign.center,
                          //                 style: TextStyle(
                          //                     color: Colors.black,
                          //                     fontWeight: FontWeight.bold,
                          //                     fontSize: 20),
                          //               ),
                          //               SizedBox(height: 20),
                          //               Text(
                          //                 'Please try again!',
                          //                 textAlign: TextAlign.center,
                          //                 style: TextStyle(
                          //                   color: const Color.fromARGB(
                          //                       106, 0, 0, 0),
                          //                 ),
                          //               ),
                          //               SizedBox(height: 20),
                          //               Center(
                          //                 child: ElevatedButton(
                          //                   onPressed: () {
                          //                     Navigator.pop(context);
                          //                   },
                          //                   child: Text(
                          //                     'Try Again',
                          //                     style: TextStyle(
                          //                         fontWeight: FontWeight.bold,
                          //                         color: Colors.black),
                          //                   ),
                          //                   style: ButtonStyle(
                          //                     backgroundColor:
                          //                         MaterialStateColor
                          //                             .resolveWith((states) {
                          //                       if (states.contains(
                          //                           MaterialState.pressed)) {
                          //                         return const Color.fromARGB(
                          //                             137, 244, 67, 54);
                          //                       }
                          //                       return Colors.white;
                          //                     }),
                          //                     shape: MaterialStateProperty.all<
                          //                         RoundedRectangleBorder>(
                          //                       RoundedRectangleBorder(
                          //                           borderRadius:
                          //                               BorderRadius.circular(
                          //                                   10),
                          //                           side: BorderSide(
                          //                               color: Colors.red,
                          //                               width: 2)),
                          //                     ),
                          //                   ),
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       );
                          //     },
                          //   );
                          // }
                        });
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
    StreamController<bool> dataDetectedController = StreamController<bool>();
    final cameras = await availableCameras();
    final camera = mediaType == 'frontId' || mediaType == 'backId'
        ? cameras[0]
        : cameras[1];
    _cameraController = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );
    await _cameraController.initialize();
    // Timer timer = Timer.periodic(Duration(seconds: 2), (Timer t) async {
    //   if (_cameraController.value.isStreamingImages) {
    //     _cameraController.stopImageStream();
    //     _cameraController.startImageStream((CameraImage image) async {
    //       // Process the image, e.g., detect data
    //       isDataDetected = await checkImageData(image);
    //       dataDetectedController.add(isDataDetected);
    //     });
    //   }
    // });
    _cameraController.startImageStream((CameraImage image) async {
      // Process the image, e.g., detect data
      isDataDetected = await checkImageData(image);
      dataDetectedController.add(isDataDetected);
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
          )),
          // Positioned(
          //   bottom: 120,
          //   left: 0,
          //   right: 0,
          //   child: Container(
          //     padding: EdgeInsets.all(20),
          //     height: 40,
          //     decoration: BoxDecoration(
          //       color: const Color.fromARGB(154, 255, 255, 255),
          //       borderRadius: BorderRadius.circular(10),
          //     ),
          //     child: Center(
          //       child: Text(
          //         'Place your ID card in the frame',
          //         style: TextStyle(
          //           color: Colors.black,
          //           fontFamily: 'Roboto',
          //           fontWeight: FontWeight.bold,
          //           fontSize: 16,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: GestureDetector(
              child: Image.asset(
                'assets/icons/ic_capture.png',
                height: 60,
                width: 60,
                color: Colors.black,
              ),
              onTap: () async {
                var value = await _cameraController.takePicture();
                if (mediaType == 'potraitMedia') {}
                mediaType == 'frontId'
                    ? frontIdMedia = PostMedia(file: File(value.path))
                    : mediaType == 'backId'
                        ? backIdMedia = PostMedia(file: File(value.path))
                        : portraitMedia = PostMedia(file: File(value.path));
                setState(() {});
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
    //timer.cancel();
    if (_cameraController.value.isStreamingImages) {
      _cameraController.stopImageStream();
    }
    dataDetectedController.close();
  }

  Future<bool> checkImageData(CameraImage image) async {
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
    TextRecognizer textRecognizer = GoogleMlKit.vision.textRecognizer();

    // Process the image and get the detected text
    RecognizedText text = await textRecognizer.processImage(inputImage);

    // Close the TextRecognizer
    textRecognizer.close();

    // Check if the detected text is not null or empty
    bool hasData = text.blocks.isNotEmpty;
    print('checkImageData returning: $hasData');
    return hasData;
  }
}

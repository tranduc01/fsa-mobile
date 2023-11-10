import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
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
    final cameras = await availableCameras();
    final camera = mediaType == 'frontId' || mediaType == 'backId'
        ? cameras[0]
        : cameras[1];
    _cameraController = CameraController(
      camera,
      ResolutionPreset.ultraHigh,
      enableAudio: false,
    );
    await _cameraController.initialize();
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
            child: Container(
              padding: EdgeInsets.all(30),
              width: MediaQuery.of(context).size.width,
              height: 250,
              decoration: BoxDecoration(
                color: Color.fromARGB(37, 76, 175, 79),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Color.fromARGB(198, 76, 175, 79),
                  width: 3.0,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 120,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(20),
              height: 40,
              decoration: BoxDecoration(
                color: const Color.fromARGB(154, 255, 255, 255),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  'Place your ID card in the frame',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
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
  }
}

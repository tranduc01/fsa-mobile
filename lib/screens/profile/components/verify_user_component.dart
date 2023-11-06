import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
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
                                      onSelectMedia('frontId');
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
                                              fit: BoxFit.fitWidth)
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
                                      onSelectMedia('backId');
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
                                              fit: BoxFit.fitWidth)
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
                                      onSelectMedia('portraitId');
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
                                              fit: BoxFit.fill)
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
                        // await galleryController.createAlbum(
                        //     titleCont.text, discCont.text, mediaList);
                        Future.delayed(Duration(seconds: 3), () {
                          Navigator.pop(context);
                          Navigator.pop(context);
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

  Future<void> onSelectMedia(String mediaType) async {
    final idCardWidth = 85.6;
    final idCardHeight = 53.98;
    final cameras = await availableCameras();
    final camera = cameras[0];

    //appStore.setLoading(true);
    _cameraController = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );
    await _cameraController.initialize();
    await showDialog(
      context: context,
      builder: (context) => AspectRatio(
          aspectRatio: idCardWidth / idCardHeight,
          child: CameraPreview(_cameraController)),
    );
    // await getImageSource(isCamera: true, isVideo: false).then((value) {
    //   appStore.setLoading(false);

    //   mediaType == 'frontId'
    //       ? frontIdMedia = PostMedia(file: value)
    //       : mediaType == 'backId'
    //           ? backIdMedia = PostMedia(file: value)
    //           : portraitMedia = PostMedia(file: value);
    //   setState(() {});
    // }).catchError((e) {
    //   log('Error: ${e.toString()}');
    //   appStore.setLoading(false);
    // });
  }
}
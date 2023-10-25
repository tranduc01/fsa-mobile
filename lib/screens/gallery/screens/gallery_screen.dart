import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/utils/app_constants.dart';
import '../../../components/loading_widget.dart';
import '../../../components/no_data_lottie_widget.dart';
import '../../../controllers/gallery_controller.dart';
import '../../../main.dart';
import '../../../models/gallery/albums.dart';
import '../../../models/posts/media_model.dart';
import '../components/gallery_screen_album_component.dart';
import '../components/gallery_create_album_button.dart';
import 'create_album_screen.dart';
import 'single_album_detail_screen.dart';

class GalleryScreen extends StatefulWidget {
  final int? groupId;
  final int? userId;
  final bool canEdit;

  GalleryScreen({Key? key, this.groupId, this.userId, this.canEdit = false})
      : super(key: key);

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

List<MediaModel> mediaTypeList = [
  MediaModel(allowedType: ['image'], isActive: true, title: 'Image'),
  MediaModel(allowedType: ['video'], isActive: true, title: 'Video')
];

class _GalleryScreenState extends State<GalleryScreen> {
  int selectedIndex = 0;
  bool isError = false;
  ScrollController scrollCont = ScrollController();
  int mPage = 1;
  bool mIsLastPage = false;
  bool isAlbumEmpty = false;
  bool isRefresh = false;

  late GalleryController galleryController = Get.put(GalleryController());

  @override
  void initState() {
    super.initState();
    setStatusBarColorBasedOnTheme();
    afterBuildCreated(
      () {
        scrollCont.addListener(
          () {
            if (scrollCont.position.pixels ==
                scrollCont.position.maxScrollExtent) {
              if (!mIsLastPage) {
                mPage++;
                //futureAlbum = fetchAlbums();
              }
            }
          },
        );
      },
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    if (appStore.isLoading) appStore.setLoading(false);
    setStatusBarColorBasedOnTheme();
    scrollCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.scaffoldBackgroundColor,
        title: Text(language.gallery, style: boldTextStyle(size: 20)),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            finish(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          FutureBuilder<List<Album>>(
            future: galleryController.fetchAlbums(),
            builder: (context, snap) {
              return Obx(() {
                if (galleryController.isLoading.value) {
                  return LoadingWidget();
                } else {
                  if (snap.hasError || isError) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: NoDataWidget(
                        imageWidget: NoDataLottieWidget(),
                        title: isError
                            ? language.somethingWentWrong
                            : language.noDataFound,
                        onRetry: () {
                          galleryController.fetchAlbums();
                        },
                        retryText: '   ${language.clickToRefresh}   ',
                      ).center(),
                    );
                  } else if (snap.hasData) {
                    return SingleChildScrollView(
                      controller: scrollCont,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (galleryController.albums.isEmpty)
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.74,
                              child: !widget.canEdit.validate() &&
                                      !appStore.isLoading
                                  ? NoDataWidget(
                                      imageWidget: NoDataLottieWidget(),
                                      title: language.noDataFound,
                                      onRetry: () {
                                        galleryController.fetchAlbums();
                                      },
                                      retryText:
                                          '   ${language.clickToRefresh}   ',
                                    ).center()
                                  : GalleryCreateAlbumButton(
                                      isEmptyList: true,
                                      mediaTypeList: mediaTypeList,
                                      callback: () {
                                        CreateAlbumScreen(
                                                mediaTypeList: mediaTypeList,
                                                groupID: widget.groupId)
                                            .launch(context)
                                            .then(
                                          (value) {
                                            if (value == true) {
                                              galleryController.fetchAlbums();
                                              isAlbumCreated = false;
                                              isAlbumEmpty = false;
                                              isRefresh = true;
                                            }
                                          },
                                        );
                                      },
                                    ),
                            ),
                          if (galleryController.albums.isNotEmpty)
                            Column(
                              children: [
                                if (widget.canEdit.validate())
                                  GalleryCreateAlbumButton(
                                    mediaTypeList: mediaTypeList,
                                    isEmptyList: false,
                                    callback: () {
                                      CreateAlbumScreen(
                                              mediaTypeList: mediaTypeList,
                                              groupID: widget.groupId)
                                          .launch(context)
                                          .then(
                                        (value) {
                                          if (value == true) {
                                            galleryController.fetchAlbums();
                                            isAlbumCreated = false;
                                            isAlbumEmpty = false;
                                            isRefresh = true;
                                          }
                                        },
                                      );
                                    },
                                  ),
                                8.height,
                                GridView.builder(
                                  itemCount: galleryController.albums.length,
                                  padding: EdgeInsets.only(
                                      bottom: mIsLastPage ? 16 : 60,
                                      left: 16,
                                      right: 16),
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 1,
                                    crossAxisSpacing: 8,
                                    mainAxisExtent: 160,
                                    mainAxisSpacing: 8,
                                  ),
                                  itemBuilder: (context, index) {
                                    Album album =
                                        galleryController.albums[index];
                                    return GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () {
                                        SingleAlbumDetailScreen(
                                          album: album,
                                          canEdit: widget.canEdit,
                                        ).launch(context,
                                            pageRouteAnimation:
                                                PageRouteAnimation.Fade);
                                      },
                                      child: GalleryScreenAlbumComponent(
                                        album: album,
                                        canDelete: album.canDelete.validate(),
                                        callback: (albumId) {
                                          galleryController
                                              .deleteAlbum(albumId)
                                              .then((value) => galleryController
                                                  .albums
                                                  .removeWhere((element) =>
                                                      element.id == albumId));
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                        ],
                      ),
                    );
                  } else {
                    return Offstage();
                  }
                }
              });
            },
          ),
          Positioned(
            bottom:
                galleryController.albums.isNotEmpty && mPage != 1 ? 8 : null,
            width: galleryController.albums.isNotEmpty && mPage != 1
                ? MediaQuery.of(context).size.width
                : null,
            child: Observer(
                builder: (_) =>
                    LoadingWidget(isBlurBackground: mPage == 1 ? true : false)
                        .center()
                        .visible(appStore.isLoading)),
          ),
        ],
      ),
    );
  }
}

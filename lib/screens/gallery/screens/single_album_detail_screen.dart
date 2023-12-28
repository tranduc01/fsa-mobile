import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/controllers/gallery_controller.dart';
import 'package:socialv/main.dart';
import 'package:socialv/screens/gallery/components/album_media_component.dart';
import 'package:socialv/screens/gallery/components/create_album_component.dart';

import '../../../components/loading_widget.dart';
import '../../../components/no_data_lottie_widget.dart';
import '../../../models/gallery/albums.dart';
import 'add_media_screen.dart';

class SingleAlbumDetailScreen extends StatefulWidget {
  final Album album;
  final bool canEdit;

  const SingleAlbumDetailScreen(
      {Key? key, required this.album, this.canEdit = false})
      : super(key: key);

  @override
  State<SingleAlbumDetailScreen> createState() =>
      _SingleAlbumDetailScreenState();
}

class _SingleAlbumDetailScreenState extends State<SingleAlbumDetailScreen> {
  ScrollController scrollCont = ScrollController();
  bool isError = false;
  int mPage = 1;
  bool mIsLastPage = false;
  bool isUpdateState = false;

  late GalleryController galleryController = Get.put(GalleryController());

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await galleryController.fetchAlbum(widget.album.id!);
    });
    scrollCont.addListener(() {
      if (scrollCont.position.pixels == scrollCont.position.maxScrollExtent) {
        if (!mIsLastPage) {
          mPage++;
        }
      }
    });
  }

  updatePublic(bool isPublic) async {
    String action = isPublic ? 'public' : 'private';
    showConfirmDialogCustom(
      context,
      title: 'Are you sure you want to ' + action + ' this collection?',
      onAccept: (p0) async {
        await galleryController.updateAlbum(widget.album, null, null, isPublic);
        await galleryController.fetchAlbum(widget.album.id!);
        galleryController.update();
      },
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.scaffoldBackgroundColor,
        title: Text(language.album, style: boldTextStyle(size: 20)),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            galleryController.fetchAlbums();
            finish(context);
          },
        ),
        actions: [
          Obx(
            () => Row(
              children: [
                Text('Public', style: boldTextStyle()),
                5.width,
                CupertinoSwitch(
                  thumbColor: Colors.white,
                  trackColor: Colors.black12,
                  value: galleryController.album.value.isPublic.validate(),
                  onChanged: (value) => {
                    updatePublic(value),
                  },
                ),
              ],
            ),
          )
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          ListView.builder(
            itemCount: 1,
            itemBuilder: (context, snap) {
              return SingleChildScrollView(
                controller: scrollCont,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: "${language.title}: ",
                        style: boldTextStyle(),
                        children: [
                          TextSpan(
                              text: widget.album.title,
                              style: primaryTextStyle()),
                        ],
                      ),
                    ),
                    16.height,
                    RichText(
                      text: TextSpan(
                        text: "${language.description}: ",
                        style: boldTextStyle(),
                        children: [
                          TextSpan(
                              text: widget.album.description,
                              style: primaryTextStyle()),
                        ],
                      ),
                    ),
                    Obx(() {
                      if (galleryController
                          .album.value.media.isEmpty) if (widget.canEdit
                              .validate() &&
                          !appStore.isLoading)
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            50.height,
                            Text(language.emptyAlbum, style: boldTextStyle()),
                            8.height,
                            IconButton(
                              onPressed: () {
                                albumId = widget.album.id.validate().toInt();
                                AddMediaScreen(
                                  fileType: 'photo',
                                  album: widget.album,
                                ).launch(context).then((value) {
                                  widget.album.media.toList();
                                });
                              },
                              icon: Icon(Icons.add_a_photo_outlined,
                                  color: Colors.black, size: 50),
                            ),
                          ],
                        ).center();
                      else
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.74,
                          child: NoDataWidget(
                            imageWidget: NoDataLottieWidget(),
                            title: isError
                                ? language.somethingWentWrong
                                : language.noDataFound,
                            onRetry: () {
                              widget.album.media.toList();
                            },
                            retryText: '   ${language.clickToRefresh}   ',
                          ).center(),
                        );
                      else if (galleryController.isLoading.value)
                        return ThreeBounceLoadingWidget();
                      else
                        return GridView.builder(
                          itemCount: galleryController.album.value.media.length,
                          padding: EdgeInsets.only(
                              bottom: mIsLastPage ? 16 : 60, top: 16),
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
                            Media media =
                                galleryController.album.value.media[index];
                            return AlbumMediaComponent(
                              mediaId: media.id,
                              mediaType: media.type,
                              canDelete: media.canDelete.validate(),
                              thumbnail: media.url.validate(),
                              mediaUrl: media.url.validate(),
                              onDelete: (mediaId) async {
                                var ids = <int>[];
                                ids.add(mediaId);
                                await galleryController.updateAlbum(
                                    widget.album, null, ids, null);

                                await galleryController
                                    .fetchAlbum(widget.album.id!);
                                galleryController.update();
                              },
                            );
                          },
                        );
                    })
                  ],
                ).paddingAll(16),
              );
            },
          ),
        ],
      ),
      floatingActionButton: widget.canEdit.validate()
          ? Obx(() => FloatingActionButton(
                onPressed: () {
                  albumId = widget.album.id.validate().toInt();
                  AddMediaScreen(album: widget.album, fileType: 'photo')
                      .launch(context)
                      .then((value) {
                    widget.album.media.toList();
                  });
                },
                child: Icon(Icons.add, color: Colors.white),
                backgroundColor: context.primaryColor,
              ).visible(galleryController.album.value.media.isNotEmpty))
          : null,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/controllers/gallery_controller.dart';
import 'package:socialv/controllers/topic_controller.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/gallery/albums.dart';
import 'package:socialv/screens/forums/components/forums_card_component.dart';
import 'package:socialv/screens/forums/screens/forum_detail_screen.dart';
import 'package:socialv/screens/forums/screens/single_discovery_album_detail_screen.dart';

import '../../../utils/app_constants.dart';
import '../../models/posts/topic.dart';
import '../expertise_request/expertise_request/components/video_media_component.dart';
import '../post/screens/image_screen.dart';
import '../post/screens/video_post_screen.dart';

class ForumsFragment extends StatefulWidget {
  final ScrollController controller;

  const ForumsFragment({super.key, required this.controller});

  @override
  State<ForumsFragment> createState() => _ForumsFragment();
}

var listImage = [
  "https://hoatuoithanhthao.com/media/ftp/hoa-lan-5.jpg",
  "https://hoatuoithanhthao.com/media/ftp/hoa-lan.jpg",
  "https://cdn.tgdd.vn/Files/2021/07/24/1370576/hoa-lan-tim-dac-diem-y-nghia-va-cach-trong-hoa-no-dep-202107242028075526.jpg",
  "https://lanhodiep.vn/wp-content/uploads/2022/10/hinh-nen-hoa-lan-ho-diep-1.jpg"
];

class _ForumsFragment extends State<ForumsFragment> {
  TextEditingController searchController = TextEditingController();
  late TopicController topicController = Get.put(TopicController());
  late GalleryController galleryController = Get.put(GalleryController());
  int mPage = 1;
  bool mIsLastPage = false;

  bool hasShowClearTextIcon = false;
  bool isError = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await topicController.fetchTopics();
      await galleryController.fetchAlbumsDiscovery();
    });
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    searchController.dispose();
    LiveStream().dispose(RefreshForumsFragment);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          16.height,
          Container(
            padding: EdgeInsets.only(left: 16),
            child: Text(
              language.topics,
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.27,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                AnimatedListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  slideConfiguration: SlideConfiguration(
                      delay: Duration(milliseconds: 80), verticalOffset: 300),
                  padding:
                      EdgeInsets.only(left: 16, right: 16, bottom: 10, top: 16),
                  itemCount: topicController.topics.length,
                  itemBuilder: (context, index) {
                    Topic data = topicController.topics[index];
                    return InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        ForumDetailScreen(
                          topic: data,
                        ).launch(context);
                      },
                      child: ForumsCardComponent(topic: data),
                    );
                  },
                ),
                if (topicController.isLoading.value)
                  Positioned(
                    bottom: mPage != 1 ? 10 : null,
                    child: LoadingWidget(
                        isBlurBackground: mPage == 1 ? true : false),
                  )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 16),
            child: Text(
              language.collections,
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            child: AnimatedListView(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: BouncingScrollPhysics(),
              slideConfiguration: SlideConfiguration(
                  delay: Duration(milliseconds: 80), verticalOffset: 300),
              padding:
                  EdgeInsets.only(left: 16, right: 16, bottom: 10, top: 16),
              itemCount: galleryController.albums.length,
              itemBuilder: (context, index) {
                Album data = galleryController.albums[index];
                return Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          data.user != null
                              ? data.user!.avatarUrl != null
                                  ? Image.network(
                                      data.user!.avatarUrl.validate(),
                                      height: 36,
                                      width: 36,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                          'assets/images/profile.png',
                                          height: 36,
                                          width: 36,
                                          fit: BoxFit.cover,
                                        ).cornerRadiusWithClipRRect(100);
                                      },
                                    ).cornerRadiusWithClipRRect(100)
                                  : Image.asset(
                                      'assets/images/profile.png',
                                      height: 36,
                                      width: 36,
                                      fit: BoxFit.cover,
                                    ).cornerRadiusWithClipRRect(100)
                              : Container(),
                          10.width,
                          Column(
                            children: [
                              TextIcon(
                                text: data.user!.name!,
                                textStyle: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                                suffix: data.user!.isVerified!
                                    ? Image.asset(ic_tick_filled,
                                        width: 20,
                                        height: 20,
                                        color: blueTickColor)
                                    : null,
                              ),
                              5.height,
                              Text(
                                convertToAgo(data.createdAt!.toString()),
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14),
                              ),
                            ],
                          )
                        ],
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: AnimatedListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          slideConfiguration: SlideConfiguration(
                              delay: Duration(milliseconds: 80),
                              verticalOffset: 300),
                          padding: EdgeInsets.only(
                              left: 16, right: 16, bottom: 10, top: 16),
                          itemCount:
                              data.media.length > 3 ? 4 : data.media.length,
                          itemBuilder: (context, index) {
                            Media media = data.media[index];
                            if (index == listImage.length - 1) {
                              return InkWell(
                                onTap: () {
                                  SingleAlbumDiscoveryDetailScreen(
                                    album: data,
                                  ).launch(context);
                                },
                                child: Container(
                                  width: 150,
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(34, 0, 0, 0),
                                      borderRadius: BorderRadius.circular(20)),
                                  padding: EdgeInsets.only(right: 10),
                                  child: Icon(Icons.more_horiz_rounded,
                                      size:
                                          30), // Replace with your desired icon
                                ),
                              );
                            } else {
                              return InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  media.type == 'image'
                                      ? ImageScreen(imageURl: media.url!)
                                          .launch(context)
                                      : VideoPostScreen(media.url!.validate())
                                          .launch(context);
                                },
                                child: Container(
                                  padding: EdgeInsets.only(right: 10),
                                  child: media.type == 'image'
                                      ? Image.network(
                                          media.url!,
                                        ).cornerRadiusWithClipRRect(20)
                                      : VideoMediaComponent(
                                          mediaUrl: media.url!,
                                        ).cornerRadiusWithClipRRect(20),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/controllers/topic_controller.dart';
import 'package:socialv/main.dart';
import 'package:socialv/screens/forums/components/forums_card_component.dart';
import 'package:socialv/screens/forums/screens/forum_detail_screen.dart';

import '../../../utils/app_constants.dart';
import '../../models/posts/topic.dart';
import '../post/screens/image_screen.dart';

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
  int mPage = 1;
  bool mIsLastPage = false;

  bool hasShowClearTextIcon = false;
  bool isError = false;

  @override
  void initState() {
    topicController.fetchTopics();
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
    return Column(
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
        // Container(
        //   width: context.width() - 32,
        //   margin: EdgeInsets.only(left: 16, right: 8),
        //   decoration: BoxDecoration(
        //       color: context.cardColor, borderRadius: radius(commonRadius)),
        //   child: AppTextField(
        //     controller: searchController,
        //     textFieldType: TextFieldType.USERNAME,
        //     onFieldSubmitted: (text) {
        //       mPage = 1;
        //       future = getForums();
        //     },
        //     decoration: InputDecoration(
        //       border: InputBorder.none,
        //       hintText: language.searchHere,
        //       hintStyle: secondaryTextStyle(),
        //       prefixIcon: Image.asset(
        //         ic_search,
        //         height: 16,
        //         width: 16,
        //         fit: BoxFit.cover,
        //         color: appStore.isDarkMode ? bodyDark : bodyWhite,
        //       ).paddingAll(16),
        //       suffixIcon: hasShowClearTextIcon
        //           ? IconButton(
        //               icon: Icon(Icons.cancel,
        //                   color: appStore.isDarkMode ? bodyDark : bodyWhite,
        //                   size: 18),
        //               onPressed: () {
        //                 hideKeyboard(context);
        //                 hasShowClearTextIcon = false;
        //                 searchController.clear();

        //                 mPage = 1;
        //                 getForums();
        //                 setState(() {});
        //               },
        //             )
        //           : null,
        //     ),
        //   ),
        // ),
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
                        forumId: data.id.validate(),
                        type: 'data.type.validate()',
                      );
                    },
                    child: ForumsCardComponent(topic: data),
                  );
                },
              ),
              Obx(
                () {
                  if (topicController.isLoading.value) {
                    return Positioned(
                      bottom: mPage != 1 ? 10 : null,
                      child: LoadingWidget(
                          isBlurBackground: mPage == 1 ? true : false),
                    );
                  } else {
                    return Offstage();
                  }
                },
              ),
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
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                children: [
                  Image.network(
                    'https://upload.wikimedia.org/wikipedia/commons/4/48/RedCat_8727.jpg',
                    width: 50,
                    height: 50,
                  ).cornerRadiusWithClipRRect(30),
                  10.width,
                  Text(
                    'Tên ở đây nè',
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
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
                      delay: Duration(milliseconds: 80), verticalOffset: 300),
                  padding:
                      EdgeInsets.only(left: 16, right: 16, bottom: 10, top: 16),
                  itemCount: listImage.length,
                  itemBuilder: (context, index) {
                    if (index == listImage.length - 1) {
                      // Last item, display the "see more" button
                      return InkWell(
                        onTap: () {},
                        child: Container(
                          width: 150,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(34, 0, 0, 0),
                              borderRadius: BorderRadius.circular(20)),
                          padding: EdgeInsets.only(right: 10),
                          child: Icon(Icons.more_horiz_rounded,
                              size: 30), // Replace with your desired icon
                        ),
                      );
                    } else {
                      return InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          ImageScreen(imageURl: listImage[index])
                              .launch(context);
                        },
                        child: Container(
                          padding: EdgeInsets.only(right: 10),
                          child: Image.network(
                            listImage[index],
                          ).cornerRadiusWithClipRRect(20),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

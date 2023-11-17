import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/controllers/post_controller.dart';
import 'package:socialv/screens/dashboard_screen.dart';
import 'package:socialv/screens/home/components/ad_component.dart';
import 'package:socialv/screens/home/components/suggested_user_component.dart';
import 'package:socialv/screens/post/components/post_component.dart';

import '../../components/loading_widget.dart';
import '../../components/no_data_lottie_widget.dart';
import '../../models/posts/post.dart';
import '../../utils/app_constants.dart';

class HomeFragment extends StatefulWidget {
  final ScrollController controller;

  const HomeFragment({super.key, required this.controller});

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late PostController postController = Get.put(PostController());
  List<Post> postList = [];
  late Future<List<Post>> future;

  int mPage = 1;
  bool mIsLastPage = false;

  @override
  void initState() {
    postController.fetchPosts();
    postList = postController.posts;
    _animationController = BottomSheet.createAnimationController(this);
    _animationController.duration = const Duration(milliseconds: 500);
    _animationController.drive(CurveTween(curve: Curves.easeOutQuad));

    super.initState();

    setStatusBarColorBasedOnTheme();

    widget.controller.addListener(() {
      /// pagination
      if (selectedIndex == 0) {
        if (widget.controller.position.pixels ==
            widget.controller.position.maxScrollExtent) {
          if (!mIsLastPage) {
            mPage++;
            future = postController.fetchPosts();
          }
        }
      }
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                15.height,
                Container(
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 280,
                      autoPlay: true,
                      aspectRatio: 2.0,
                      enlargeCenterPage: true,
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                    ),
                    items: postList
                        .map((item) => Container(
                              child: Container(
                                margin: EdgeInsets.all(5.0),
                                child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16)),
                                    child: Stack(
                                      children: <Widget>[
                                        Image.network(item.thumbnail!,
                                            fit: BoxFit.cover, width: 1000.0),
                                        Positioned(
                                          bottom: 0.0,
                                          left: 0.0,
                                          right: 0.0,
                                          child: Container(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Color.fromARGB(
                                                        213, 0, 0, 0),
                                                    Color.fromARGB(0, 0, 0, 0)
                                                  ],
                                                  begin: Alignment.bottomCenter,
                                                  end: Alignment.topCenter,
                                                ),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10.0,
                                                  horizontal: 20.0),
                                              child: Center(
                                                child: Text(
                                                  item.title!,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 17.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Roboto'),
                                                ),
                                              )),
                                        ),
                                      ],
                                    )),
                              ),
                            ))
                        .toList(),
                  ),
                ),
                10.height,
                AnimatedListView(
                  padding: EdgeInsets.only(bottom: mIsLastPage ? 16 : 60),
                  itemCount: postList.length,
                  slideConfiguration: SlideConfiguration(
                      delay: Duration(milliseconds: 80), verticalOffset: 300),
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        PostComponent(
                          post: postList[index],
                          callback: () {
                            mPage = 1;
                            future = postController.fetchPosts();
                          },
                        ).paddingSymmetric(horizontal: 8),
                        if ((index + 1) % 5 == 0) AdComponent(),
                        if ((index + 1) == 3) SuggestedUserComponent(),
                      ],
                    );
                  },
                  shrinkWrap: true,
                ),
              ],
            )),
        if (postController.isError.value && postList.isEmpty)
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: NoDataWidget(
              imageWidget: NoDataLottieWidget(),
              title: postController.isError.value
                  ? 'Something Went Wrong'
                  : 'No data found',
              onRetry: () {
                postController.isError.value = false;
              },
              retryText: '   Click to Refresh   ',
            ).center(),
          ),
        Positioned(
          bottom: postList.isNotEmpty || mPage != 1 ? 8 : null,
          child: Obx(() =>
              LoadingWidget(isBlurBackground: mPage == 1 ? true : false)
                  .center()
                  .visible(postController.isLoading.value)),
        ),
      ],
    );
  }
}

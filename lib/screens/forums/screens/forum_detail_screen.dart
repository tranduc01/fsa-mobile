import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/controllers/post_controller.dart';
import 'package:socialv/main.dart';

import '../../../components/no_data_lottie_widget.dart';
import '../../../models/posts/topic.dart';
import '../../post/components/post_component.dart';

class ForumDetailScreen extends StatefulWidget {
  final Topic topic;

  const ForumDetailScreen({Key? key, required this.topic}) : super(key: key);

  @override
  State<ForumDetailScreen> createState() => _ForumDetailScreenState();
}

class _ForumDetailScreenState extends State<ForumDetailScreen>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController = ScrollController();
  late PostController postController = Get.put(PostController());
  int mPage = 1;
  bool mIsLastPage = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await postController.fetchPostsByTopic(widget.topic.id!);
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!mIsLastPage) {
          mPage++;
          appStore.setLoading(true);
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
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        mPage = 1;
        //getDetails();
      },
      color: context.primaryColor,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chủ đề', style: boldTextStyle(size: 20)),
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              finish(context);
            },
          ),
        ),
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.topic.name.validate(),
                          style: boldTextStyle(size: 20))
                      .paddingSymmetric(horizontal: 16)
                      .onTap(() {},
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent)
                      .center(),
                  8.height,
                  ReadMoreText(
                    widget.topic.description.validate(),
                    trimLength: 100,
                    style: secondaryTextStyle(),
                    textAlign: TextAlign.center,
                  ).paddingSymmetric(horizontal: 16).center(),
                  16.height,
                  Obx(() {
                    if (postController.isLoading.value)
                      return LoadingWidget().center();
                    else if (postController.isError.value ||
                        postController.posts.isEmpty)
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: NoDataWidget(
                          imageWidget: NoDataLottieWidget(),
                          title: postController.isError.value
                              ? language.somethingWentWrong
                              : language.noDataFound,
                          onRetry: () {
                            postController.fetchPostsByTopic(widget.topic.id!);
                          },
                          retryText: '   ' + language.clickToRefresh + '   ',
                        ).center(),
                      );
                    else
                      return AnimatedListView(
                        padding: EdgeInsets.only(bottom: mIsLastPage ? 16 : 60),
                        itemCount: postController.posts.length,
                        slideConfiguration: SlideConfiguration(
                            delay: Duration(milliseconds: 80),
                            verticalOffset: 300),
                        itemBuilder: (context, index) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              PostComponent(
                                post: postController.posts[index],
                                callback: () {
                                  mPage = 1;
                                  postController.fetchPosts();
                                },
                              ).paddingSymmetric(horizontal: 8),
                            ],
                          );
                        },
                        shrinkWrap: true,
                      );
                  }),
                  70.height,
                ],
              ),
            ),
            Positioned(
              bottom: mPage != 1 ? 10 : null,
              child: LoadingWidget(isBlurBackground: mPage == 1 ? true : false)
                  .center()
                  .visible(appStore.isLoading),
            ),
          ],
        ),
      ),
    );
  }
}

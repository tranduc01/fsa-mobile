import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/common_models/post_mdeia_model.dart';
import 'package:socialv/models/posts/comment_model.dart';
import 'package:socialv/models/posts/get_post_likes_model.dart';
import 'package:socialv/models/posts/post_model.dart';
import 'package:socialv/models/reactions/reactions_count_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/dashboard_screen.dart';
import 'package:socialv/screens/home/components/ad_component.dart';
import 'package:socialv/screens/home/components/initial_home_component.dart';
import 'package:socialv/screens/home/components/suggested_user_component.dart';
import 'package:socialv/screens/post/components/post_component.dart';
import 'package:socialv/screens/stories/component/home_story_component.dart';

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

  List<PostModel> postList = [
    PostModel(
      activityId: 1,
      commentCount: 1,
      comments: [CommentModel()],
      content: "Test 1",
      dateRecorded: DateTime.parse("2023-01-01").toString(),
      isFavorites: 1,
      isLiked: 1,
      likeCount: 1,
      mediaList: ["Test Media"],
      mediaType: "photo",
      postIn: "123",
      userEmail: "example@gmail.com",
      userId: 1,
      userImage:
          "https://khoinguonsangtao.vn/wp-content/uploads/2022/09/hinh-ve-don-gian-cute-dang-yeu-va-de-thuc-hien.jpg",
      userName: "Tran Duc",
      isUserVerified: 1,
      usersWhoLiked: [GetPostLikesModel()],
      medias: [
        PostMediaModel(
            url:
                "https://i.pinimg.com/474x/94/b6/cc/94b6cc282430ef169df131de1ad12843.jpg")
      ],
      isFriend: 1,
      type: "",
      blogId: 1,
      childPost: PostModel(),
      groupId: 1,
      groupName: "Test",
      hasMentions: 1,
      reactions: [Reactions()],
      curUserReaction: null,
      reactionCount: 1,
      isPinned: 1,
    ),
    PostModel(
      activityId: 1,
      commentCount: 1,
      comments: [CommentModel()],
      content: "Test 2",
      dateRecorded: DateTime.parse("2023-05-01").toString(),
      isFavorites: 0,
      isLiked: 0,
      likeCount: 3,
      mediaList: ["Test Media"],
      mediaType: "gif",
      postIn: "123",
      userEmail: "example@gmail.com",
      userId: 1,
      userImage:
          "https://khoinguonsangtao.vn/wp-content/uploads/2022/09/hinh-ve-don-gian-cute-dang-yeu-va-de-thuc-hien.jpg",
      userName: "Tran Duc",
      isUserVerified: 1,
      usersWhoLiked: [GetPostLikesModel()],
      medias: [
        PostMediaModel(
            url:
                "https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExNHB4Z3UyOW55aXN2NjFxOTdoY3BramdqZmJzOHRtdjFpcDgwY2didyZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/6FxJBpNTBgWdJCXKD4/giphy.gif")
      ],
      isFriend: 3,
      type: "",
      blogId: 1,
      childPost: PostModel(),
      groupId: 1,
      groupName: "Test",
      hasMentions: 1,
      reactions: [Reactions()],
      curUserReaction: null,
      reactionCount: 3,
      isPinned: 0,
    )
  ];
  late Future<List<PostModel>> future;

  int mPage = 1;
  bool mIsLastPage = false;
  bool isError = false;

  @override
  void initState() {
    future = getPostList();

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
            future = getPostList();
          }
        }
      }
    });

    LiveStream().on(OnAddPost, (p0) {
      postList.clear();
      mPage = 1;
      future = getPostList();
    });
  }

  Future<List<PostModel>> getPostList() async {
    //appStore.setLoading(true);
    // await getPost(page: mPage, type: PostRequestType.all).then((value) {
    //   if (mPage == 1) postList.clear();

    //   mIsLastPage = value.length != PER_PAGE;
    //   postList.addAll(value);
    //   setState(() {});

    //   appStore.setLoading(false);
    // }).catchError((e) {
    //   isError = true;
    //   appStore.setLoading(false);
    //   toast(e.toString(), print: true);
    //   setState(() {});
    // });

    return postList;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    LiveStream().dispose(OnAddPost);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            10.height,
            AnimatedListView(
              padding: EdgeInsets.only(bottom: mIsLastPage ? 16 : 60),
              itemCount: postList.length,
              slideConfiguration: SlideConfiguration(
                  delay: 80.milliseconds, verticalOffset: 300),
              itemBuilder: (context, index) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PostComponent(
                      post: postList[index],
                      count: 0,
                      callback: () {
                        mPage = 1;
                        future = getPostList();
                      },
                      showHidePostOption: true,
                    ).paddingSymmetric(horizontal: 8),
                    if ((index + 1) % 5 == 0) AdComponent(),
                    if ((index + 1) == 3) SuggestedUserComponent(),
                  ],
                );
              },
              shrinkWrap: true,
            ),
          ],
        ),
        // if (!appStore.isLoading && isError && postList.isEmpty)
        //   SizedBox(
        //     height: context.height() * 0.8,
        //     child: NoDataWidget(
        //       imageWidget: NoDataLottieWidget(),
        //       title:
        //           isError ? language.somethingWentWrong : language.noDataFound,
        //       onRetry: () {
        //         isError = false;
        //         LiveStream().emit(OnAddPost);
        //       },
        //       retryText: '   ${language.clickToRefresh}   ',
        //     ).center(),
        //   ),
        // if (postList.isEmpty && !appStore.isLoading && !isError)
        //   SizedBox(
        //     height: context.height() * 0.8,
        //     child: InitialHomeComponent().center(),
        //   ),
        // Positioned(
        //   bottom: postList.isNotEmpty || mPage != 1 ? 8 : null,
        //   child: Observer(
        //       builder: (_) =>
        //           LoadingWidget(isBlurBackground: mPage == 1 ? true : false)
        //               .center()
        //               .visible(appStore.isLoading)),
        // ),
      ],
    );
  }
}

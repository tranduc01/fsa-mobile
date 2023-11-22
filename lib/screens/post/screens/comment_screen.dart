import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/controllers/post_controller.dart';
import 'package:socialv/controllers/user_controller.dart';
import 'package:socialv/main.dart';
import 'package:socialv/screens/post/components/comment_component.dart';
import 'package:socialv/screens/post/components/update_comment_component.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';

import '../../../models/posts/comment.dart';
import '../../blockReport/components/show_report_dialog.dart';

class CommentScreen extends StatefulWidget {
  final int postId;

  const CommentScreen({required this.postId});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController commentController = TextEditingController();
  FocusNode commentFocus = FocusNode();

  late PostController postController = Get.put(PostController());
  late UserController userController = Get.put(UserController());

  int mPage = 1;
  bool mIsLastPage = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await postController.fetchPost(widget.postId);
    });
    super.initState();
    afterBuildCreated(() {
      setStatusBarColor(context.cardColor);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> onRefresh() async {
    mPage = 1;
    postController.fetchPost(widget.postId);
  }

  @override
  void dispose() {
    setStatusBarColorBasedOnTheme();
    super.dispose();
  }

  Future<void> onReportPost() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.80,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 45,
                height: 5,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white),
              ),
              8.height,
              Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16)),
                ),
                child: ShowReportDialog(
                  isPostReport: true,
                  // postId: widget.post.activityId.validate(),
                  // userId: widget.post.userId.validate(),
                ),
              ).expand(),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        appStore.setLoading(false);
        finish(context);
        return Future.value(true);
      },
      child: RefreshIndicator(
        onRefresh: () async {
          onRefresh();
        },
        color: context.primaryColor,
        child: Scaffold(
          backgroundColor: context.cardColor,
          appBar: AppBar(
            backgroundColor: context.cardColor,
            title: Text(language.comments, style: boldTextStyle(size: 20)),
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                finish(context);
              },
            ),
          ),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Obx(
                  () {
                    if (postController.isError.value) {
                      return NoDataWidget(
                        imageWidget: NoDataLottieWidget(),
                        title: postController.isError.value
                            ? language.somethingWentWrong
                            : language.noDataFound,
                        onRetry: () {
                          onRefresh();
                        },
                        retryText: '   ${language.clickToRefresh}   ',
                      ).center();
                    }

                    if (postController.post.value.comments!.isEmpty) {
                      return NoDataWidget(
                        imageWidget: NoDataLottieWidget(),
                        title: language.noDataFound,
                        onRetry: () {
                          onRefresh();
                        },
                        retryText: '   ${language.clickToRefresh}   ',
                      ).center();
                    } else {
                      return AnimatedListView(
                        shrinkWrap: true,
                        slideConfiguration: SlideConfiguration(
                          delay: Duration(milliseconds: 80),
                          verticalOffset: 300,
                        ),
                        physics: AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.fromLTRB(16, 16, 16, 90),
                        itemCount: postController.post.value.comments!.length,
                        itemBuilder: (context, index) {
                          Comment _comment =
                              postController.post.value.comments![index];

                          return Column(
                            children: [
                              CommentComponent(
                                isParent: true,
                                comment: _comment,
                                postId: widget.postId,
                                onDelete: () {
                                  showConfirmDialogCustom(
                                    context,
                                    dialogType: DialogType.DELETE,
                                    onAccept: (c) {
                                      // deleteComment(
                                      //     _comment.id.validate().toInt());
                                    },
                                  );
                                },
                                onReport: () => onReportPost(),
                                onEdit: () {
                                  showInDialog(
                                    context,
                                    contentPadding: EdgeInsets.zero,
                                    builder: (p0) {
                                      return UpdateCommentComponent(
                                        id: _comment.id.validate().toInt(),
                                        //activityId:
                                        // _comment.itemId.validate().toInt(),
                                        comment: _comment.content,
                                        // medias: _comment.medias.validate(),
                                        callback: (x) {
                                          mPage = 1;
                                          //future = getCommentsList();
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                              Divider(
                                thickness: 1,
                              ),
                            ],
                          );
                        },
                        onNextPage: () {
                          if (!mIsLastPage) {
                            mPage++;
                            //future = getCommentsList();
                          }
                        },
                      );
                    }
                  },
                ),
                Obx(
                  () {
                    if (postController.isLoading.value) {
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
                Positioned(
                  bottom: context.navigationBarHeight,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    color: context.scaffoldBackgroundColor,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            userController.user.value.avatarUrl != null
                                ? Image.network(
                                    userController.user.value.avatarUrl
                                        .validate(),
                                    height: 36,
                                    width: 36,
                                    fit: BoxFit.cover,
                                  ).cornerRadiusWithClipRRect(100)
                                : Image.asset(
                                    'assets/images/profile.png',
                                    height: 36,
                                    width: 36,
                                    fit: BoxFit.cover,
                                  ).cornerRadiusWithClipRRect(100),
                            10.width,
                            AppTextField(
                              focus: commentFocus,
                              controller: commentController,
                              textFieldType: TextFieldType.OTHER,
                              decoration: InputDecoration(
                                hintText: language.writeAComment,
                                hintStyle: secondaryTextStyle(size: 16),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                              ),
                              onTap: () {
                                /// Clear recently posted comment id
                              },
                            ).expand(),
                            InkWell(
                              onTap: () async {
                                if (commentController.text.isNotEmpty) {
                                  hideKeyboard(context);

                                  String content =
                                      commentController.text.trim();
                                  commentController.clear();

                                  setState(() {});
                                  await postController.addComment(
                                      widget.postId, content);
                                  if (postController.isCreateSuccess.value) {
                                    toast('Comment added successfully');
                                    onRefresh();
                                  }
                                } else {
                                  toast(language.writeComment);
                                }
                              },
                              child: cachedImage(ic_send,
                                  color: appStore.isDarkMode
                                      ? bodyDark
                                      : bodyWhite,
                                  width: 24,
                                  height: 24,
                                  fit: BoxFit.cover),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

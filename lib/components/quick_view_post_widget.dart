import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/like_button_widget.dart';
import 'package:socialv/models/posts/post_model.dart';
import 'package:socialv/screens/post/components/post_content_component.dart';
import 'package:socialv/screens/post/components/post_component.dart';
import 'package:socialv/screens/post/components/post_media_component.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';

import '../main.dart';
import '../models/posts/post.dart';
import '../screens/dashboard_screen.dart';
import '../screens/post/components/reaction_button_widget.dart';

class QuickViewPostWidget extends StatefulWidget {
  final Post post;
  final int? pageIndex;

  QuickViewPostWidget({
    this.pageIndex,
    required this.post,
  });

  @override
  State<QuickViewPostWidget> createState() => _QuickViewPostWidgetState();
}

class _QuickViewPostWidgetState extends State<QuickViewPostWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  String postContent = '';

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200),
        reverseDuration: const Duration(milliseconds: 700));
    _animation = CurvedAnimation(
        parent: _animationController, curve: Curves.easeOutQuad);
    _animationController.forward();
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
    return SafeArea(
      child: BackdropFilter(
        filter:
            ImageFilter.blur(sigmaX: 3, sigmaY: 3, tileMode: TileMode.repeated),
        child: Container(
          child: ScaleTransition(
            scale: _animation,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                    color: appStore.isDarkMode
                        ? Colors.white12
                        : Colors.transparent),
              ),
              backgroundColor: context.cardColor,
              insetPadding:
                  EdgeInsets.only(left: 12, top: 24, right: 12, bottom: 24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // PostContentComponent(
                    //     blogId: widget.postModel.blogId,
                    //     postType: widget.postModel.type,
                    //     hasMentions: widget.postModel.hasMentions == 1,
                    //     postContent: widget.postModel.content),
                    // PostMediaComponent(
                    //   mediaTitle: widget.postModel.userName.validate(),
                    //   mediaType: widget.postModel.mediaType.validate(),
                    //   mediaList: widget.postModel.medias.validate(),
                    //   isFromPostDetail: true,
                    //   initialPageIndex: widget.pageIndex.validate(),
                    // ).paddingSymmetric(horizontal: 8),

                    PostComponent(
                      post: widget.post,
                      color: context.scaffoldBackgroundColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

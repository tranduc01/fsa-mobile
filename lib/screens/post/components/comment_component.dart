import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/screens/post/components/popup_menu_button_component.dart';

import '../../../controllers/user_controller.dart';
import '../../../models/posts/comment.dart';
import '../../../utils/app_constants.dart';

class CommentComponent extends StatefulWidget {
  final Comment comment;
  final bool isParent;
  final int postId;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final VoidCallback? callback;
  final VoidCallback? onReport;

  CommentComponent({
    required this.isParent,
    required this.postId,
    this.onDelete,
    this.callback,
    this.onEdit,
    this.onReport,
    required this.comment,
  });

  @override
  State<CommentComponent> createState() => _CommentComponentState();
}

class _CommentComponentState extends State<CommentComponent> {
  bool isChange = false;
  late PageController pageController;
  late UserController userController = Get.put(UserController());

  @override
  void initState() {
    pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        8.height,
        Row(
          children: [
            widget.comment.user!.avatarUrl != null
                ? Image.network(
                    widget.comment.user!.avatarUrl.validate(),
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
            16.width,
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: '${widget.comment.user!.name.validate()} ',
                          style:
                              boldTextStyle(size: 14, fontFamily: fontFamily)),
                      if (widget.comment.user!.isVerified.validate())
                        WidgetSpan(
                            child: Image.asset(ic_tick_filled,
                                height: 18,
                                width: 18,
                                color: blueTickColor,
                                fit: BoxFit.cover)),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                ),
                4.height,
                Text(
                    convertToAgo(
                        widget.comment.createdAt.toString().validate()),
                    style: secondaryTextStyle(size: 12)),
              ],
            ).expand(),
            PopUpMenuButtonComponent(
                comment: widget.comment,
                onEditPost: widget.onEdit,
                onDeletePost: widget.onDelete,
                onReportPost: widget.onReport),
          ],
        ),
        8.height,
        Text(parseHtmlString(widget.comment.content.validate()),
            style: primaryTextStyle()),
        8.height,
      ],
    );
  }
}

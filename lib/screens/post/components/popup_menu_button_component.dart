import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/utils/app_constants.dart';

import '../../../controllers/user_controller.dart';
import '../../../main.dart';
import '../../../models/posts/comment.dart';

class PopUpMenuButtonComponent extends StatefulWidget {
  final Comment comment;
  final Function()? onDeletePost;
  final Function()? onReportPost;
  final Function()? onEditPost;
  final VoidCallback? callback;

  const PopUpMenuButtonComponent({
    Key? key,
    required this.comment,
    this.onDeletePost,
    this.onReportPost,
    this.onEditPost,
    this.callback,
  }) : super(key: key);

  @override
  State<PopUpMenuButtonComponent> createState() =>
      _PopUpMenuButtonComponentState();
}

class _PopUpMenuButtonComponentState extends State<PopUpMenuButtonComponent> {
  late UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        useMaterial3: false,
      ),
      child: PopupMenuButton(
        enabled: !appStore.isLoading,
        position: PopupMenuPosition.under,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(commonRadius)),
        onSelected: (val) async {
          if (val == 1) {
            widget.onEditPost!.call();
          } else if (val == 2) {
            widget.onDeletePost!.call();
          } else {
            widget.onReportPost!.call();
          }
        },
        icon: Icon(Icons.more_horiz),
        itemBuilder: (context) => <PopupMenuEntry>[
          if (userController.user.value.id == widget.comment.user!.id)
            PopupMenuItem(
              value: 1,
              child: TextIcon(
                  text: 'Edit',
                  textStyle: secondaryTextStyle(),
                  prefix: Image.asset(ic_edit,
                      color: context.primaryColor, width: 16, height: 16)),
              textStyle: primaryTextStyle(),
            ),
          if (userController.user.value.id == widget.comment.user!.id)
            PopupMenuItem(
              value: 2,
              child: TextIcon(
                  text: 'Delete',
                  textStyle: secondaryTextStyle(),
                  prefix: Image.asset(ic_delete,
                      color: Colors.red, width: 16, height: 16)),
              textStyle: primaryTextStyle(),
            ),
          if (userController.user.value.id != widget.comment.user!.id)
            PopupMenuItem(
              value: 3,
              child: TextIcon(
                  text: 'Report',
                  textStyle: secondaryTextStyle(),
                  prefix: Icon(Icons.report_gmailerrorred,
                      color: appStore.isDarkMode ? bodyDark : bodyWhite,
                      size: 16)),
              textStyle: primaryTextStyle(),
            ),
        ],
      ),
    );
  }
}

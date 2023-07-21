import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/models/posts/wp_comments_model.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';

class BlogCommentComponent extends StatelessWidget {
  final WpCommentModel comment;

  BlogCommentComponent({required this.comment});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: context.scaffoldBackgroundColor),
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              cachedImage(
                comment.author_avatar_urls!.ninetySix.validate(),
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              ).cornerRadiusWithClipRRect(25),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(comment.author_name.validate(), style: secondaryTextStyle()),
                  4.height,
                  Text(convertToAgo(comment.date.validate()), style: secondaryTextStyle()),
                ],
              )
            ],
          ),
          16.height,
          Text(parseHtmlString(comment.content!.rendered.validate()), style: primaryTextStyle()).paddingSymmetric(horizontal: 16)
        ],
      ),
    );
  }
}

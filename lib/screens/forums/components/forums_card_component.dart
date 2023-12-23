import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/posts/topic.dart';
import '../../../utils/app_constants.dart';

class ForumsCardComponent extends StatelessWidget {
  final Topic? topic;

  const ForumsCardComponent({this.topic});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10, right: 20, left: 20),
      padding: EdgeInsets.all(16),
      width: context.width() * 0.5,
      height: context.height() * 0.2,
      decoration: BoxDecoration(
          border: Border.all(color: Color.fromARGB(24, 0, 0, 0)),
          borderRadius: BorderRadius.circular(20),
          color: Color.fromARGB(33, 200, 198, 198)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
              child: Text(
            topic!.name.validate(),
            style: boldTextStyle(size: 18),
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            textAlign: TextAlign.start,
          )),
          8.height,
          Flexible(
              child: Text(
            topic!.description.validate(),
            style: secondaryTextStyle(),
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            textAlign: TextAlign.start,
          )),
          Row(
            children: [
              Text(language.posts + ':',
                  style: boldTextStyle(
                      color: appStore.isDarkMode ? bodyDark : bodyWhite)),
              8.width,
              Text('10', style: primaryTextStyle()),
            ],
          ),
        ],
      ),
    );
  }
}

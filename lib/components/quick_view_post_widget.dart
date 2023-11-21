import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/utils/app_constants.dart';

import '../main.dart';
import '../models/posts/post.dart';

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
                    Container(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Color.fromARGB(24, 0, 0, 0)),
                            borderRadius: radius(10),
                            color: Color.fromARGB(33, 200, 198, 198)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  widget.post.thumbnail != null
                                      ? Image.network(
                                          widget.post.thumbnail!,
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.cover,
                                          errorBuilder: (BuildContext context,
                                              Object exception,
                                              StackTrace? stackTrace) {
                                            return Image.asset(
                                              'assets/images/images.png',
                                              height: 100,
                                              width: 100,
                                              fit: BoxFit.cover,
                                            ).cornerRadiusWithClipRRect(15);
                                          },
                                        ).cornerRadiusWithClipRRect(15)
                                      : Image.asset(
                                          'assets/images/images.png',
                                          fit: BoxFit.cover,
                                          height: 100,
                                          width: 100,
                                        ).cornerRadiusWithClipRRect(15),
                                  12.width,
                                  Expanded(
                                      child: Container(
                                    height: 90,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.post.title!,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                          textAlign: TextAlign.start,
                                          style: boldTextStyle(
                                              fontFamily: 'Roboto', size: 18),
                                        ),
                                        Spacer(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              widget.post.topic!.name!,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              textAlign: TextAlign.start,
                                              style: boldTextStyle(
                                                size: 15,
                                                fontFamily: 'Roboto',
                                                color: Color.fromARGB(
                                                    118, 0, 0, 0),
                                              ),
                                            ),
                                            Text(
                                                convertToAgo(widget
                                                    .post.publishedAt
                                                    .toString()
                                                    .validate()),
                                                style: boldTextStyle(
                                                    size: 15,
                                                    fontFamily: 'Roboto',
                                                    color: Color.fromARGB(
                                                        118, 0, 0, 0))),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )),
                                ],
                              ),
                            )
                          ],
                        )),
                    12.height,
                    Html(
                      data: widget.post.contributeSessions!
                              .firstWhere((element) => element.index == 1)
                              .content ??
                          "",
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

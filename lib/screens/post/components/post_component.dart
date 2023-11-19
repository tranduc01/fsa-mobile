import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/quick_view_post_widget.dart';
import 'package:socialv/screens/post/screens/single_post_screen.dart';
import 'package:socialv/utils/overlay_handler.dart';

import '../../../models/posts/post.dart';
import '../../../utils/app_constants.dart';

// ignore: must_be_immutable
class PostComponent extends StatefulWidget {
  final Post post;
  final VoidCallback? callback;

  final Color? color;

  PostComponent({required this.post, this.callback, this.color});

  @override
  State<PostComponent> createState() => _PostComponentState();
}

class _PostComponentState extends State<PostComponent> {
  OverlayHandler _overlayHandler = OverlayHandler();
  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    _overlayHandler.removeOverlay(context);
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        SinglePostScreen(postId: widget.post.id.validate())
            .launch(context)
            .then((value) {
          if (value ?? false) widget.callback?.call();
        });
      },
      onPanEnd: (s) {
        _overlayHandler.removeOverlay(context);
      },
      onLongPress: () {
        _overlayHandler.insertOverlay(
          context,
          OverlayEntry(
            builder: (context) {
              return QuickViewPostWidget(
                post: widget.post,
              );
            },
          ),
        );
      },
      onLongPressEnd: (details) {
        _overlayHandler.removeOverlay(context);
      },
      child: Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
              border: Border.all(color: Color.fromARGB(24, 0, 0, 0)),
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
                          ).cornerRadiusWithClipRRect(15)
                        : Image.asset('assets/images/images.png',
                            fit: BoxFit.cover, width: 100.0),
                    12.width,
                    Expanded(
                        child: Container(
                      height: 90,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.post.title!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            textAlign: TextAlign.start,
                            style:
                                boldTextStyle(fontFamily: 'Roboto', size: 18),
                          ),
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.post.topic!.name!,
                                style: boldTextStyle(
                                  size: 15,
                                  fontFamily: 'Roboto',
                                  color: Color.fromARGB(118, 0, 0, 0),
                                ),
                              ),
                              Text(
                                  convertToAgo(widget.post.publishedAt
                                      .toString()
                                      .validate()),
                                  style: boldTextStyle(
                                      size: 15,
                                      fontFamily: 'Roboto',
                                      color: Color.fromARGB(118, 0, 0, 0))),
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
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/controllers/post_controller.dart';
import 'package:socialv/screens/post/screens/comment_screen.dart';

import '../../../utils/common.dart';
import '../../../utils/html_widget.dart';

class SinglePostScreen extends StatefulWidget {
  final int postId;

  const SinglePostScreen({required this.postId});

  @override
  State<SinglePostScreen> createState() => _SinglePostScreenState();
}

class _SinglePostScreenState extends State<SinglePostScreen> {
  PageController pageController = PageController();
  late PostController postController = Get.put(PostController());
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await postController.fetchPost(widget.postId);
    });
    postController.post.value.contributeSessions
        .sort((a, b) => a.index!.compareTo(b.index!));
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton.extended(
          label: Obx(() => Text(
              postController.post.value.comments?.length.toString() ??
                  0.toString(),
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
          icon: Icon(
            Icons.messenger_outline_rounded,
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
          onPressed: () {
            CommentScreen(
              postId: widget.postId,
            ).launch(context);
          },
        ),
      ),
      body: Obx(
        () => postController.isLoading.value
            ? LoadingWidget()
            : NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      actions: [
                        IconButton(
                          icon: Icon(Icons.ios_share_outlined,
                              color: Colors.white),
                          onPressed: () {
                            // Add your share functionality here
                          },
                        ),
                      ],
                      title: Text(
                        'Post Detail',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      leading: IconButton(
                        color: Colors.white,
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      backgroundColor: Colors.transparent,
                      expandedHeight: MediaQuery.of(context).size.height * 0.5,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                          background: Stack(
                        children: [
                          Positioned.fill(
                            child: postController.post.value.thumbnail != null
                                ? Image.network(
                                    postController.post.value.thumbnail!,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    'assets/images/images.png',
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              margin: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(129, 0, 0, 0),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.all(16),
                              alignment: Alignment.bottomLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    postController.post.value.topic!.name!,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Roboto',
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    postController.post.value.title!,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 6,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                    ),
                  ];
                },
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  postController.post.value.createdBy!.name ==
                                          null
                                      ? 'Anonymous'
                                      : postController
                                          .post.value.createdBy!.name!,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  convertToAgo(postController
                                      .post.value.publishedAt
                                      .toString()
                                      .validate()),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(137, 0, 0, 0),
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            postController.post.value.createdBy!.avatarUrl ==
                                    null
                                ? Image.asset(
                                    'assets/images/profile.png',
                                    height: 50,
                                    width: 50,
                                  ).cornerRadiusWithClipRRect(25)
                                : Image.network(
                                    postController
                                        .post.value.createdBy!.avatarUrl!,
                                    height: 50,
                                    width: 50,
                                  ).cornerRadiusWithClipRRect(25),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      for (var item
                          in postController.post.value.contributeSessions)
                        Container(
                          child: Column(
                            children: [
                              HtmlWidget(
                                postContent: item.content ?? '',
                              ),
                            ],
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

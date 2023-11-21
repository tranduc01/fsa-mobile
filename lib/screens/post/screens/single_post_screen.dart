import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/controllers/post_controller.dart';

import '../../../utils/common.dart';

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
    return Scaffold(body: Obx(() {
      if (postController.isLoading.value) {
        return LoadingWidget();
      } else {
        return Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        width: MediaQuery.of(context).size.width,
                        child: postController.post.value.thumbnail != null
                            ? Image.network(
                                postController.post.value.thumbnail!,
                                fit: BoxFit.cover,
                              )
                            : Image.asset('assets/images/images.png',
                                fit: BoxFit.cover),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          margin: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(129, 0, 0, 0),
                              borderRadius: BorderRadius.circular(10)),
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
                                    height: 1.3),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              postController.post.value.createdBy!.name!,
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            8.height,
                            Text(
                              convertToAgo(postController.post.value.publishedAt
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
                        postController.post.value.createdBy!.avatarUrl == null
                            ? Image.asset(
                                'assets/images/profile.gif',
                                height: 50,
                                width: 50,
                              ).cornerRadiusWithClipRRect(25)
                            : Image.network(
                                postController.post.value.createdBy!.avatarUrl!,
                                height: 50,
                                width: 50,
                              ).cornerRadiusWithClipRRect(25)
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  for (var item
                      in postController.post.value.contributeSessions!)
                    Container(
                      child: Html(
                        data: item.content,
                      ),
                    )
                ],
              ),
            )
          ],
        );
      }
    }));
  }
}

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/controllers/post_controller.dart';
import 'package:socialv/models/expertise_request/expertise_request.dart';

import '../../../../controllers/user_controller.dart';
import '../../../post/screens/image_screen.dart';
import '../components/expertise_request_bottomsheet_widget.dart';

class ExpertiseRequestDetailScreen extends StatefulWidget {
  final ExpertiseRequest request;

  const ExpertiseRequestDetailScreen({required this.request});

  @override
  State<ExpertiseRequestDetailScreen> createState() =>
      _ExpertiseRequestDetailScreenState();
}

class _ExpertiseRequestDetailScreenState
    extends State<ExpertiseRequestDetailScreen> with TickerProviderStateMixin {
  PageController pageController = PageController();
  late PostController postController = Get.put(PostController());
  int _current = 0;
  final CarouselController _controller = CarouselController();
  late AnimationController _animationController;
  late UserController userController = Get.find();

  final List<String> choicesList = [
    'ALL',
    'PENDING',
    'APPROVED',
    'REJECTED',
    'EXPIRED'
  ];
  final List<Color> colorList = [
    const Color.fromARGB(127, 33, 149, 243),
    const Color.fromARGB(127, 255, 235, 59),
    Color.fromARGB(127, 76, 175, 79),
    Color.fromARGB(127, 244, 67, 54),
    Color.fromARGB(100, 0, 0, 0)
  ];

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await postController.fetchPost(widget.request.id!);
    });
    _animationController = BottomSheet.createAnimationController(this);
    _animationController.duration = const Duration(milliseconds: 500);
    _animationController.drive(CurveTween(curve: Curves.easeOutQuad));
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    _animationController.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: Text(
                'Expertise Request Detail',
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
                    child: widget.request.medias!.length > 1
                        ? Column(
                            children: [
                              Expanded(
                                child: CarouselSlider(
                                  items: widget.request.medias!
                                      .map((item) => GestureDetector(
                                            onTap: () => ImageScreen(
                                                    imageURl:
                                                        item.url.validate())
                                                .launch(context),
                                            child: Container(
                                              child: Stack(
                                                children: [
                                                  item.url != null
                                                      ? Image.network(
                                                          item.url!,
                                                          fit: BoxFit.cover,
                                                          errorBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  Object
                                                                      exception,
                                                                  StackTrace?
                                                                      stackTrace) {
                                                            return Image.asset(
                                                              'assets/images/images.png',
                                                              fit: BoxFit.cover,
                                                            );
                                                          },
                                                        )
                                                      : Image.asset(
                                                          'assets/images/images.png',
                                                          fit: BoxFit.cover),
                                                ],
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                  carouselController: _controller,
                                  options: CarouselOptions(
                                      autoPlay: true,
                                      enlargeCenterPage: false,
                                      aspectRatio: 1,
                                      onPageChanged: (index, reason) {
                                        setState(() {
                                          _current = index;
                                        });
                                      }),
                                ),
                              ),
                              if (widget.request.medias!.length > 1)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: widget.request.medias!
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    return GestureDetector(
                                      onTap: () =>
                                          _controller.animateToPage(entry.key),
                                      child: Container(
                                        width: 12.0,
                                        height: 12.0,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 4.0),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                (Theme.of(context).brightness ==
                                                            Brightness.dark
                                                        ? Colors.white
                                                        : Colors.black)
                                                    .withOpacity(
                                                        _current == entry.key
                                                            ? 0.9
                                                            : 0.4)),
                                      ),
                                    );
                                  }).toList(),
                                ),
                            ],
                          )
                        : widget.request.medias!.isNotEmpty
                            ? GestureDetector(
                                onTap: () => ImageScreen(
                                        imageURl: widget.request.medias![0].url
                                            .validate())
                                    .launch(context),
                                child: Image.network(
                                  widget.request.medias![0].url!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Image.asset(
                                'assets/images/images.png',
                                fit: BoxFit.cover,
                              ),
                  ),
                ],
              )),
            ),
          ];
        },
        body: Container(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    10.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Created Date',
                          style: TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(130, 0, 0, 0),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto'),
                        ),
                        Text(
                          DateFormat('dd/MM/yyyy')
                              .format(widget.request.createAt!),
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto'),
                        ),
                      ],
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Status',
                          style: TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(130, 0, 0, 0),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto'),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: colorList[choicesList.indexOf(
                                  widget.request.adminApprovalStatus!)],
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Color.fromARGB(24, 0, 0, 0))),
                          padding: EdgeInsets.all(6),
                          child: Text(
                            widget.request.adminApprovalStatus!,
                            style: boldTextStyle(
                                size: 15,
                                fontFamily: 'Roboto',
                                color: Color.fromARGB(255, 0, 0, 0)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                10.height,
                Row(
                  children: [
                    10.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Expertise By',
                          style: TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(130, 0, 0, 0),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto'),
                        ),
                        Row(
                          children: [
                            (widget.request.expert != null &&
                                    widget.request.expert!.avatarUrl != null)
                                ? Image.network(
                                    widget.request.expert!.avatarUrl!,
                                    height: 30,
                                    width: 30,
                                  )
                                : Image.asset(
                                    'assets/images/profile.png',
                                    height: 30,
                                    width: 30,
                                  ),
                            5.width,
                            Text(
                              widget.request.expert != null
                                  ? widget.request.expert!.name!
                                  : 'No one',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto'),
                            ),
                          ],
                        )
                      ],
                    ),
                    Spacer(),
                    if (!widget.request.feedbackRating.isEmptyOrNull)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Rating',
                            style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(130, 0, 0, 0),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto'),
                          ),
                          Container(
                            width: 55,
                            decoration: BoxDecoration(
                              color: Colors.yellow[700],
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Color.fromARGB(24, 0, 0, 0)),
                            ),
                            padding: EdgeInsets.all(6),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.star_rate_rounded, size: 15),
                                  Text(
                                    widget.request.feedbackRating.toString(),
                                    style: boldTextStyle(
                                      size: 15,
                                      fontFamily: 'Roboto',
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                  ],
                ),
                10.height,
                Row(
                  children: [
                    10.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Message',
                          style: TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(130, 0, 0, 0),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto'),
                        ),
                        Container(
                          padding: EdgeInsets.all(6),
                          width: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Text(
                            widget.request.noteRequestMessage!,
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Roboto',
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 6,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        10.height,
                        if (widget.request.adminApprovalStatus == 'REJECTED')
                          Text(
                            'Reject Message',
                            style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(130, 0, 0, 0),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto'),
                          ),
                        if (widget.request.adminApprovalStatus == 'REJECTED')
                          Container(
                            padding: EdgeInsets.all(6),
                            width: MediaQuery.of(context).size.width * 0.8,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Text(
                              widget.request.rejectMessage!,
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Roboto',
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 6,
                              textAlign: TextAlign.start,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: userController.user.value.role.contains('Member')
          ? FloatingActionButton.extended(
              onPressed: () {
                showModalBottomSheet(
                  elevation: 0,
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  transitionAnimationController: _animationController,
                  builder: (context) {
                    return FractionallySizedBox(
                      heightFactor: 0.93,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 45,
                            height: 5,
                            //clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.white),
                          ),
                          8.height,
                          Container(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: BoxDecoration(
                              color: context.cardColor,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16)),
                            ),
                            child: ExpertiseResultBottomSheetWidget(),
                          ).expand(),
                        ],
                      ),
                    );
                  },
                );
              },
              label: const Text(
                'View Result',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
              ),
              icon: Image.asset(
                'assets/icons/ic_result.png',
                height: 30,
                width: 30,
                color: Colors.white,
              ),
              backgroundColor: context.primaryColor,
            )
          : userController.user.value.role.contains('Expert')
              ? FloatingActionButton.extended(
                  label: Text('Expertise',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  icon: Icon(
                    Icons.messenger_outline_rounded,
                    color: Colors.black,
                  ),
                  backgroundColor: Colors.white,
                  onPressed: () {},
                )
              : Offstage(),
    );
  }
}

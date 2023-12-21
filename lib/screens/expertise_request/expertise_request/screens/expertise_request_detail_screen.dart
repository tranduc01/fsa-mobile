import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/controllers/expertise_request_controller.dart';
import 'package:socialv/utils/images.dart';
import '../../../../controllers/user_controller.dart';
import '../../../../models/enums/enums.dart';
import '../../../../utils/common.dart';
import '../../../common/fail_dialog.dart';
import '../../../common/loading_dialog.dart';
import '../../../post/screens/image_screen.dart';
import '../components/expertise_request_bottomsheet_widget.dart';

class ExpertiseRequestDetailScreen extends StatefulWidget {
  final int requestId;
  final int? selectedIndex;

  const ExpertiseRequestDetailScreen(
      {required this.requestId, this.selectedIndex});

  @override
  State<ExpertiseRequestDetailScreen> createState() =>
      _ExpertiseRequestDetailScreenState();
}

class _ExpertiseRequestDetailScreenState
    extends State<ExpertiseRequestDetailScreen> with TickerProviderStateMixin {
  PageController pageController = PageController();
  int _current = 0;
  final CarouselController _controller = CarouselController();
  late AnimationController _animationController;
  late UserController userController = Get.find();
  late ExpertiseRequestController expertiseRequestController =
      Get.put(ExpertiseRequestController());

  TextEditingController discCont = TextEditingController();
  FocusNode discNode = FocusNode();

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
      await expertiseRequestController.fetchExpetiseRequest(widget.requestId);
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
      body: Obx(() => expertiseRequestController.isLoading.value
          ? LoadingWidget()
          : NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    title: Text(
                      language.expertiseRequestDetail,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    leading: IconButton(
                      color: Colors.white,
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.of(context).pop();
                        userController.user.value.role.any((element) =>
                                    element.name.toLowerCase() ==
                                    Role.Expert.name.toLowerCase()) &&
                                widget.selectedIndex == 3
                            ? expertiseRequestController
                                .fetchExpetiseRequestsReceive(
                                    widget.selectedIndex!)
                            : expertiseRequestController
                                .fetchExpetiseRequests(widget.selectedIndex!);
                      },
                    ),
                    backgroundColor: Colors.transparent,
                    expandedHeight: MediaQuery.of(context).size.height * 0.5,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                        background: Stack(
                      children: [
                        Positioned.fill(
                          child: expertiseRequestController
                                      .expertiseRequest.value.medias!.length >
                                  1
                              ? Column(
                                  children: [
                                    Expanded(
                                      child: CarouselSlider(
                                        items: expertiseRequestController
                                            .expertiseRequest.value.medias!
                                            .map((item) => GestureDetector(
                                                  onTap: () => ImageScreen(
                                                          imageURl: item.url
                                                              .validate())
                                                      .launch(context),
                                                  child: Container(
                                                    child: Stack(
                                                      children: [
                                                        item.url != null
                                                            ? Image.network(
                                                                item.url!,
                                                                fit: BoxFit
                                                                    .cover,
                                                                errorBuilder: (BuildContext
                                                                        context,
                                                                    Object
                                                                        exception,
                                                                    StackTrace?
                                                                        stackTrace) {
                                                                  return Image
                                                                      .asset(
                                                                    'assets/images/images.png',
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  );
                                                                },
                                                              )
                                                            : Image.asset(
                                                                'assets/images/images.png',
                                                                fit: BoxFit
                                                                    .cover),
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
                                    if (expertiseRequestController
                                            .expertiseRequest
                                            .value
                                            .medias!
                                            .length >
                                        1)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: expertiseRequestController
                                            .expertiseRequest.value.medias!
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          return GestureDetector(
                                            onTap: () => _controller
                                                .animateToPage(entry.key),
                                            child: Container(
                                              width: 12.0,
                                              height: 12.0,
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 8.0,
                                                  horizontal: 4.0),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: (Theme.of(context)
                                                                  .brightness ==
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
                              : expertiseRequestController
                                      .expertiseRequest.value.medias!.isNotEmpty
                                  ? GestureDetector(
                                      onTap: () => ImageScreen(
                                              imageURl:
                                                  expertiseRequestController
                                                      .expertiseRequest
                                                      .value
                                                      .medias![0]
                                                      .url
                                                      .validate())
                                          .launch(context),
                                      child: Image.network(
                                        expertiseRequestController
                                            .expertiseRequest
                                            .value
                                            .medias![0]
                                            .url!,
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
                                language.expertiseRequestCreatedDate,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(130, 0, 0, 0),
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Roboto'),
                              ),
                              Text(
                                DateFormat('dd/MM/yyyy').format(
                                    expertiseRequestController
                                        .expertiseRequest.value.createdAt!),
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
                                language.expertiseRequestStatus,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(130, 0, 0, 0),
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Roboto'),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: colorList[expertiseRequestController
                                        .expertiseRequest.value.status!],
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: Color.fromARGB(24, 0, 0, 0))),
                                padding: EdgeInsets.all(6),
                                child: Text(
                                  ExpertiseRequestStatus
                                      .values[expertiseRequestController
                                          .expertiseRequest.value.status!]
                                      .name,
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
                                language.expertiseBy,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(130, 0, 0, 0),
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Roboto'),
                              ),
                              Row(
                                children: [
                                  (expertiseRequestController.expertiseRequest
                                                  .value.expert !=
                                              null &&
                                          expertiseRequestController
                                                  .expertiseRequest
                                                  .value
                                                  .expert!
                                                  .avatarUrl !=
                                              null)
                                      ? Image.network(
                                          expertiseRequestController
                                              .expertiseRequest
                                              .value
                                              .expert!
                                              .avatarUrl!,
                                          height: 30,
                                          width: 30,
                                        ).cornerRadiusWithClipRRect(20)
                                      : Image.asset(
                                          'assets/images/profile.png',
                                          height: 30,
                                          width: 30,
                                        ),
                                  5.width,
                                  Text(
                                    expertiseRequestController.expertiseRequest
                                                .value.expert !=
                                            null
                                        ? expertiseRequestController
                                            .expertiseRequest
                                            .value
                                            .expert!
                                            .name!
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
                          if (expertiseRequestController
                                      .expertiseRequest.value.feedback ==
                                  null &&
                              expertiseRequestController.expertiseRequest.value
                                  .expertiseResults!.isNotEmpty &&
                              !userController.user.value.role.any((element) =>
                                  element.name.toLowerCase() ==
                                  Role.Expert.name.toLowerCase()))
                            AppButton(
                                text: 'Send Feedback',
                                shapeBorder: ContinuousRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                color: Colors.white,
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: 'Ronoto',
                                    fontWeight: FontWeight.bold),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      late double feedbackRating = 0;
                                      return AlertDialog(
                                        title: Text('Feedback'),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            RatingBar(
                                              initialRating: 3,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              ratingWidget: RatingWidget(
                                                full: Image.asset(
                                                  heart,
                                                  color: Colors.red,
                                                ),
                                                half: Image.asset(
                                                  heart_half,
                                                  color: Colors.red,
                                                ),
                                                empty: Image.asset(
                                                  heart_border,
                                                  color: Colors.red,
                                                ),
                                              ),
                                              itemPadding: EdgeInsets.symmetric(
                                                  horizontal: 4.0),
                                              onRatingUpdate: (rating) {
                                                feedbackRating = rating;
                                              },
                                            ),
                                            20.height,
                                            TextFormField(
                                              focusNode: discNode,
                                              controller: discCont,
                                              autofocus: false,
                                              maxLines: 5,
                                              decoration: inputDecorationFilled(
                                                context,
                                                fillColor: context
                                                    .scaffoldBackgroundColor,
                                                label: 'Message',
                                              ),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Cancel',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'Roboto',
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          TextButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        context.primaryColor),
                                                shape:
                                                    MaterialStateProperty.all(
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)))),
                                            onPressed: () async {
                                              if (feedbackRating != 0) {
                                                showDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder: (context) {
                                                      return LoadingDialog();
                                                    });
                                                await expertiseRequestController
                                                    .sendFeedback(
                                                        widget.requestId,
                                                        feedbackRating,
                                                        discCont.text);

                                                if (expertiseRequestController
                                                    .isUpdateSuccess.value) {
                                                  expertiseRequestController
                                                      .fetchExpetiseRequest(
                                                          widget.requestId);
                                                  Navigator.pop(context);
                                                  toast(
                                                      'Feedback Sent Successfully');
                                                } else {
                                                  Navigator.pop(context);
                                                  showDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder: (context) {
                                                      return FailDialog(
                                                          text: 'Send Failed');
                                                    },
                                                  );
                                                }
                                              } else {
                                                toast('Please rate');
                                              }
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Send',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Roboto',
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }),
                          if (expertiseRequestController
                                      .expertiseRequest.value.status ==
                                  ExpertAssginStatus.Doing.index &&
                              expertiseRequestController
                                      .expertiseRequest.value.expert !=
                                  null &&
                              userController.user.value.role.any((element) =>
                                  element.name.toLowerCase() ==
                                  Role.Expert.name.toLowerCase()))
                            AppButton(
                                text: 'Create Result',
                                shapeBorder: ContinuousRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                color: Colors.white,
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: 'Ronoto',
                                    fontWeight: FontWeight.bold),
                                onTap: () {})
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
                                  expertiseRequestController.expertiseRequest
                                      .value.noteRequestMessage!,
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
                              if (expertiseRequestController
                                      .expertiseRequest.value.status ==
                                  ExpertiseRequestStatus.Rejected.index)
                                Text(
                                  'Reject Message',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color.fromARGB(130, 0, 0, 0),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto'),
                                ),
                              if (expertiseRequestController
                                      .expertiseRequest.value.status ==
                                  ExpertiseRequestStatus.Rejected.index)
                                Container(
                                  padding: EdgeInsets.all(6),
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    expertiseRequestController
                                        .expertiseRequest.value.rejectMessage!,
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
                              if (expertiseRequestController
                                      .expertiseRequest.value.feedback !=
                                  null)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Feedback',
                                      style: TextStyle(
                                          fontSize: 22,
                                          color: Color.fromARGB(130, 0, 0, 0),
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Roboto'),
                                    ),
                                    10.height,
                                    Text(
                                      'Rating',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Color.fromARGB(130, 0, 0, 0),
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Roboto'),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.yellow[700],
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            color: Color.fromARGB(24, 0, 0, 0)),
                                      ),
                                      padding: EdgeInsets.all(6),
                                      child: Row(
                                        children: [
                                          RatingBar(
                                            initialRating:
                                                expertiseRequestController
                                                    .expertiseRequest
                                                    .value
                                                    .feedback!
                                                    .rating!,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            ratingWidget: RatingWidget(
                                              full: Image.asset(
                                                heart,
                                                color: Colors.red,
                                              ),
                                              half: Image.asset(
                                                heart_half,
                                                color: Colors.red,
                                              ),
                                              empty: Image.asset(
                                                heart_border,
                                                color: Colors.red,
                                              ),
                                            ),
                                            itemPadding: EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            ignoreGestures: true,
                                            onRatingUpdate: (rating) {},
                                          ),
                                        ],
                                      ),
                                    ),
                                    5.height,
                                    Text(
                                      'Feedback Message',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Color.fromARGB(130, 0, 0, 0),
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Roboto'),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(6),
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      child: Text(
                                        expertiseRequestController
                                            .expertiseRequest
                                            .value
                                            .feedback!
                                            .message!,
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
                                )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )),
      floatingActionButton: Obx(() => (expertiseRequestController
                  .expertiseRequest.value.expertiseResults!.isNotEmpty &&
              !userController.user.value.role.any((element) =>
                  element.name.toLowerCase() == Role.Expert.name.toLowerCase()))
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
                            child: ExpertiseResultBottomSheetWidget(
                              expertiseRequest: expertiseRequestController
                                  .expertiseRequest.value,
                            ),
                          ).expand(),
                        ],
                      ),
                    );
                  },
                );
              },
              label: Text(
                language.viewResult,
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
          : userController.user.value.role.any((element) =>
                      element.name.toLowerCase() ==
                      Role.Expert.name.toLowerCase()) &&
                  expertiseRequestController.expertiseRequest.value.status ==
                      ExpertiseRequestStatus.WaitingForExpert.index
              ? FloatingActionButton.extended(
                  label: Text('Expertise This Request',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  icon: Icon(
                    Icons.check,
                    color: Colors.green,
                  ),
                  backgroundColor: Colors.white,
                  onPressed: () {
                    showConfirmDialogCustom(
                      context,
                      title: 'Are you sure you want to expertise this request',
                      onAccept: (p0) async {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return LoadingDialog();
                            });

                        await expertiseRequestController
                            .receiveExpertiseRequest(widget.requestId);

                        if (expertiseRequestController.isUpdateSuccess.value) {
                          toast('Received Successfully');
                          expertiseRequestController
                              .fetchExpetiseRequest(widget.requestId);
                          Navigator.pop(context);
                        } else {
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return FailDialog(text: 'Failed');
                            },
                          );
                        }
                      },
                    );
                  },
                )
              : Offstage()),
    );
  }
}

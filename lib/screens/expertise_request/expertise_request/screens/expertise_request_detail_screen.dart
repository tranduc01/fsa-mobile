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
import '../../../post/screens/video_post_screen.dart';
import '../components/expertise_request_bottomsheet_widget.dart';
import '../components/video_media_component.dart';
import 'expertise_request_result_screen.dart';

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

  TextEditingController memberCancelCont = TextEditingController();
  FocusNode memberCancelNode = FocusNode();

  final List<Color> colorList = [
    Colors.blue.withOpacity(0.5), // Doing
    Colors.green.withOpacity(0.5), // Completed
    Colors.orange.withOpacity(0.5), // WaitingForApproval
    Colors.yellow.withOpacity(0.5), // WaitingForExpert
    Colors.red.withOpacity(0.5), // Rejected
    Colors.grey.withOpacity(0.5), // Canceled
  ];

  final List<Color> expertAsignColorList = [
    Colors.blue.withOpacity(0.5), // Doing
    Colors.red.withOpacity(0.5), // Rejected
    Colors.grey.withOpacity(0.5), // Expired
    Colors.green.withOpacity(0.5), // Completed
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
                                            .map(
                                              (item) => GestureDetector(
                                                onTap: () {
                                                  item.type == 'image'
                                                      ? ImageScreen(
                                                              imageURl: item.url
                                                                  .validate())
                                                          .launch(context)
                                                      : VideoPostScreen(item.url
                                                              .validate())
                                                          .launch(context);
                                                },
                                                child: Container(
                                                  child: Stack(
                                                    children: [
                                                      item.url != null
                                                          ? item.type == 'image'
                                                              ? Image.network(
                                                                  item.url!,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )
                                                              : VideoMediaComponent(
                                                                  mediaUrl:
                                                                      item.url!,
                                                                )
                                                          : Image.asset(
                                                              'assets/images/images.png',
                                                              fit:
                                                                  BoxFit.cover),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                        carouselController: _controller,
                                        options: CarouselOptions(
                                            //autoPlay: true,
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
                                  () {
                                    switch (ExpertiseRequestStatus
                                        .values[expertiseRequestController
                                            .expertiseRequest.value.status!]
                                        .name) {
                                      case 'WaitingForApproval':
                                        return 'Chờ duyệt';
                                      case 'WaitingForExpert':
                                        return language
                                            .waitingForExpertExpertiseRequest;
                                      case 'Doing':
                                        return language.doingExpertiseRequest;
                                      case 'Completed':
                                        return language
                                            .completedExpertiseRequest;
                                      case 'Rejected':
                                        return language
                                            .rejectedExpertiseRequest;
                                      case 'Canceled':
                                        return 'Đã hủy';
                                      default:
                                        return ExpertiseRequestStatus
                                            .values[expertiseRequestController
                                                .expertiseRequest.value.status!]
                                            .name;
                                    }
                                  }(),
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
                                        : language.noOne,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Roboto'),
                                  ),
                                  10.width,
                                  if (expertiseRequestController
                                          .expertiseRequest.value.expert !=
                                      null)
                                    Container(
                                      decoration: BoxDecoration(
                                          color: expertAsignColorList[
                                              expertiseRequestController
                                                  .expertiseRequest
                                                  .value
                                                  .expertAssignStatus!],
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                              color:
                                                  Color.fromARGB(24, 0, 0, 0))),
                                      padding: EdgeInsets.all(6),
                                      child: Text(
                                        () {
                                          switch (ExpertAssginStatus
                                              .values[expertiseRequestController
                                                  .expertiseRequest
                                                  .value
                                                  .expertAssignStatus!]
                                              .name) {
                                            case 'Doing':
                                              return 'Đang thực hiện';
                                            case 'Cancel':
                                              return 'Đã hủy';
                                            case 'Expired':
                                              return 'Đã hết hạn';
                                            case 'Completed':
                                              return 'Đã hoàn thành';
                                            default:
                                              return ExpertAssginStatus
                                                  .values[
                                                      expertiseRequestController
                                                          .expertiseRequest
                                                          .value
                                                          .status!]
                                                  .name;
                                          }
                                        }(),
                                        style: boldTextStyle(
                                            size: 15,
                                            fontFamily: 'Roboto',
                                            color:
                                                Color.fromARGB(255, 0, 0, 0)),
                                      ),
                                    )
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
                                text: language.sendFeedbackExpertiseRequest,
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
                                        title: Text(language.feedback),
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
                                                label: language
                                                    .feedbackMessageExpertiseRequest,
                                              ),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(language.cancel,
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
                                                  toast(language
                                                      .feedbackSentSuccessfully);
                                                } else {
                                                  Navigator.pop(context);
                                                  showDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder: (context) {
                                                      return FailDialog(
                                                          text: language
                                                              .feedbackSentFailed);
                                                    },
                                                  );
                                                }
                                              } else {
                                                toast(language.feedbackRating);
                                              }
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(language.send,
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
                          if ((expertiseRequestController
                                          .expertiseRequest.value.status ==
                                      ExpertiseRequestStatus.Doing.index ||
                                  expertiseRequestController
                                          .expertiseRequest.value.status ==
                                      ExpertiseRequestStatus.Completed.index) &&
                              expertiseRequestController
                                      .expertiseRequest.value.expert !=
                                  null &&
                              userController.user.value.role.any((element) =>
                                  element.name.toLowerCase() ==
                                  Role.Expert.name.toLowerCase()))
                            AppButton(
                              shapeBorder: ContinuousRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add),
                                  SizedBox(width: 8),
                                  Text(
                                    'Result',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: 'Ronoto',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                ExpertiseRequestResultScreen(
                                  requestId: widget.requestId,
                                ).launch(context);
                              },
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
                                language.messageExpertiseRequest,
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
                                  language.rejectMessage,
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
                                      language.feedback,
                                      style: TextStyle(
                                          fontSize: 22,
                                          color: Color.fromARGB(130, 0, 0, 0),
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Roboto'),
                                    ),
                                    10.height,
                                    Text(
                                      language.ratingExpertiseRequest,
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
                                      language.feedbackMessageExpertiseRequest,
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
                                ),
                              if (expertiseRequestController
                                          .expertiseRequest.value.canceledAt !=
                                      null &&
                                  expertiseRequestController.expertiseRequest
                                          .value.cancelMessage !=
                                      null)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Cancel Date',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Color.fromARGB(130, 0, 0, 0),
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Roboto'),
                                    ),
                                    Text(
                                      DateFormat('dd/MM/yyyy').format(
                                          expertiseRequestController
                                              .expertiseRequest
                                              .value
                                              .canceledAt!),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Roboto'),
                                    ),
                                    10.height,
                                    Text(
                                      'Cancel Message',
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
                                            .cancelMessage!,
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
                    ],
                  ),
                ),
              ),
            )),
      floatingActionButton: Obx(() => (expertiseRequestController
                  .expertiseRequest.value.expertiseResults!.isNotEmpty &&
              expertiseRequestController.expertiseRequest.value.status ==
                  ExpertiseRequestStatus.Completed.index)
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
                  label: Text(language.expertiseThisRequest,
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
                      title: language.expertiseThisRequestConfirmMsg,
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
                          toast(language.receivedSuccessfully);
                          expertiseRequestController
                              .fetchExpetiseRequest(widget.requestId);
                          Navigator.pop(context);
                        } else {
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return FailDialog(text: language.failed);
                            },
                          );
                        }
                      },
                    );
                  },
                )
              : expertiseRequestController.expertiseRequest.value.status ==
                      ExpertiseRequestStatus.WaitingForApproval.index
                  ? FloatingActionButton.extended(
                      label: Text('Hủy yêu cầu này',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      icon: Icon(
                        Icons.close_rounded,
                        color: Colors.red,
                      ),
                      backgroundColor: Colors.white,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Hủy yêu cầu đánh giá'),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    focusNode: memberCancelNode,
                                    controller: memberCancelCont,
                                    autofocus: false,
                                    maxLines: 5,
                                    decoration: inputDecorationFilled(
                                      context,
                                      fillColor:
                                          context.scaffoldBackgroundColor,
                                      label: 'Lời nhắn',
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(language.cancel,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Roboto',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ),
                                TextButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              context.primaryColor),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)))),
                                  onPressed: () async {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) {
                                          return LoadingDialog();
                                        });

                                    await expertiseRequestController
                                        .cancelExpertiseRequestMember(
                                            widget.requestId,
                                            memberCancelCont.text);

                                    if (expertiseRequestController
                                        .isUpdateSuccess.value) {
                                      await expertiseRequestController
                                          .fetchExpetiseRequest(
                                              widget.requestId);
                                      await userController.getCurrentUser();

                                      Navigator.pop(context);
                                      toast('Cancel Success');
                                    } else {
                                      Navigator.pop(context);
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) {
                                          return FailDialog(
                                              text:
                                                  language.feedbackSentFailed);
                                        },
                                      );
                                    }
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(language.send,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Roboto',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    )
                  : userController.user.value.role.any((element) =>
                              element.name.toLowerCase() ==
                              Role.Expert.name.toLowerCase()) &&
                          expertiseRequestController
                                  .expertiseRequest.value.status ==
                              ExpertiseRequestStatus.Doing.index
                      ? FloatingActionButton.extended(
                          label: Text('Không thực hiện đánh giá này',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          icon: Icon(
                            Icons.close_rounded,
                            color: Colors.red,
                          ),
                          backgroundColor: Colors.white,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title:
                                      Text('Ngừng thực hiện yêu cầu đánh giá'),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextFormField(
                                        focusNode: memberCancelNode,
                                        controller: memberCancelCont,
                                        autofocus: false,
                                        maxLines: 5,
                                        decoration: inputDecorationFilled(
                                          context,
                                          fillColor:
                                              context.scaffoldBackgroundColor,
                                          label: 'Lời nhắn',
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(language.cancel,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Roboto',
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    TextButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  context.primaryColor),
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)))),
                                      onPressed: () async {
                                        showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (context) {
                                              return LoadingDialog();
                                            });

                                        await expertiseRequestController
                                            .cancelExpertiseRequestExpert(
                                                widget.requestId,
                                                memberCancelCont.text);

                                        if (expertiseRequestController
                                            .isUpdateSuccess.value) {
                                          await expertiseRequestController
                                              .fetchExpetiseRequest(
                                                  widget.requestId);
                                          await userController.getCurrentUser();
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          toast('Hủy thành công');
                                        } else {
                                          Navigator.pop(context);
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (context) {
                                              return FailDialog(
                                                  text: language
                                                      .feedbackSentFailed);
                                            },
                                          );
                                        }
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(language.send,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Roboto',
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        )
                      : Offstage()),
    );
  }
}

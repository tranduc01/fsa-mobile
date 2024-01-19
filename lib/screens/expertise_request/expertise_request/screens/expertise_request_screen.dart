import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/controllers/expertise_request_controller.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/expertise_request/expertise_request.dart';
import 'package:socialv/screens/expertise_request/expertise_request/screens/expertise_request_detail_screen.dart';

import '../../../../components/no_data_lottie_widget.dart';
import '../../../../controllers/user_controller.dart';
import '../../../../models/enums/enums.dart';
import 'create_expertise_request_screen.dart';

class ExpertiseRequestScreen extends StatefulWidget {
  final ScrollController controller;
  final int? selectedIndex;
  final int selectedTab;

  const ExpertiseRequestScreen(
      {required this.controller,
      this.selectedIndex,
      required this.selectedTab});

  @override
  State<ExpertiseRequestScreen> createState() => _ExpertiseRequestScreenState();
}

class _ExpertiseRequestScreenState extends State<ExpertiseRequestScreen>
    with SingleTickerProviderStateMixin {
  DateTime? startDate;
  DateTime? endDate;
  late ExpertiseRequestController expertiseRequestController =
      Get.put(ExpertiseRequestController());
  late UserController userController = Get.find();
  int mPage = 1;
  bool mIsLastPage = false;
  int selectIndex = 0;

  final List<Color> colorList = [
    Colors.blue.withOpacity(0.5), // Doing
    Colors.green.withOpacity(0.5), // Completed
    Colors.orange.withOpacity(0.5), // WaitingForApproval
    Colors.yellow.withOpacity(0.5), // WaitingForExpert
    Colors.red.withOpacity(0.5), // Rejected
    Colors.grey.withOpacity(0.5), // Canceled
  ];

  @override
  void initState() {
    super.initState();
    selectIndex = widget.selectedIndex ?? 0;
    userController.user.value.role.any((element) =>
                element.name.toLowerCase() == Role.Expert.name.toLowerCase()) &&
            widget.selectedIndex == 3
        ? expertiseRequestController.fetchExpetiseRequestsReceive(selectIndex)
        : expertiseRequestController.fetchExpetiseRequests(selectIndex);

    widget.controller.addListener(() {
      if (widget.controller.position.pixels ==
          widget.controller.position.maxScrollExtent) {
        if (!mIsLastPage) {
          mPage++;
          setState(() {});
        }
      }
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.scaffoldBackgroundColor,
        title: Text(language.expertiseRequest, style: boldTextStyle(size: 20)),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            finish(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          DefaultTabController(
            length: 6,
            initialIndex: widget.selectedTab,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    child: TabBar(
                      labelColor: Colors.black,
                      unselectedLabelColor: Color.fromARGB(171, 105, 104, 104),
                      labelStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                      ),
                      isScrollable: true,
                      physics: BouncingScrollPhysics(),
                      indicator: BoxDecoration(),
                      tabs: [
                        Tab(
                            child: Text(
                          'Chờ duyệt',
                        )),
                        Tab(
                          child: Text(
                            language.waitingForExpertExpertiseRequest,
                          ),
                        ),
                        Tab(
                            child: Text(
                          language.doingExpertiseRequest,
                        )),
                        Tab(
                          child: Text(
                            language.completedExpertiseRequest,
                          ),
                        ),
                        Tab(
                          child: Text(
                            language.rejectedExpertiseRequest,
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Đã hủy',
                          ),
                        ),
                      ],
                      onTap: (index) {
                        int status;

                        switch (index) {
                          case 0:
                            status = 2;
                            break;
                          case 1:
                            status = 3;
                            break;
                          case 2:
                            status = 0;
                            break;
                          case 3:
                            status = 1;
                            break;
                          case 4:
                            status = 4;
                            break;
                          case 5:
                            status = 5;
                            break;
                          default:
                            status = 0;
                        }

                        userController.user.value.role.any((element) =>
                                    element.name.toLowerCase() ==
                                    Role.Expert.name.toLowerCase()) &&
                                index == 1
                            ? expertiseRequestController
                                .fetchExpetiseRequestsReceive(status)
                            : userController.user.value.role.any((element) =>
                                        element.name.toLowerCase() ==
                                        Role.Expert.name.toLowerCase()) &&
                                    index == 2
                                ? expertiseRequestController
                                    .fetchExpetiseRequestsReceived(status)
                                : expertiseRequestController
                                    .fetchExpetiseRequests(status);
                        selectIndex = status;
                        setState(() {});
                      },
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    child: TabBarView(children: [
                      expertiseRequestsComponent(),
                      expertiseRequestsComponent(),
                      expertiseRequestsComponent(),
                      expertiseRequestsComponent(),
                      expertiseRequestsComponent(),
                      expertiseRequestsComponent(),
                    ]),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: mPage != 1 ? 10 : null,
            child: Obx(
              () => SizedBox(
                // height:
                //     mPage == 1 ? MediaQuery.of(context).size.height * 0.5 : null,
                child: LoadingWidget(isBlurBackground: true)
                    .center()
                    .visible(expertiseRequestController.isLoading.value),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          CreateExpertiseRequestScreen().launch(context);
        },
      ),
    );
  }

  Widget expertiseRequestsComponent() {
    return Obx(
      () {
        if (expertiseRequestController.isError.value ||
            expertiseRequestController.expertiseRequests.isEmpty) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: NoDataWidget(
              imageWidget: NoDataLottieWidget(),
              title: expertiseRequestController.isError.value
                  ? language.somethingWentWrong
                  : language.noDataFound,
              onRetry: () {
                userController.user.value.role.any((element) =>
                        element.name.toLowerCase() ==
                        Role.Expert.name.toLowerCase())
                    ? expertiseRequestController
                        .fetchExpetiseRequestsReceive(selectIndex)
                    : expertiseRequestController
                        .fetchExpetiseRequests(selectIndex);
              },
              retryText: '   ' + language.clickToRefresh + '   ',
            ).center(),
          );
        } else {
          return AnimatedListView(
            padding: EdgeInsets.only(bottom: 180),
            itemCount: expertiseRequestController.expertiseRequests.length,
            physics: BouncingScrollPhysics(),
            slideConfiguration: SlideConfiguration(
                delay: Duration(milliseconds: 80), verticalOffset: 300),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              ExpertiseRequest expertiseRequest =
                  expertiseRequestController.expertiseRequests[index];

              return GestureDetector(
                onTap: () => ExpertiseRequestDetailScreen(
                  requestId: expertiseRequest.id!,
                  selectedIndex: selectIndex,
                ).launch(context),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: radius(10),
                        color: Color.fromARGB(33, 200, 198, 198),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xffDDDDDD),
                            blurRadius: 6.0,
                            spreadRadius: 2.0,
                            offset: Offset(0.0, 0.0),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                expertiseRequest.medias!.isNotEmpty
                                    ? Image.network(
                                        expertiseRequest.medias![0].url!,
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
                                        Row(
                                          children: [
                                            Text(
                                              'ER231123110512',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3,
                                              textAlign: TextAlign.start,
                                              style: boldTextStyle(
                                                  fontFamily: 'Roboto',
                                                  size: 18),
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                DateFormat('dd/MM/yyyy').format(
                                                    expertiseRequest
                                                        .createdAt!),
                                                style: boldTextStyle(
                                                    size: 15,
                                                    fontFamily: 'Roboto',
                                                    color: Color.fromARGB(
                                                        118, 0, 0, 0))),
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: colorList[
                                                      expertiseRequest.status!],
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  border: Border.all(
                                                      color: Color.fromARGB(
                                                          24, 0, 0, 0))),
                                              padding: EdgeInsets.all(6),
                                              child: Text(
                                                // ExpertiseRequestStatus
                                                //     .values[expertiseRequest
                                                //         .status!]
                                                //     .name,
                                                () {
                                                  switch (ExpertiseRequestStatus
                                                      .values[expertiseRequest
                                                          .status!]
                                                      .name) {
                                                    case 'WaitingForApproval':
                                                      return 'Chờ duyệt';
                                                    case 'WaitingForExpert':
                                                      return language
                                                          .waitingForExpertExpertiseRequest;
                                                    case 'Doing':
                                                      return language
                                                          .doingExpertiseRequest;
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
                                                          .values[
                                                              expertiseRequest
                                                                  .status!]
                                                          .name;
                                                  }
                                                }(),
                                                style: boldTextStyle(
                                                    size: 15,
                                                    fontFamily: 'Roboto',
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}

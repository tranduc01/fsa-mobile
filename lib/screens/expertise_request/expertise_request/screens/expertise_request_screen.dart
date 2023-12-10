import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/controllers/expertise_request_controller.dart';
import 'package:socialv/models/expertise_request/expertise_request.dart';
import 'package:socialv/screens/expertise_request/expertise_request/screens/expertise_request_detail_screen.dart';

import '../../../../components/no_data_lottie_widget.dart';
import '../../../../controllers/user_controller.dart';
import 'create_expertise_request_screen.dart';

class ExpertiseRequestScreen extends StatefulWidget {
  final ScrollController controller;

  const ExpertiseRequestScreen({required this.controller});

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
  int selectedIndex = 0;
  final List<String> choicesList = [
    'ALL',
    'PENDING',
    'APPROVED',
    'REJECTED',
    'EXPIRED',
    'ADVANCE'
  ];
  final List<Color> colorList = [
    const Color.fromARGB(127, 33, 149, 243),
    const Color.fromARGB(127, 255, 235, 59),
    Color.fromARGB(127, 76, 175, 79),
    Color.fromARGB(127, 244, 67, 54),
    Color.fromARGB(100, 0, 0, 0),
    Color.fromARGB(100, 0, 0, 0),
  ];

  @override
  void initState() {
    super.initState();
    selectedIndex = 0;
    expertiseRequestController.fetchExpetiseRequests();
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
        title: Text('Expertise Request', style: boldTextStyle(size: 20)),
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
          Column(
            children: [
              Wrap(
                spacing: 5,
                runSpacing: 5,
                children: List<Widget>.generate(
                  choicesList.length,
                  (index) => ChoiceChip(
                    label: choicesList[index] == 'ADVANCE'
                        ? Icon(Icons.more_horiz_rounded)
                        : Text(
                            choicesList[index],
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto'),
                          ),
                    selected: selectedIndex == index,
                    selectedColor: colorList[index],
                    onSelected: (selected) {
                      setState(() {
                        selectedIndex = selected ? index : 0;
                      });
                      if (selectedIndex == 5) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: Text(
                                'Filter',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  StatefulBuilder(
                                    builder: (BuildContext context,
                                        StateSetter setState) {
                                      return Row(
                                        children: [
                                          Text(
                                            'Start date: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          startDate != null
                                              ? Text(DateFormat('dd/MM/yyyy')
                                                  .format(startDate!))
                                              : Text(DateFormat('dd/MM/yyyy')
                                                  .format(DateTime.now())),
                                          IconButton(
                                            onPressed: () async {
                                              final selectedDate =
                                                  await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(2000),
                                                lastDate: DateTime(2100),
                                              );
                                              if (selectedDate != null) {
                                                setState(() {
                                                  startDate = selectedDate;
                                                });
                                              }
                                            },
                                            icon: Icon(
                                                Icons.calendar_today_rounded),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  SizedBox(height: 16),
                                  StatefulBuilder(
                                    builder: (BuildContext context,
                                        StateSetter setState) {
                                      return Row(
                                        children: [
                                          Text(
                                            'End date: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          startDate != null
                                              ? Text(DateFormat('dd/MM/yyyy')
                                                  .format(endDate!))
                                              : Text(DateFormat('dd/MM/yyyy')
                                                  .format(DateTime.now())),
                                          IconButton(
                                            onPressed: () async {
                                              final selectedDate =
                                                  await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(2000),
                                                lastDate: DateTime(2100),
                                              );
                                              if (selectedDate != null) {
                                                setState(() {
                                                  endDate = selectedDate;
                                                });
                                              }
                                            },
                                            icon: Icon(
                                                Icons.calendar_today_rounded),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                              actions: [
                                Row(
                                  children: [
                                    AppButton(
                                      elevation: 0,
                                      shapeBorder: RoundedRectangleBorder(
                                        borderRadius:
                                            radius(defaultAppButtonRadius),
                                        side: BorderSide(color: viewLineColor),
                                      ),
                                      color: context.cardColor,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.close,
                                            color: textPrimaryColorGlobal,
                                            size: 20,
                                          ),
                                          6.width,
                                          Text(
                                            'Cancel',
                                            style: boldTextStyle(
                                                color: Colors.black),
                                          ),
                                        ],
                                      ).fit(),
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                    ).expand(),
                                    16.width,
                                    AppButton(
                                      elevation: 0,
                                      color: Colors.blue,
                                      shapeBorder: RoundedRectangleBorder(
                                        borderRadius:
                                            radius(defaultAppButtonRadius),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          getIcon(DialogType.CONFIRMATION),
                                          6.width,
                                          Text(
                                            'Filter',
                                            style: boldTextStyle(
                                                color: Colors.white),
                                          ),
                                        ],
                                      ).fit(),
                                      onTap: () {
                                        if (startDate != null &&
                                            endDate != null) {
                                          print('Start Date: $startDate');
                                          print('End Date: $endDate');
                                        }
                                      },
                                    ).expand(),
                                  ],
                                )
                              ],
                            );
                          },
                        );
                      }
                    },
                  ),
                ).toList(),
              ),
              Obx(() {
                if (expertiseRequestController.isError.value ||
                    expertiseRequestController.expertiseRequests.isEmpty) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: NoDataWidget(
                      imageWidget: NoDataLottieWidget(),
                      title: expertiseRequestController.isError.value
                          ? 'Something Went Wrong'
                          : 'No data found',
                      onRetry: () {
                        expertiseRequestController.fetchExpetiseRequests();
                      },
                      retryText: '   Click to Refresh   ',
                    ).center(),
                  );
                } else {
                  return AnimatedListView(
                    padding: EdgeInsets.only(bottom: mIsLastPage ? 16 : 60),
                    itemCount:
                        expertiseRequestController.expertiseRequests.length,
                    slideConfiguration: SlideConfiguration(
                        delay: Duration(milliseconds: 80), verticalOffset: 300),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      ExpertiseRequest expertiseRequest =
                          expertiseRequestController.expertiseRequests[index];

                      return GestureDetector(
                        onTap: () => ExpertiseRequestDetailScreen(
                                request: expertiseRequest)
                            .launch(context),
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
                                                expertiseRequest
                                                    .medias![0].url!,
                                                height: 100,
                                                width: 100,
                                                fit: BoxFit.cover,
                                                errorBuilder: (BuildContext
                                                        context,
                                                    Object exception,
                                                    StackTrace? stackTrace) {
                                                  return Image.asset(
                                                    'assets/images/images.png',
                                                    height: 100,
                                                    width: 100,
                                                    fit: BoxFit.cover,
                                                  ).cornerRadiusWithClipRRect(
                                                      15);
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
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 3,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: boldTextStyle(
                                                          fontFamily: 'Roboto',
                                                          size: 18),
                                                    ),
                                                  ],
                                                ),
                                                Spacer(),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        DateFormat('dd/MM/yyyy')
                                                            .format(
                                                                expertiseRequest
                                                                    .createdAt!),
                                                        style: boldTextStyle(
                                                            size: 15,
                                                            fontFamily:
                                                                'Roboto',
                                                            color:
                                                                Color.fromARGB(
                                                                    118,
                                                                    0,
                                                                    0,
                                                                    0))),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color: colorList[
                                                              expertiseRequest
                                                                      .adminApprovalStatus! +
                                                                  1],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          border: Border.all(
                                                              color: Color
                                                                  .fromARGB(
                                                                      24,
                                                                      0,
                                                                      0,
                                                                      0))),
                                                      padding:
                                                          EdgeInsets.all(6),
                                                      child: Text(
                                                        choicesList[expertiseRequest
                                                                .adminApprovalStatus! +
                                                            1],
                                                        style: boldTextStyle(
                                                            size: 15,
                                                            fontFamily:
                                                                'Roboto',
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    0,
                                                                    0,
                                                                    0)),
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
              }),
            ],
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
      floatingActionButton: userController.user.value.role.contains('Member')
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                CreateExpertiseRequestScreen().launch(context);
              },
            )
          : Offstage(),
    );
  }
}

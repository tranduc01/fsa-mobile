import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/controllers/expertise_request_controller.dart';
import 'package:socialv/models/enums/enums.dart';
import 'package:socialv/models/expertise_request/expertise_result.dart';

import 'create_expertise_request_result_screen.dart';

class ExpertiseRequestResultScreen extends StatefulWidget {
  final int? requestId;

  const ExpertiseRequestResultScreen({this.requestId});

  @override
  State<ExpertiseRequestResultScreen> createState() =>
      _ExpertiseRequestResultScreenState();
}

class _ExpertiseRequestResultScreenState
    extends State<ExpertiseRequestResultScreen>
    with SingleTickerProviderStateMixin {
  late ExpertiseRequestController expertiseRequestController =
      Get.put(ExpertiseRequestController());

  int mPage = 1;
  bool mIsLastPage = false;
  int selectIndex = 0;

  final List<Color> colorList = [
    const Color.fromARGB(127, 33, 149, 243),
    const Color.fromARGB(127, 255, 235, 59),
    Color.fromARGB(127, 76, 175, 79),
    Color.fromARGB(127, 244, 67, 54),
    Color.fromARGB(100, 0, 0, 0)
  ];

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: context.scaffoldBackgroundColor,
          title:
              Text('Expertise Request Result', style: boldTextStyle(size: 20)),
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              finish(context);
            },
          ),
        ),
        body: Obx(
          () => Stack(
            alignment: Alignment.topCenter,
            children: [
              AnimatedListView(
                padding: EdgeInsets.only(bottom: 100),
                itemCount: expertiseRequestController
                    .expertiseRequest.value.expertiseResults!.length,
                physics: BouncingScrollPhysics(),
                slideConfiguration: SlideConfiguration(
                    delay: Duration(milliseconds: 80), verticalOffset: 300),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  ExpertiseResult result = expertiseRequestController
                      .expertiseRequest.value.expertiseResults![index];
                  return Container(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            DateFormat('dd/MM/yyyy hh:mm a')
                                .format(result.createdAt!),
                            style: boldTextStyle(
                                size: 15,
                                fontFamily: 'Roboto',
                                color: Color.fromARGB(118, 0, 0, 0))),
                        Container(
                          decoration: BoxDecoration(
                              color: result.submitType == 2
                                  ? const Color.fromARGB(129, 76, 175, 79)
                                  : const Color.fromARGB(129, 244, 67, 54),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Color.fromARGB(24, 0, 0, 0))),
                          padding: EdgeInsets.all(6),
                          child: Text(
                            result.submitType == 2 ? 'Published' : 'Draft',
                            style: boldTextStyle(
                                size: 15,
                                fontFamily: 'Roboto',
                                color: Color.fromARGB(255, 0, 0, 0)),
                          ),
                        ),
                      ],
                    ),
                  ).onTap(() {
                    CreateExpertiseRequestResultScreen(
                      isNew: false,
                      requestId: widget.requestId!,
                      expertiseResult: result,
                    ).launch(context);
                  });
                },
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
        ),
        floatingActionButton:
            expertiseRequestController.expertiseRequest.value.status ==
                    ExpertiseRequestStatus.Doing.index
                ? FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () {
                      CreateExpertiseRequestResultScreen(
                        isNew: true,
                        requestId: widget.requestId!,
                      ).launch(context);
                    },
                  )
                : Offstage());
  }
}

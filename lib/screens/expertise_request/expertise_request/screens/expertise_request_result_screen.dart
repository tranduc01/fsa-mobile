import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/controllers/expertise_request_controller.dart';

import '../../../../controllers/user_controller.dart';
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
  late UserController userController = Get.find();
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
        title: Text('Expertise Request Result', style: boldTextStyle(size: 20)),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            finish(context);
          },
        ),
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
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
          CreateExpertiseRequestResultScreen().launch(context);
        },
      ),
    );
  }
}

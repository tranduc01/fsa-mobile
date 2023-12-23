import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/expertise_request/evaluation_criteria.dart';
import 'package:socialv/models/expertise_request/expertise_request.dart';
import 'package:tap_to_expand/tap_to_expand.dart';

class ExpertiseResultBottomSheetWidget extends StatefulWidget {
  final ExpertiseRequest expertiseRequest;
  ExpertiseResultBottomSheetWidget({Key? key, required this.expertiseRequest})
      : super(key: key);

  @override
  State<ExpertiseResultBottomSheetWidget> createState() =>
      _ExpertiseResultBottomSheetWidgetState();
}

class _ExpertiseResultBottomSheetWidgetState
    extends State<ExpertiseResultBottomSheetWidget> {
  int selectedIndex = -1;
  bool isLoading = false;
  bool backToHome = true;

  @override
  void initState() {
    super.initState();
    if (appStore.isLoading) {
      isLoading = true;
      appStore.setLoading(false);
    }
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
    return Stack(
      children: [
        Column(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  20.height,
                  Column(
                    children: [
                      widget.expertiseRequest.expert!.avatarUrl.isEmptyOrNull
                          ? Image.asset("assets/images/profile.png",
                                  height: 62, width: 62, fit: BoxFit.cover)
                              .cornerRadiusWithClipRRect(100)
                          : Image.network(
                                  widget.expertiseRequest.expert!.avatarUrl!,
                                  height: 62,
                                  width: 62,
                                  fit: BoxFit.cover)
                              .cornerRadiusWithClipRRect(100),
                      10.height,
                      Text(
                        widget.expertiseRequest.expert!.name!,
                        style: boldTextStyle(size: 20),
                      ),
                      10.height,
                      Text(
                        'Chuyên gia tư vấn',
                        style: secondaryTextStyle(size: 16),
                      ),
                    ],
                  ),
                  20.height,
                  Text('Kết quả đánh giá', style: boldTextStyle(size: 25)),
                  10.height,
                  Center(
                    child: Column(
                      children: [
                        AnimatedListView(
                          padding: EdgeInsets.only(bottom: 60),
                          itemCount: widget.expertiseRequest.expertiseResults!
                              .firstWhere((element) => element.submitType == 2)
                              .evaluationCriterias!
                              .length,
                          slideConfiguration: SlideConfiguration(
                              delay: Duration(milliseconds: 80),
                              verticalOffset: 300),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            EvaluationCriteria evaluationCriteria = widget
                                .expertiseRequest.expertiseResults!
                                .firstWhere(
                                    (element) => element.submitType == 2)
                                .evaluationCriterias![index];

                            return TapToExpand(
                              content: Text(
                                evaluationCriteria.content ?? '',
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 16,
                                    color: Colors.white,
                                    height: 1.5),
                              ),
                              title: Text(
                                evaluationCriteria.name ?? '',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                              color: Colors.blueGrey,
                              onTapPadding: 10,
                              closedHeight: 70,
                              scrollable: true,
                              borderRadius: 10,
                              openedHeight: 200,
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ).expand(),
          ],
        ),
        LoadingWidget().center().visible(appStore.isLoading)
      ],
    );
  }
}

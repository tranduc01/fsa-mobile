import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/controllers/evaluation_criteria_controller.dart';
import 'package:socialv/models/expertise_request/evaluation_criteria.dart';
import 'package:socialv/models/expertise_request/expertise_result.dart';
import 'package:socialv/screens/common/fail_dialog.dart';
import 'package:socialv/screens/common/loading_dialog.dart';

import '../../../../components/loading_widget.dart';
import '../../../../controllers/expertise_request_controller.dart';
import '../../../../main.dart';
import '../../../../models/enums/enums.dart';
import '../../../../utils/app_constants.dart';

class CreateExpertiseRequestResultComponent extends StatefulWidget {
  final Function(int)? onNextPage;
  final int requestId;
  final bool isNew;
  final ExpertiseResult? expertiseResult;
  CreateExpertiseRequestResultComponent(
      {Key? key,
      this.onNextPage,
      required this.requestId,
      required this.isNew,
      this.expertiseResult})
      : super(key: key);

  @override
  State<CreateExpertiseRequestResultComponent> createState() =>
      _CreateExpertiseRequestResultComponentState();
}

class _CreateExpertiseRequestResultComponentState
    extends State<CreateExpertiseRequestResultComponent> {
  final albumKey = GlobalKey<FormState>();
  late ExpertiseRequestController expertiseRequestController =
      Get.put(ExpertiseRequestController());
  late EvaluationCriteriaController evaluationCriteriaController =
      Get.put(EvaluationCriteriaController());

  Map<int, dynamic> texts = {};
  Map<int, TextEditingController> controllers = {};
  bool isTextModified = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await evaluationCriteriaController.fetchEvaluationCriterias();
    });

    super.initState();
  }

  @override
  void dispose() {
    controllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(defaultRadius)),
              color: context.cardColor,
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  24.height,
                  Text(
                    'Create Expertise Request Result',
                    style: primaryTextStyle(
                        color: appStore.isDarkMode ? bodyDark : bodyWhite,
                        size: 18),
                  ),
                  10.height,
                  Form(
                      key: albumKey,
                      child: Obx(
                        () => Column(
                          children: [
                            16.height,
                            AnimatedListView(
                              padding: EdgeInsets.only(bottom: 16),
                              itemCount: evaluationCriteriaController
                                  .evaluationCriterias.length,
                              slideConfiguration: SlideConfiguration(
                                  delay: Duration(milliseconds: 80),
                                  verticalOffset: 300),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                EvaluationCriteria evaluationCriteria =
                                    evaluationCriteriaController
                                        .evaluationCriterias[index];

                                if (!controllers
                                    .containsKey(evaluationCriteria.id!)) {
                                  controllers[evaluationCriteria.id!] =
                                      TextEditingController();
                                }

                                TextEditingController discCont =
                                    controllers[evaluationCriteria.id!]!;
                                controllers[evaluationCriteria.id!] = discCont;
                                texts.addAll(
                                    {evaluationCriteria.id!: discCont.text});
                                if (!widget.isNew &&
                                    widget.expertiseResult != null) {
                                  if (widget
                                      .expertiseResult!.evaluationCriterias!
                                      .any((element) =>
                                          element.id ==
                                          evaluationCriteria.id)) {
                                    discCont.text = widget
                                        .expertiseResult!.evaluationCriterias!
                                        .firstWhere((element) =>
                                            element.id == evaluationCriteria.id)
                                        .content!;
                                    texts.addAll({
                                      evaluationCriteria.id!: discCont.text
                                    });
                                  }
                                }

                                return Container(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: TextFormField(
                                    controller: discCont,
                                    autofocus: false,
                                    enabled: expertiseRequestController
                                                .expertiseRequest
                                                .value
                                                .status ==
                                            ExpertiseRequestStatus.Doing.index
                                        ? true
                                        : false,
                                    maxLines: 5,
                                    decoration: inputDecorationFilled(
                                      context,
                                      fillColor:
                                          context.scaffoldBackgroundColor,
                                      label: evaluationCriteria.name,
                                    ),
                                    onChanged: (value) {
                                      texts.update(
                                          evaluationCriteria.id!, (v) => value);

                                      setState(() {
                                        isTextModified = true;
                                      });
                                    },
                                  ),
                                );
                              },
                            )
                          ],
                        ).paddingSymmetric(vertical: 8),
                      )),
                  8.height,
                  if (widget.isNew &&
                      expertiseRequestController
                              .expertiseRequest.value.status ==
                          ExpertiseRequestStatus.Doing.index)
                    Align(
                      alignment: Alignment.center,
                      child: appButton(
                        text: language.create,
                        onTap: () async {
                          hideKeyboard(context);
                          texts.removeWhere((key, value) => value == '');
                          List<Map<String, dynamic>> requestBody =
                              texts.entries.map((entry) {
                            return {
                              "evaluationCriteriaId": entry.key,
                              "content": entry.value,
                            };
                          }).toList();

                          if (albumKey.currentState!.validate()) {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return LoadingDialog();
                                });
                            await expertiseRequestController.sendResult(
                                widget.requestId, requestBody);

                            if (expertiseRequestController
                                .isUpdateSuccess.value) {
                              expertiseRequestController
                                  .fetchExpetiseRequest(widget.requestId);
                              Navigator.pop(context);
                              toast('Result Created Successfully');
                              Navigator.pop(context);
                            } else {
                              Navigator.pop(context);
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return FailDialog(
                                      text: 'Create Result Failed');
                                },
                              );
                            }
                          }
                        },
                        context: context,
                      ),
                    ),
                  if (!widget.isNew &&
                      expertiseRequestController
                              .expertiseRequest.value.status ==
                          ExpertiseRequestStatus.Doing.index)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Visibility(
                          visible: isTextModified,
                          child: appButton(
                            width: MediaQuery.of(context).size.width * 0.4,
                            text: 'Save',
                            color: Colors.white,
                            shapeBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: context.primaryColor)),
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                            onTap: () async {
                              hideKeyboard(context);
                              texts.removeWhere((key, value) => value == '');
                              List<Map<String, dynamic>> requestBody =
                                  texts.entries.map((entry) {
                                return {
                                  "evaluationCriteriaId": entry.key,
                                  "content": entry.value,
                                };
                              }).toList();

                              if (albumKey.currentState!.validate()) {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) {
                                      return LoadingDialog();
                                    });
                                await expertiseRequestController.sendResult(
                                    widget.requestId, requestBody);

                                if (expertiseRequestController
                                    .isUpdateSuccess.value) {
                                  expertiseRequestController
                                      .fetchExpetiseRequest(widget.requestId);
                                  Navigator.pop(context);
                                  toast('Result Created Successfully');
                                  Navigator.pop(context);
                                } else {
                                  Navigator.pop(context);
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) {
                                      return FailDialog(
                                          text: 'Create Result Failed');
                                    },
                                  );
                                }
                              }
                            },
                            context: context,
                          ),
                        ),
                        Visibility(
                          visible: !isTextModified,
                          child: appButton(
                            width: MediaQuery.of(context).size.width * 0.4,
                            text: 'Publish',
                            onTap: () async {
                              hideKeyboard(context);
                              if (albumKey.currentState!.validate()) {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) {
                                      return LoadingDialog();
                                    });
                                await expertiseRequestController
                                    .publishExpertiseRequestResult(
                                        widget.expertiseResult!.id!);

                                if (expertiseRequestController
                                    .isUpdateSuccess.value) {
                                  expertiseRequestController
                                      .fetchExpetiseRequest(widget.requestId);
                                  Navigator.pop(context);
                                  toast('Result Published Successfully');
                                  Navigator.pop(context);
                                } else {
                                  Navigator.pop(context);
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) {
                                      return FailDialog(
                                          text: 'Publish Result Failed');
                                    },
                                  );
                                }
                              }
                            },
                            context: context,
                          ),
                        )
                      ],
                    )
                ],
              ),
            ),
          ),
          Positioned(
            child: Obx(() => LoadingWidget()
                .center()
                .visible(evaluationCriteriaController.isLoading.value)),
          ),
        ],
      ),
    );
  }
}

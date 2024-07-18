import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/controllers/user_controller.dart';
import 'package:socialv/controllers/withdraw_controller.dart';
import 'package:socialv/main.dart';
import 'package:socialv/utils/app_constants.dart';

import '../../components/no_data_lottie_widget.dart';
import '../../models/enums/enums.dart';
import '../common/fail_dialog.dart';
import '../common/loading_dialog.dart';
import '../post/screens/image_screen.dart';

class WithdrawRequestDetailBottomSheetWidget extends StatefulWidget {
  final int requestId;
  WithdrawRequestDetailBottomSheetWidget({Key? key, required this.requestId})
      : super(key: key);

  @override
  State<WithdrawRequestDetailBottomSheetWidget> createState() =>
      _WithdrawRequestDetailBottomSheetWidgetState();
}

class _WithdrawRequestDetailBottomSheetWidgetState
    extends State<WithdrawRequestDetailBottomSheetWidget> {
  int selectedIndex = -1;
  bool isLoading = false;
  bool backToHome = true;

  late WithdrawController withdrawController = Get.put(WithdrawController());
  late UserController userController = Get.put(UserController());
  TextEditingController discCont = TextEditingController();
  FocusNode discNode = FocusNode();

  final List<Color> colorList = [
    Colors.blue.withOpacity(0.5),
    Colors.orange.withOpacity(0.5),
    Colors.green.withOpacity(0.5),
    Colors.red.withOpacity(0.5),
    Colors.grey.withOpacity(0.5)
  ];

  final List<String> lottieList = [
    'assets/lottie/mail_sent.json',
    'assets/lottie/money_processing.json',
    'assets/lottie/success.json',
    'assets/lottie/fail.json',
    'assets/lottie/payment_cancel.json'
  ];

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await withdrawController.fetchWithdraw(widget.requestId);
    });
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
    return PopScope(
      onPopInvoked: (isPop) async {
        await withdrawController.fetchWithdraws();
      },
      child: Obx(() {
        if (withdrawController.isLoading.value)
          return LoadingWidget().center();
        else if (withdrawController.isError.value ||
            withdrawController.withdraws.isEmpty)
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: NoDataWidget(
              imageWidget: NoDataLottieWidget(),
              title: withdrawController.isError.value
                  ? language.somethingWentWrong
                  : language.noDataFound,
              onRetry: () {
                withdrawController.fetchWithdraws();
              },
              retryText: '   ' + language.clickToRefresh + '   ',
            ).center(),
          );
        else
          return Stack(
            children: [
              Column(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Lottie.asset(
                                lottieList[
                                    withdrawController.withdraw.value.status!],
                                width: 200,
                                height: 200)
                            .center(),
                        16.height,
                        Container(
                          decoration: BoxDecoration(
                              color: colorList[
                                  withdrawController.withdraw.value.status!],
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Color.fromARGB(24, 0, 0, 0))),
                          padding: EdgeInsets.all(8),
                          child: Text(
                            WithdrawStatus
                                .values[
                                    withdrawController.withdraw.value.status!]
                                .name,
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 0, 0, 0)),
                          ),
                        ).center(),
                        16.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.token_outlined,
                              size: 25,
                            ),
                            Text(
                              withdrawController.withdraw.value.point!
                                  .toStringAsFixed(0)
                                  .formatNumberWithComma(),
                              style: TextStyle(
                                fontSize: 25,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                              ),
                            ).center(),
                            Text(
                              ' Points',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Roboto',
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ).center(),
                          ],
                        ),
                        20.height,
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Details',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        16.height,
                        Row(
                          children: [
                            Text(
                              'Bank Number',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Roboto',
                              ),
                            ),
                            Spacer(),
                            Text(
                              withdrawController.withdraw.value.bankNumber!,
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Text(
                              'Bank Account Name',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Roboto',
                              ),
                            ),
                            Spacer(),
                            Text(
                              withdrawController
                                  .withdraw.value.bankAccountName!,
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Text(
                              'Bank Name',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Roboto',
                              ),
                            ),
                            Spacer(),
                            Flexible(
                              child: Text(
                                withdrawController.withdraw.value.bankName!,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 4,
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Text(
                              'Bank Short Name',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Roboto',
                              ),
                            ),
                            Spacer(),
                            Text(
                              withdrawController.withdraw.value.bankShortName!,
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Text(
                              'Created At',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Roboto',
                              ),
                            ),
                            Spacer(),
                            Text(
                              DateFormat('dd/MM/yyyy hh:mm:ss a').format(
                                  withdrawController.withdraw.value.createdAt!),
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        if (withdrawController.withdraw.value.responseMessage !=
                            null)
                          Column(
                            children: [
                              Divider(),
                              Row(
                                children: [
                                  Text(
                                    'Response Message',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                  Spacer(),
                                  Flexible(
                                    child: Text(
                                      withdrawController
                                          .withdraw.value.responseMessage!,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 4,
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        if (withdrawController.withdraw.value.note != null)
                          Column(
                            children: [
                              Divider(),
                              Row(
                                children: [
                                  Text(
                                    'Note',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                  Spacer(),
                                  Flexible(
                                    child: Text(
                                      withdrawController.withdraw.value.note!,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 4,
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        if (withdrawController.withdraw.value.status ==
                            WithdrawStatus.Canceled.index)
                          Column(
                            children: [
                              Divider(),
                              Row(
                                children: [
                                  Text(
                                    'Cancel Message',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                  Spacer(),
                                  Flexible(
                                    child: Text(
                                      withdrawController
                                          .withdraw.value.cancelMessage!,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 4,
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                ],
                              ),
                              Divider(),
                              Row(
                                children: [
                                  Text(
                                    'Canceled At',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    DateFormat('dd/MM/yyyy hh:mm:ss a').format(
                                        withdrawController
                                            .withdraw.value.canceledAt!),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        if (withdrawController.withdraw.value.status ==
                                WithdrawStatus.Done.index &&
                            withdrawController
                                    .withdraw.value.transactionImage !=
                                null)
                          Column(
                            children: [
                              Divider(),
                              Row(
                                children: [
                                  Text(
                                    'Transaction Image',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () => ImageScreen(
                                            imageURl: withdrawController
                                                .withdraw.value.transactionImage
                                                .validate())
                                        .launch(context),
                                    child: Image.network(
                                      withdrawController
                                          .withdraw.value.transactionImage!,
                                      width: 100,
                                      height: 100,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        if (withdrawController.withdraw.value.status ==
                            WithdrawStatus.Sent.index)
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.13,
                          ),
                        if (withdrawController.withdraw.value.status ==
                            WithdrawStatus.Sent.index)
                          appButton(
                              text: 'Cancel Withdraw Request',
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Cancel Withdraw Request'),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextFormField(
                                            focusNode: discNode,
                                            controller: discCont,
                                            autofocus: false,
                                            maxLines: 5,
                                            decoration: inputDecorationFilled(
                                              context,
                                              fillColor: context
                                                  .scaffoldBackgroundColor,
                                              label: 'Cancel Message',
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
                                                  WidgetStateProperty.all(
                                                      context.primaryColor),
                                              shape: WidgetStateProperty.all(
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
                                            await withdrawController
                                                .cancelWithdrawRequest(
                                                    widget.requestId,
                                                    discCont.text);

                                            if (withdrawController
                                                .isUpdateSuccess.value) {
                                              await withdrawController
                                                  .fetchWithdraw(
                                                      widget.requestId);
                                              await userController
                                                  .getCurrentUser();
                                              Navigator.pop(context);
                                              toast('Cancel Success');
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
                              context: context)
                      ],
                    ),
                  ).expand(),
                ],
              ),
              LoadingWidget().center().visible(appStore.isLoading)
            ],
          );
      }),
    );
  }
}

import 'package:date_count_down/date_count_down.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/controllers/auction_controller.dart';
import 'package:socialv/controllers/user_controller.dart';
import 'package:socialv/main.dart';
import 'package:socialv/utils/app_constants.dart';

import '../../../models/auction/bid.dart';
import 'bid_component.dart';

class BidScreen extends StatefulWidget {
  final int auctionId;

  const BidScreen({required this.auctionId});

  @override
  State<BidScreen> createState() => _BidScreenState();
}

class _BidScreenState extends State<BidScreen> {
  final bidFormKey = GlobalKey<FormState>();
  TextEditingController commentController = TextEditingController();
  FocusNode commentFocus = FocusNode();
  TextEditingController amountController = TextEditingController();

  late AuctionController auctionController = Get.put(AuctionController());
  late UserController userController = Get.put(UserController());

  int mPage = 1;
  bool mIsLastPage = false;
  double _currentAmount = 0;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await auctionController.fetchAuction(widget.auctionId);
    });

    super.initState();
    afterBuildCreated(() {
      setStatusBarColor(context.cardColor);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    setStatusBarColorBasedOnTheme();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    'Ví đấu giá: ${auctionController.auction.value.currentPoint!.toStringAsFixed(0).formatNumberWithComma()} điểm',
                    style: boldTextStyle(size: 20),
                  ).paddingOnly(top: 16, left: 10),
                  10.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        color: Colors.black,
                        size: 30,
                      ),
                      6.width,
                      CountDownText(
                        due: auctionController.auction.value.startDate!
                                .add(Duration(hours: 7))
                                .isBefore(DateTime.now())
                            ? auctionController.auction.value.actualEndDate!
                                .add(Duration(hours: 7))
                            : auctionController.auction.value.startDate!
                                .add(Duration(hours: 7)),
                        finishedText: language.auctionEnded,
                        showLabel: true,
                        daysTextShort: "d ",
                        hoursTextShort: "h ",
                        minutesTextShort: "m ",
                        secondsTextShort: "s ",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Roboto',
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  if (auctionController.auction.value.auctionBids!.isEmpty)
                    NoDataWidget(
                      imageWidget: NoDataLottieWidget(),
                      title: language.noDataFound,
                      onRetry: () {
                        auctionController.fetchAuction(widget.auctionId);
                      },
                      retryText: '   ${language.clickToRefresh}   ',
                    ).center()
                  else
                    AnimatedListView(
                      shrinkWrap: true,
                      reverse: true,
                      slideConfiguration: SlideConfiguration(
                        delay: Duration(milliseconds: 80),
                        verticalOffset: 300,
                      ),
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 90),
                      itemCount:
                          auctionController.auction.value.auctionBids!.length,
                      itemBuilder: (context, index) {
                        Bid bid =
                            auctionController.auction.value.auctionBids![index];

                        return Column(
                          children: [
                            BidComponent(
                              bid: bid,
                            ),
                            Divider(
                              thickness: 1,
                            ),
                          ],
                        );
                      },
                      onNextPage: () {
                        if (!mIsLastPage) {
                          mPage++;
                        }
                      },
                    )
                ],
              ),
            ),
            if (auctionController.auction.value.isRegistered == true &&
                auctionController.auction.value.winner == null)
              Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.cardColor,
                    boxShadow: defaultBoxShadow(),
                  ),
                  child: appButton(
                      text: 'Đặt giá',
                      onTap: () {
                        if (userController.user.value.isVerified == false) {
                          toast('Hãy xác thực tài khoản trước khi đấu giá');
                          return;
                        } else {
                          amountController.text = auctionController
                              .auction.value.currentBidPrice!
                              .toStringAsFixed(0)
                              .formatNumberWithComma();
                          showDialog(
                            context: context,
                            builder: (context) {
                              return PopScope(
                                onPopInvoked: (isPop) {
                                  amountController.clear();
                                },
                                child: AlertDialog(
                                  title: Text('Đặt giá',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Roboto',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Form(
                                        key: bidFormKey,
                                        child: Column(
                                          children: [
                                            InputQty(
                                              maxVal: auctionController.auction
                                                      .value.isSoldDirectly!
                                                  ? auctionController.auction
                                                      .value.soldDirectlyPrice!
                                                  : 1000000000000000,
                                              initVal: 0,
                                              steps: auctionController
                                                  .auction.value.stepPrice!,
                                              qtyFormProps: QtyFormProps(
                                                  enableTyping: false),
                                              decoration: QtyDecorationProps(
                                                  isBordered: false,
                                                  contentPadding:
                                                      EdgeInsets.all(10),
                                                  borderShape:
                                                      BorderShapeBtn.circle),
                                              decimalPlaces: 0,
                                              onQtyChanged: (val) {
                                                _currentAmount =
                                                    auctionController
                                                            .auction
                                                            .value
                                                            .currentBidPrice! +
                                                        val;
                                                amountController
                                                    .text = (auctionController
                                                            .auction
                                                            .value
                                                            .currentBidPrice! +
                                                        val)
                                                    .toStringAsFixed(0)
                                                    .formatNumberWithComma();
                                                setState(() {});
                                              },
                                            ),
                                            20.height,
                                            TextFormField(
                                              controller: amountController,
                                              readOnly: true,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    width: 3,
                                                    color: Color(0xFFB4D4FF),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.0),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    width: 3,
                                                    color: Color(0xFFB4D4FF),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.0),
                                                ),
                                                suffixIcon: Icon(
                                                  Icons.token_outlined,
                                                  color: Colors.black,
                                                  size: 30,
                                                ),
                                              ),
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Hãy nhập điểm';
                                                }
                                                if (_currentAmount ==
                                                    auctionController
                                                        .auction
                                                        .value
                                                        .currentBidPrice!) {
                                                  return 'Số điểm đặt phải cao hơn giá đấu giá hiện tại';
                                                }
                                                return null;
                                              },
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Hủy bỏ',
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
                                      onPressed: () {
                                        if (bidFormKey.currentState!
                                            .validate()) {
                                          if ((amountController.text
                                                      .toDouble() !=
                                                  auctionController.auction
                                                      .value.currentBidPrice) &&
                                              !amountController
                                                  .text.isEmptyOrNull) {
                                            showConfirmDialogCustom(context,
                                                title:
                                                    'Đặt ${amountController.text} điểm?',
                                                onAccept: (contex) async {
                                              await auctionController.placeBid(
                                                  auctionController
                                                      .auction.value.id!,
                                                  _currentAmount.toInt());
                                              Navigator.of(context).pop();

                                              if (!auctionController
                                                  .isUpdateSuccess.value) {
                                                String message =
                                                    auctionController
                                                        .message.value;
                                                switch (auctionController
                                                    .message.value) {
                                                  case 'AUCTION_BIDDER_ALREADY_BID':
                                                    message =
                                                        'Bạn đã đặt giá rồi.';
                                                    break;
                                                  case 'AUCTION_BID_WAIT':
                                                    message =
                                                        'Bạn phải chờ 60s để đặt giá mới';
                                                    break;
                                                  case 'AUCTION_BID_NOT_MET_MINIMUM':
                                                    message =
                                                        'Số điểm đặt phải cao hơn giá đấu giá hiện tại';
                                                    break;
                                                  case 'NOT_ENOUGH_POINT':
                                                    message =
                                                        'Bạn không đủ điểm để đấu giá';
                                                    break;
                                                  case 'AUCTION_ALREADY_STOPPED':
                                                    message =
                                                        'Đấu giá đã kết thúc';
                                                    break;
                                                }

                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text('Đặt giá',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16)),
                                                      content: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Lottie.asset(
                                                              'assets/lottie/fail.json'),
                                                          Text(
                                                            message,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                        ],
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStateProperty
                                                                      .all(context
                                                                          .primaryColor),
                                                              shape: MaterialStateProperty.all(
                                                                  RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20)))),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text('OK',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                            });
                                          }
                                        }
                                      },
                                      child: Text(
                                        'Đặt giá',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Roboto',
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      },
                      context: context),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

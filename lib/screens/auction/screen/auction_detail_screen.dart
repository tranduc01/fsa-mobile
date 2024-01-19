import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:socialv/controllers/user_controller.dart';
import 'package:socialv/main.dart';
import 'package:socialv/screens/auction/screen/bid_screen.dart';
import 'package:socialv/screens/post/screens/image_screen.dart';
import 'package:socialv/utils/html_widget.dart';

import '../../../components/loading_widget.dart';
import '../../../controllers/auction_controller.dart';
import '../../../models/auction/bid.dart';
import '../../../utils/common.dart';
import '../../../utils/images.dart';
import '../../common/fail_dialog.dart';
import '../../common/loading_dialog.dart';

class AuctionDetailSceen extends StatefulWidget {
  final int id;
  const AuctionDetailSceen({Key? key, required this.id}) : super(key: key);
  @override
  _AuctionDetailSceenState createState() => _AuctionDetailSceenState();
}

class _AuctionDetailSceenState extends State<AuctionDetailSceen>
    with TickerProviderStateMixin {
  bool isShowOrchidInfo = false;
  bool isShowAuctionInfo = false;
  final storage = new FlutterSecureStorage();
  late AnimationController _animationController;
  late AuctionController auctionController = Get.put(AuctionController());
  late UserController userController = Get.find();
  final registerationFormKey = GlobalKey<FormState>();
  TextEditingController feeAmountCont = TextEditingController();
  final addPointFormKey = GlobalKey<FormState>();
  TextEditingController addPointCont = TextEditingController();
  late HubConnection hubConnection;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await auctionController.fetchAuction(widget.id);
    });

    onHandle();

    _animationController = BottomSheet.createAnimationController(this);
    _animationController.duration = const Duration(milliseconds: 500);
    _animationController.drive(CurveTween(curve: Curves.easeOutQuad));
    super.initState();
  }

  Future<void> onHandle() async {
    var token = await storage.read(key: 'jwt');

    hubConnection = HubConnectionBuilder()
        .withUrl('https://api.chiasekienthucphonglan.io.vn/hubs/auction',
            options: HttpConnectionOptions(
                accessTokenFactory: () => Future.value(token)))
        .build();

    hubConnection.on('BidAuction', (arguments) {
      arguments!.forEach((element) {
        print(element);

        if (element['IsUpdatedWinner'] == null) {
          auctionController.auction.value.currentBidPrice =
              element['bidAmount'] != null
                  ? element['bidAmount'].toDouble()
                  : 0;
          auctionController.auction.value.auctionBids!
              .add(Bid.fromJson(element));
          if (element['actualEndDate'] != null) {
            auctionController.auction.value.actualEndDate =
                element['actualEndDate'] != null
                    ? (DateTime.parse(element['actualEndDate'])
                        .subtract(Duration(hours: 7)))
                    : null;
          }

          if (userController.user.value.id ==
              Bid.fromJson(element).bidder!.id) {
            auctionController.auction.value.currentPoint =
                element['currentPoint'] != null
                    ? element['currentPoint'].toDouble()
                    : 0;
          }
        } else {
          auctionController.fetchAuction(widget.id);
        }

        auctionController.auction.refresh();
      });
    });

    await hubConnection.start();
  }

  @override
  void dispose() {
    _animationController.dispose();
    hubConnection.stop().then((value) => print('Connection stopped'));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    return Obx(
      () => Scaffold(
        floatingActionButton: (auctionController.auction.value.startDate!
                    .add(Duration(hours: 7))
                    .isBefore(DateTime.now()) &&
                auctionController.auction.value.actualEndDate!
                    .add(Duration(hours: 7))
                    .isAfter(DateTime.now()) &&
                auctionController.auction.value.isRegistered == true)
            ? Wrap(
                direction: Axis.horizontal,
                children: [
                  if (auctionController.auction.value.winner == null &&
                      (auctionController.auction.value.isSoldDirectly == true))
                    FloatingActionButton.extended(
                      heroTag: 'buy_now',
                      label: Text('Mua ngay',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      icon: Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.black,
                      ),
                      backgroundColor: Colors.white,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Lottie.asset('assets/lottie/buy_now.json'),
                                  Text(
                                    'Bạn có chắc chắn muốn mua với ${auctionController.auction.value.soldDirectlyPrice!.toStringAsFixed(0).formatNumberWithComma()}?',
                                    style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
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
                                                  BorderRadius.circular(20)))),
                                  onPressed: () async {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) {
                                          return LoadingDialog();
                                        });

                                    await auctionController.placeBid(
                                        auctionController.auction.value.id!,
                                        auctionController
                                            .auction.value.soldDirectlyPrice!
                                            .toInt());

                                    if (auctionController
                                        .isUpdateSuccess.value) {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                      await auctionController
                                          .fetchAuction(widget.id);
                                      await userController.getCurrentUser();
                                      toast('Mua thành công');
                                    } else {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) {
                                          return FailDialog(
                                              text: 'Mua thất bại!');
                                        },
                                      );
                                    }
                                  },
                                  child: Text(
                                    'Mua',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Roboto',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            );
                          },
                        );
                      },
                    ),
                  10.width,
                  FloatingActionButton.extended(
                    heroTag: 'bid',
                    label: Text(
                        auctionController.auction.value.currentBidPrice!
                            .toStringAsFixed(0)
                            .formatNumberWithComma(),
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                    icon: Image.asset(
                      ic_auction,
                      height: 30,
                      width: 30,
                      color: Colors.black,
                    ),
                    backgroundColor: Colors.white,
                    onPressed: () {
                      showModalBottomSheet(
                        elevation: 0,
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        transitionAnimationController: _animationController,
                        builder: (context) {
                          return FractionallySizedBox(
                            heightFactor: 0.7,
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
                                  child: BidScreen(auctionId: widget.id),
                                ).expand(),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                  10.width,
                  if (auctionController.auction.value.winner == null)
                    FloatingActionButton.extended(
                      heroTag: 'add_point',
                      label: Text('Điểm',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      icon: Icon(
                        Icons.add_outlined,
                        color: Colors.black,
                      ),
                      backgroundColor: Colors.white,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              title: Text(
                                'Thêm điểm vào ví đấu giá',
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Ví của bạn: ',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        '${userController.user.value.totalPoint!.toStringAsFixed(0).formatNumberWithComma()}',
                                        style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        ' điểm',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 18,
                                        ),
                                      )
                                    ],
                                  ),
                                  10.height,
                                  Row(
                                    children: [
                                      Text(
                                        'Ví đấu giá: ',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        '${auctionController.auction.value.currentPoint!.toStringAsFixed(0).formatNumberWithComma()}',
                                        style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        ' điểm',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 18,
                                        ),
                                      )
                                    ],
                                  ),
                                  20.height,
                                  Form(
                                    key: addPointFormKey,
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          controller: addPointCont,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            hintText: 'Nhập số điểm',
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                width: 3,
                                                color: Color(0xFFB4D4FF),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                width: 3,
                                                color: Color(0xFFB4D4FF),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                            ),
                                            suffixIcon: Icon(
                                              Icons.token_outlined,
                                              color: Colors.black,
                                              size: 30,
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Hãy nhập số điểm';
                                            }
                                            return null;
                                          },
                                        ),
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
                                                  BorderRadius.circular(20)))),
                                  onPressed: () async {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) {
                                          return LoadingDialog();
                                        });

                                    await auctionController.depositePoints(
                                        widget.id, addPointCont.text.toInt());

                                    if (auctionController
                                        .isUpdateSuccess.value) {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                      await auctionController
                                          .fetchAuction(widget.id);
                                      await userController.getCurrentUser();
                                      toast('Điểm đã được thêm thành công');
                                    } else {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) {
                                          return FailDialog(
                                              text: 'Thêm thất bại!');
                                        },
                                      );
                                    }
                                  },
                                  child: Text(
                                    'Thêm',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Roboto',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            );
                          },
                        );
                      },
                    ),
                ],
              )
            : auctionController.auction.value.startRegisterAt!.add(Duration(hours: 7)).isBefore(DateTime.now()) &&
                    auctionController.auction.value.endRegisterAt!
                        .add(Duration(hours: 7))
                        .isAfter(DateTime.now()) &&
                    auctionController.auction.value.isRegistered == false
                ? FloatingActionButton.extended(
                    label: Text('Tham gia buổi đấu giá',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                    icon: Image.asset(
                      ic_join,
                      height: 30,
                      width: 30,
                      color: Colors.black,
                    ),
                    backgroundColor: Colors.white,
                    onPressed: () {
                      if (userController.user.value.isVerified == false) {
                        toast(
                            'Bạn cần xác thực tài khoản để tham gia buổi đấu giá');
                      } else {
                        showModalBottomSheet(
                          elevation: 0,
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          transitionAnimationController: _animationController,
                          builder: (context) {
                            return FractionallySizedBox(
                              heightFactor: 0.7,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 45,
                                    height: 5,
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
                                    child: PopScope(
                                      onPopInvoked: (isPop) {
                                        feeAmountCont.clear();
                                      },
                                      child: SingleChildScrollView(
                                        child: Container(
                                          padding: EdgeInsets.all(20),
                                          child: Column(
                                            children: [
                                              Text(
                                                'Đăng ký',
                                                style: TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Roboto'),
                                              ),
                                              20.height,
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Phí',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily: 'Roboto'),
                                                    ),
                                                    Text(
                                                      auctionController
                                                              .auction
                                                              .value
                                                              .registrationFee!
                                                              .toStringAsFixed(
                                                                  0)
                                                              .formatNumberWithComma() +
                                                          ' Điểm',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black
                                                              .withOpacity(0.5),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily: 'Roboto'),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              20.height,
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'Điểm tạm ứng',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: 'Roboto'),
                                                ),
                                              ),
                                              10.height,
                                              Form(
                                                key: registerationFormKey,
                                                child: Column(
                                                  children: [
                                                    TextFormField(
                                                      controller: feeAmountCont,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration:
                                                          InputDecoration(
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            width: 3,
                                                            color: Color(
                                                                0xFFB4D4FF),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50.0),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            width: 3,
                                                            color: Color(
                                                                0xFFB4D4FF),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
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
                                                          return 'Hãy nhập số điểm';
                                                        }
                                                        return null;
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              30.height,
                                              appButton(
                                                  text: 'Đăng ký',
                                                  context: context,
                                                  onTap: () async {
                                                    if (registerationFormKey
                                                        .currentState!
                                                        .validate()) {
                                                      registerationFormKey
                                                          .currentState!
                                                          .save();
                                                      hideKeyboard(context);
                                                      showConfirmDialogCustom(
                                                        context,
                                                        title: 'Bạn sẽ bị trừ  ' +
                                                            auctionController
                                                                .auction
                                                                .value
                                                                .registrationFee!
                                                                .toStringAsFixed(
                                                                    0)
                                                                .formatNumberWithComma() +
                                                            ' điểm lệ phí để tham gia buổi đấu giá này?',
                                                        onAccept: (p0) async {
                                                          showDialog(
                                                              context: context,
                                                              barrierDismissible:
                                                                  false,
                                                              builder:
                                                                  (context) {
                                                                return LoadingDialog();
                                                              });
                                                          await auctionController
                                                              .joinAuction(
                                                                  widget.id,
                                                                  int.parse(
                                                                      feeAmountCont
                                                                          .text));
                                                          if (auctionController
                                                              .isUpdateSuccess
                                                              .value) {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            await auctionController
                                                                .fetchAuction(
                                                                    widget.id);
                                                            await userController
                                                                .getCurrentUser();
                                                            toast(
                                                                'Join auction successfully');
                                                          } else {
                                                            Navigator.pop(
                                                                context);
                                                            showDialog(
                                                              context: context,
                                                              barrierDismissible:
                                                                  false,
                                                              builder:
                                                                  (context) {
                                                                return FailDialog(
                                                                    text: auctionController.message.value ==
                                                                            'USER_POINT_NOT_ENOUGH'
                                                                        ? 'Bạn không có đủ điểm để tham gia buổi đấu giá này'
                                                                        : 'Tham gia thất bại!');
                                                              },
                                                            );
                                                          }
                                                        },
                                                      );
                                                    }
                                                  })
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ).expand(),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    },
                  )
                : ((auctionController.auction.value.endRegisterAt!
                            .add(Duration(hours: 7))
                            .isAfter(DateTime.now())) &&
                        auctionController.auction.value.isRegistered == true)
                    ? FloatingActionButton.extended(
                        label: Text('Hủy đăng ký tham gia',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        icon: Icon(Icons.close_rounded, color: Colors.red),
                        backgroundColor: Colors.white,
                        onPressed: () {
                          showConfirmDialogCustom(context,
                              title:
                                  'Bạn có chắc chắn muốn hủy đăng ký tham gia buổi đấu giá này?',
                              onAccept: (p0) async {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return LoadingDialog();
                                });
                            await auctionController
                                .cancelRegistrationAuction(widget.id);
                            if (auctionController.isUpdateSuccess.value) {
                              Navigator.of(context).pop();

                              await auctionController.fetchAuction(widget.id);
                              await userController.getCurrentUser();
                              toast('Cancel registration successfully');
                            } else {
                              Navigator.pop(context);
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return FailDialog(
                                      text:
                                          'Failed to cancel registration this auction');
                                },
                              );
                            }
                          });
                        })
                    : auctionController.auction.value.startDate!
                                .add(Duration(hours: 7))
                                .isAfter(DateTime.now()) &&
                            auctionController.auction.value.endRegisterAt!
                                .add(Duration(hours: 7))
                                .isBefore(DateTime.now())
                        ? FloatingActionButton.extended(
                            label: Text('Đã đăng ký', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                            icon: Icon(Icons.check, color: Colors.green),
                            backgroundColor: Colors.white,
                            onPressed: () {})
                        : auctionController.auction.value.startDate!.add(Duration(hours: 7)).isBefore(DateTime.now())
                            ? FloatingActionButton.extended(
                                label: Text(
                                    auctionController
                                        .auction.value.currentBidPrice!
                                        .toStringAsFixed(0)
                                        .formatNumberWithComma(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                                icon: Image.asset(
                                  ic_auction,
                                  height: 30,
                                  width: 30,
                                  color: Colors.black,
                                ),
                                backgroundColor: Colors.white,
                                onPressed: () {
                                  showModalBottomSheet(
                                    elevation: 0,
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    transitionAnimationController:
                                        _animationController,
                                    builder: (context) {
                                      return FractionallySizedBox(
                                        heightFactor: 0.7,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 45,
                                              height: 5,
                                              //clipBehavior: Clip.hardEdge,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  color: Colors.white),
                                            ),
                                            8.height,
                                            Container(
                                              clipBehavior:
                                                  Clip.antiAliasWithSaveLayer,
                                              decoration: BoxDecoration(
                                                color: context.cardColor,
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(16),
                                                    topRight:
                                                        Radius.circular(16)),
                                              ),
                                              child: BidScreen(
                                                  auctionId: widget.id),
                                            ).expand(),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              )
                            : Offstage(),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: screenHeight * 0.535,
                        child: auctionController.auction.value.thumbnail != null
                            ? Image.network(
                                auctionController.auction.value.thumbnail!,
                                fit: BoxFit.cover,
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  return Image.asset(
                                    'assets/images/images.png',
                                    fit: BoxFit.cover,
                                  );
                                },
                              )
                            : Image.asset('assets/images/images.png',
                                fit: BoxFit.cover),
                      ),
                      Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              top: screenHeight * 0.1,
                              left: 10.0,
                              right: 10.0,
                            ),
                            height: screenHeight * 0.4,
                          ),
                          // Back button
                          Positioned(
                            top: screenHeight * 0.05,
                            left: 5,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.arrow_back),
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      await auctionController
                                          .fetchAuctions(null);
                                    },
                                  ),
                                  Text(
                                    language.auctionDetail,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                  Spacer(),
                                  TextIcon(
                                    prefix: Image.asset(
                                      ic_two_user,
                                      height: 25,
                                      width: 25,
                                      color: Colors.black,
                                    ),
                                    text: auctionController
                                        .auction.value.numberParticipated
                                        .toString(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment(1, 1),
                        colors: <Color>[
                          Color(0xFFebf4f5),
                          Color(0xFFb5c6e0),
                        ],
                      ),
                    ),
                    height: screenHeight * 0.465,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          DefaultTabController(
                            length: 3,
                            child: Column(
                              children: [
                                TabBar(
                                  tabs: [
                                    Tab(
                                      child: DefaultTextStyle(
                                        child: Text(
                                          language.auctionImage +
                                              '(${auctionController.auction.value.medias!.length})',
                                          style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontWeight: FontWeight.bold),
                                        ),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontFamily: 'Roboto'),
                                      ),
                                    ),
                                    Tab(
                                      child: DefaultTextStyle(
                                        child: Text(
                                          language.auctionInfomation,
                                          style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontWeight: FontWeight.bold),
                                        ),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontFamily: 'Roboto'),
                                      ),
                                    ),
                                    Tab(
                                      child: DefaultTextStyle(
                                        child: Text(language.auctionOrchid),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Roboto',
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height:
                                      330, // specify the height of the container
                                  child: TabBarView(
                                    children: [
                                      Container(
                                        height: 330,
                                        child: MasonryGridView.builder(
                                          itemCount: auctionController
                                              .auction.value.medias!.length,
                                          gridDelegate:
                                              const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                          ),
                                          itemBuilder: (context, index) =>
                                              Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: GestureDetector(
                                              child: Image.network(
                                                auctionController.auction.value
                                                    .medias![index].url!,
                                                fit: BoxFit.fill,
                                              ).cornerRadiusWithClipRRect(20),
                                              onTap: () => ImageScreen(
                                                      imageURl:
                                                          auctionController
                                                              .auction
                                                              .value
                                                              .medias![index]
                                                              .url!)
                                                  .launch(context),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 330,
                                        child: SingleChildScrollView(
                                            child: Column(
                                          children: [
                                            HtmlWidget(
                                              postContent: auctionController
                                                  .auction.value.description,
                                            )
                                          ],
                                        )),
                                      ),
                                      Container(
                                        height: 350,
                                        child: SingleChildScrollView(
                                          child: Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                10.height,
                                                Text(
                                                  auctionController.auction
                                                      .value.orchid!.name!,
                                                  style: TextStyle(
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Roboto'),
                                                ),
                                                15.height,
                                                Text(
                                                  auctionController
                                                      .auction
                                                      .value
                                                      .orchid!
                                                      .description!,
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color.fromARGB(
                                                          134, 0, 0, 0),
                                                      fontFamily: 'Roboto'),
                                                ),
                                                25.height,
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.9,
                                                            height: 80,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.5),
                                                                    spreadRadius:
                                                                        3,
                                                                    blurRadius:
                                                                        7,
                                                                    offset: Offset(
                                                                        0,
                                                                        3), // changes position of shadow
                                                                  ),
                                                                ]),
                                                            child: Row(
                                                              children: [
                                                                Image.asset(
                                                                    ic_botanical,
                                                                    height: 30,
                                                                    width: 30),
                                                                10.width,
                                                                Expanded(
                                                                    child:
                                                                        Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      language
                                                                          .botanicalName,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontFamily:
                                                                              'Roboto'),
                                                                    ),
                                                                    Flexible(
                                                                      child:
                                                                          Text(
                                                                        auctionController
                                                                            .auction
                                                                            .value
                                                                            .orchid!
                                                                            .botanicalName!,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            color: Color.fromARGB(
                                                                                134,
                                                                                0,
                                                                                0,
                                                                                0),
                                                                            fontFamily:
                                                                                'Roboto'),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        maxLines:
                                                                            2,
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                      ),
                                                                    )
                                                                  ],
                                                                ))
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      20.height,
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.4,
                                                            height: 80,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.5),
                                                                    spreadRadius:
                                                                        3,
                                                                    blurRadius:
                                                                        7,
                                                                    offset: Offset(
                                                                        0,
                                                                        3), // changes position of shadow
                                                                  ),
                                                                ]),
                                                            child: Row(
                                                              children: [
                                                                Image.asset(
                                                                    ic_plant,
                                                                    height: 30,
                                                                    width: 30),
                                                                10.width,
                                                                Expanded(
                                                                    child:
                                                                        Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      language
                                                                          .plantType,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontFamily:
                                                                              'Roboto'),
                                                                    ),
                                                                    Flexible(
                                                                      child:
                                                                          Text(
                                                                        auctionController
                                                                            .auction
                                                                            .value
                                                                            .orchid!
                                                                            .plantType!,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            color: Color.fromARGB(
                                                                                134,
                                                                                0,
                                                                                0,
                                                                                0),
                                                                            fontFamily:
                                                                                'Roboto'),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        maxLines:
                                                                            2,
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                      ),
                                                                    )
                                                                  ],
                                                                ))
                                                              ],
                                                            ),
                                                          ),
                                                          30.width,
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.4,
                                                            height: 80,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.5),
                                                                    spreadRadius:
                                                                        3,
                                                                    blurRadius:
                                                                        7,
                                                                    offset: Offset(
                                                                        0,
                                                                        3), // changes position of shadow
                                                                  ),
                                                                ]),
                                                            child: Row(
                                                              children: [
                                                                Image.asset(
                                                                    ic_family,
                                                                    height: 30,
                                                                    width: 30),
                                                                10.width,
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                        language
                                                                            .family,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                18,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontFamily: 'Roboto'),
                                                                      ),
                                                                      Flexible(
                                                                        child:
                                                                            Text(
                                                                          auctionController
                                                                              .auction
                                                                              .value
                                                                              .orchid!
                                                                              .family!,
                                                                          style: TextStyle(
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Color.fromARGB(134, 0, 0, 0),
                                                                              fontFamily: 'Roboto'),
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          maxLines:
                                                                              2,
                                                                          textAlign:
                                                                              TextAlign.start,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      20.height,
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.9,
                                                            height: 80,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.5),
                                                                    spreadRadius:
                                                                        3,
                                                                    blurRadius:
                                                                        7,
                                                                    offset: Offset(
                                                                        0,
                                                                        3), // changes position of shadow
                                                                  ),
                                                                ]),
                                                            child: Row(
                                                              children: [
                                                                Image.asset(
                                                                  ic_location,
                                                                  height: 30,
                                                                  width: 30,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                10.width,
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                        language
                                                                            .nativeArea,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                18,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontFamily: 'Roboto'),
                                                                      ),
                                                                      Flexible(
                                                                        child:
                                                                            Text(
                                                                          auctionController
                                                                              .auction
                                                                              .value
                                                                              .orchid!
                                                                              .nativeArea!,
                                                                          style: TextStyle(
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Color.fromARGB(134, 0, 0, 0),
                                                                              fontFamily: 'Roboto'),
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          maxLines:
                                                                              2,
                                                                          textAlign:
                                                                              TextAlign.start,
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
                                                      20.height,
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.4,
                                                            height: 80,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.5),
                                                                    spreadRadius:
                                                                        3,
                                                                    blurRadius:
                                                                        7,
                                                                    offset: Offset(
                                                                        0,
                                                                        3), // changes position of shadow
                                                                  ),
                                                                ]),
                                                            child: Row(
                                                              children: [
                                                                Image.asset(
                                                                    ic_plant_height,
                                                                    height: 30,
                                                                    width: 30),
                                                                10.width,
                                                                Expanded(
                                                                    child:
                                                                        Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      language
                                                                          .height,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontFamily:
                                                                              'Roboto'),
                                                                    ),
                                                                    Flexible(
                                                                      child:
                                                                          Text(
                                                                        auctionController
                                                                            .auction
                                                                            .value
                                                                            .orchid!
                                                                            .height!,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            color: Color.fromARGB(
                                                                                134,
                                                                                0,
                                                                                0,
                                                                                0),
                                                                            fontFamily:
                                                                                'Roboto'),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        maxLines:
                                                                            2,
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                      ),
                                                                    )
                                                                  ],
                                                                ))
                                                              ],
                                                            ),
                                                          ),
                                                          30.width,
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.4,
                                                            height: 80,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.5),
                                                                    spreadRadius:
                                                                        3,
                                                                    blurRadius:
                                                                        7,
                                                                    offset: Offset(
                                                                        0,
                                                                        3), // changes position of shadow
                                                                  ),
                                                                ]),
                                                            child: Row(
                                                              children: [
                                                                Image.asset(
                                                                  ic_sun,
                                                                  height: 30,
                                                                  width: 30,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                10.width,
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                        language
                                                                            .sunExposure,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                18,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontFamily: 'Roboto'),
                                                                      ),
                                                                      Flexible(
                                                                        child:
                                                                            Text(
                                                                          auctionController
                                                                              .auction
                                                                              .value
                                                                              .orchid!
                                                                              .sunExposure!,
                                                                          style: TextStyle(
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Color.fromARGB(134, 0, 0, 0),
                                                                              fontFamily: 'Roboto'),
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          maxLines:
                                                                              2,
                                                                          textAlign:
                                                                              TextAlign.start,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            if (auctionController.auction.value.winner != null)
              Positioned(
                top: screenHeight * 0.21,
                child: Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  padding: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment(0.8, 1),
                      colors: <Color>[
                        Color.fromARGB(133, 246, 213, 247),
                        Color.fromARGB(133, 251, 233, 215),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0.8,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      auctionController.auction.value.winner!.avatarUrl != null
                          ? Image.network(
                              auctionController.auction.value.winner!.avatarUrl
                                  .validate(),
                              height: 36,
                              width: 36,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/profile.png',
                                  height: 36,
                                  width: 36,
                                  fit: BoxFit.cover,
                                ).cornerRadiusWithClipRRect(100);
                              },
                            ).cornerRadiusWithClipRRect(100)
                          : Image.asset(
                              'assets/images/profile.png',
                              height: 36,
                              width: 36,
                              fit: BoxFit.cover,
                            ).cornerRadiusWithClipRRect(100),
                      10.width,
                      Flexible(
                        child: Text(
                          auctionController.auction.value.winner!.name!,
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      10.width,
                      Image.asset(ic_crown)
                    ],
                  ),
                ),
              ),
            Positioned(
              top: screenHeight * 0.3,
              left: 10,
              right: 10,
              child: Container(
                padding: EdgeInsets.only(
                  top: 10.0,
                  left: 20.0,
                  right: 20.0,
                  bottom: 9.0,
                ),
                width: MediaQuery.of(context).size.width,
                height: 190,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment(0.8, 1),
                    colors: <Color>[
                      Color(0xFFf6d5f7),
                      Color(0xFFfbe9d7),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0.8,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TimerCountdown(
                          format: CountDownTimerFormat.daysHoursMinutesSeconds,
                          endTime: DateTime.parse(auctionController
                                  .auction.value.startDate!
                                  .add(Duration(hours: 7))
                                  .isBefore(DateTime.now())
                              ? auctionController.auction.value.actualEndDate!
                                  .add(Duration(hours: 7))
                                  .toString()
                              : auctionController.auction.value.startDate!
                                  .add(Duration(hours: 7))
                                  .toString()),
                          timeTextStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                          ),
                          colonsTextStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                          ),
                          descriptionTextStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                            fontFamily: 'Roboto',
                          ),
                          daysDescription: language.auctionDays,
                          hoursDescription: language.auctionHours,
                          minutesDescription: language.auctionMinutes,
                          secondsDescription: language.auctionSeconds,
                          spacerWidth: 5,
                          onEnd: () async {
                            await auctionController.fetchAuction(widget.id);
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            auctionController.auction.value.title!,
                            style: TextStyle(
                                color: const Color.fromARGB(194, 0, 0, 0),
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                fontFamily: 'Roboto'),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    auctionController
                                        .auction.value.reservePrice!
                                        .toStringAsFixed(0)
                                        .formatNumberWithComma(),
                                    style: TextStyle(
                                      color: const Color.fromARGB(194, 0, 0, 0),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0,
                                      fontFamily: 'Roboto',
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    language.auctionStartPrice,
                                    style: secondaryTextStyle(
                                      color: const Color.fromARGB(194, 0, 0, 0),
                                      fontFamily: 'Roboto',
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (auctionController.auction.value.isSoldDirectly ==
                            true)
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      auctionController
                                          .auction.value.soldDirectlyPrice!
                                          .toStringAsFixed(0)
                                          .formatNumberWithComma(),
                                      style: TextStyle(
                                        color:
                                            const Color.fromARGB(194, 0, 0, 0),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0,
                                        fontFamily: 'Roboto',
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      language.auctionSoldDirectlyPrices,
                                      style: secondaryTextStyle(
                                        color:
                                            const Color.fromARGB(194, 0, 0, 0),
                                        fontFamily: 'Roboto',
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    auctionController.auction.value.stepPrice!
                                        .toStringAsFixed(0)
                                        .formatNumberWithComma(),
                                    style: TextStyle(
                                      color: const Color.fromARGB(194, 0, 0, 0),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0,
                                      fontFamily: 'Roboto',
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    language.auctionStepPrice,
                                    style: secondaryTextStyle(
                                      color: const Color.fromARGB(194, 0, 0, 0),
                                      fontFamily: 'Roboto',
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              child: LoadingWidget()
                  .center()
                  .visible(auctionController.isLoading.value),
            ),
          ],
        ),
      ),
    );
  }
}

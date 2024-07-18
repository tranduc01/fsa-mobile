import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/controllers/topup_package_controller.dart';
import 'package:socialv/models/package/topup_package.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../components/loading_widget.dart';
import '../../../components/no_data_lottie_widget.dart';
import '../../../controllers/user_controller.dart';
import '../../../main.dart';
import '../../common/fail_dialog.dart';
import '../../common/loading_dialog.dart';

class TopupPackageScreen extends StatefulWidget {
  @override
  _TopupPackageScreen createState() => _TopupPackageScreen();
}

class _TopupPackageScreen extends State<TopupPackageScreen> {
  late TopupPackageController topupPackageController =
      Get.put(TopupPackageController());
  late UserController userController = Get.find();
  late WebViewController webViewController;
  List images = [
    "assets/images/money1.png",
    "assets/images/money2.png",
    "assets/images/money3.png",
    "assets/images/money4.png",
    "assets/images/money5.png",
    "assets/images/money5.png",
    "assets/images/money5.png",
    "assets/images/money5.png",
    "assets/images/money5.png",
    "assets/images/money5.png",
    "assets/images/money5.png",
    "assets/images/money5.png",
  ];

  @override
  void initState() {
    topupPackageController.fetchTopupPackages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "Packages",
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontFamily: "Roboto"),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Obx(
        () {
          if (topupPackageController.isLoading.value)
            return LoadingWidget().center();
          else if (topupPackageController.isError.value ||
              topupPackageController.topupPackages.isEmpty)
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: NoDataWidget(
                imageWidget: NoDataLottieWidget(),
                title: topupPackageController.isError.value
                    ? language.somethingWentWrong
                    : language.noDataFound,
                onRetry: () {
                  topupPackageController.fetchTopupPackages();
                },
                retryText: '   ' + language.clickToRefresh + '   ',
              ).center(),
            );
          else
            return Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    height: 250,
                    child: AnimatedListView(
                      itemCount: topupPackageController.topupPackages
                          .where((element) =>
                              element.isApplySale == true &&
                              element.saleEndAt!
                                  .add(Duration(hours: 7))
                                  .isAfter(DateTime.now()))
                          .length,
                      scrollDirection: Axis.horizontal,
                      slideConfiguration: SlideConfiguration(
                          delay: Duration(milliseconds: 80),
                          verticalOffset: 300),
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(right: 20),
                          width: (MediaQuery.of(context).size.width - 60) / 2,
                          height: 230,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment(0.8, 1),
                              colors: <Color>[
                                Color(0xFFf6d5f7),
                                Color(0xFFfbe9d7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.01),
                                spreadRadius: 10,
                                blurRadius: 3,
                              ),
                            ],
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 90,
                                  height: 90,
                                  decoration:
                                      BoxDecoration(shape: BoxShape.circle),
                                  child: Center(
                                    child: Image.asset(
                                      hot_deal,
                                      width: 200,
                                      height: 200,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      topupPackageController.topupPackages
                                          .where((element) =>
                                              element.isApplySale == true &&
                                              element.saleEndAt!
                                                  .add(Duration(hours: 7))
                                                  .isAfter(DateTime.now()))
                                          .toList()[index]
                                          .title!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                          color: Color(0xff67727d),
                                          fontFamily: "Roboto"),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      topupPackageController.topupPackages
                                              .where((element) =>
                                                  element.isApplySale == true &&
                                                  element.saleEndAt!
                                                      .add(Duration(hours: 7))
                                                      .isAfter(DateTime.now()))
                                              .toList()[index]
                                              .price!
                                              .toStringAsFixed(0)
                                              .formatNumberWithComma() +
                                          " VNĐ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Color.fromARGB(169, 0, 0, 0),
                                        fontFamily: "Roboto",
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                    Text(
                                      topupPackageController.topupPackages
                                              .where((element) =>
                                                  element.isApplySale == true &&
                                                  element.saleEndAt!
                                                      .add(Duration(hours: 7))
                                                      .isAfter(DateTime.now()))
                                              .toList()[index]
                                              .salePrice!
                                              .toStringAsFixed(0)
                                              .formatNumberWithComma() +
                                          " VNĐ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        fontFamily: "Roboto",
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ).onTap(() {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Stack(
                                children: [
                                  AlertDialog(
                                    title: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/packaging.png',
                                            height: 70,
                                            width: 70,
                                            fit: BoxFit.cover,
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color:
                                                  Color.fromARGB(98, 250, 2, 2),
                                            ),
                                            child: Text(
                                              topupPackageController
                                                  .topupPackages
                                                  .where((element) =>
                                                      element.isApplySale ==
                                                          true &&
                                                      element.saleEndAt!
                                                          .add(Duration(
                                                              hours: 7))
                                                          .isAfter(
                                                              DateTime.now()))
                                                  .toList()[index]
                                                  .title!,
                                              style: TextStyle(
                                                  fontFamily: "Roboto"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            if (topupPackageController
                                                    .topupPackages
                                                    .where((element) =>
                                                        element.isApplySale ==
                                                            true &&
                                                        element.saleEndAt!
                                                            .add(Duration(
                                                                hours: 7))
                                                            .isAfter(
                                                                DateTime.now()))
                                                    .toList()[index]
                                                    .isApplySale! &&
                                                topupPackageController
                                                    .topupPackages
                                                    .where((element) =>
                                                        element.isApplySale ==
                                                            true &&
                                                        element.saleEndAt!
                                                            .add(Duration(
                                                                hours: 7))
                                                            .isAfter(
                                                                DateTime.now()))
                                                    .toList()[index]
                                                    .saleEndAt!
                                                    .add(Duration(hours: 7))
                                                    .isAfter(DateTime.now()))
                                              Text(
                                                topupPackageController
                                                        .topupPackages
                                                        .where((element) =>
                                                            element.isApplySale ==
                                                                true &&
                                                            element.saleEndAt!
                                                                .add(Duration(
                                                                    hours: 7))
                                                                .isAfter(
                                                                    DateTime
                                                                        .now()))
                                                        .toList()[index]
                                                        .price!
                                                        .toStringAsFixed(0)
                                                        .formatNumberWithComma() +
                                                    " VNĐ",
                                                textAlign: TextAlign.start,
                                                style: boldTextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                  fontFamily: 'Roboto',
                                                  size: 15,
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                ),
                                              )
                                            else
                                              Text(
                                                topupPackageController
                                                        .topupPackages
                                                        .where((element) =>
                                                            element.isApplySale ==
                                                                true &&
                                                            element.saleEndAt!
                                                                .add(Duration(
                                                                    hours: 7))
                                                                .isAfter(
                                                                    DateTime
                                                                        .now()))
                                                        .toList()[index]
                                                        .price!
                                                        .toStringAsFixed(0)
                                                        .formatNumberWithComma() +
                                                    " VNĐ",
                                                textAlign: TextAlign.start,
                                                style: boldTextStyle(
                                                  fontFamily: 'Roboto',
                                                  size: 15,
                                                ),
                                              ),
                                            if (topupPackageController
                                                    .topupPackages
                                                    .where((element) =>
                                                        element.isApplySale ==
                                                            true &&
                                                        element.saleEndAt!
                                                            .add(Duration(
                                                                hours: 7))
                                                            .isAfter(
                                                                DateTime.now()))
                                                    .toList()[index]
                                                    .isApplySale! &&
                                                topupPackageController
                                                    .topupPackages
                                                    .where((element) =>
                                                        element.isApplySale ==
                                                            true &&
                                                        element.saleEndAt!
                                                            .add(Duration(
                                                                hours: 7))
                                                            .isAfter(
                                                                DateTime.now()))
                                                    .toList()[index]
                                                    .saleEndAt!
                                                    .add(Duration(hours: 7))
                                                    .isAfter(DateTime.now()))
                                              Row(
                                                children: [
                                                  Icon(Icons
                                                      .arrow_right_alt_outlined),
                                                  Text(
                                                    topupPackageController
                                                            .topupPackages
                                                            .where((element) =>
                                                                element.isApplySale ==
                                                                    true &&
                                                                element
                                                                    .saleEndAt!
                                                                    .add(Duration(
                                                                        hours:
                                                                            7))
                                                                    .isAfter(
                                                                        DateTime
                                                                            .now()))
                                                            .toList()[index]
                                                            .salePrice!
                                                            .toStringAsFixed(0)
                                                            .formatNumberWithComma() +
                                                        " VNĐ",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 3,
                                                    textAlign: TextAlign.start,
                                                    style: boldTextStyle(
                                                      fontFamily: 'Roboto',
                                                      size: 15,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color:
                                                Color.fromARGB(97, 2, 250, 19),
                                          ),
                                          child: Text(
                                            "+" +
                                                topupPackageController
                                                    .topupPackages
                                                    .where((element) =>
                                                        element.isApplySale ==
                                                            true &&
                                                        element.saleEndAt!
                                                            .add(Duration(
                                                                hours: 7))
                                                            .isAfter(
                                                                DateTime.now()))
                                                    .toList()[index]
                                                    .pointEarned
                                                    .toString() +
                                                ' Điểm',
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          child: Column(children: [
                                            Text(
                                              topupPackageController
                                                  .topupPackages
                                                  .where((element) =>
                                                      element.isApplySale ==
                                                          true &&
                                                      element.saleEndAt!
                                                          .add(Duration(
                                                              hours: 7))
                                                          .isAfter(
                                                              DateTime.now()))
                                                  .toList()[index]
                                                  .description!,
                                              style: TextStyle(
                                                  fontFamily: 'Roboto'),
                                              textAlign: TextAlign.center,
                                            ),
                                            20.height,
                                            if (topupPackageController
                                                    .topupPackages
                                                    .where((element) =>
                                                        element.isApplySale ==
                                                            true &&
                                                        element.saleEndAt!
                                                            .add(Duration(
                                                                hours: 7))
                                                            .isAfter(
                                                                DateTime.now()))
                                                    .toList()[index]
                                                    .isApplySale! &&
                                                topupPackageController
                                                    .topupPackages
                                                    .where((element) =>
                                                        element.isApplySale ==
                                                            true &&
                                                        element.saleEndAt!
                                                            .add(Duration(
                                                                hours: 7))
                                                            .isAfter(
                                                                DateTime.now()))
                                                    .toList()[index]
                                                    .saleEndAt!
                                                    .add(Duration(hours: 7))
                                                    .isAfter(DateTime.now()))
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Giảm giá sẽ kết thúc sau: ",
                                                    style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize: 16),
                                                  ),
                                                  SizedBox(
                                                    width: 30,
                                                  ),
                                                  Text(
                                                    topupPackageController
                                                            .topupPackages
                                                            .where((element) =>
                                                                element.isApplySale ==
                                                                    true &&
                                                                element
                                                                    .saleEndAt!
                                                                    .add(Duration(
                                                                        hours:
                                                                            7))
                                                                    .isAfter(
                                                                        DateTime
                                                                            .now()))
                                                            .toList()[index]
                                                            .saleEndAt!
                                                            .difference(
                                                                DateTime.now())
                                                            .inDays
                                                            .toString() +
                                                        ' ngày',
                                                    style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18),
                                                  ),
                                                ],
                                              ),
                                          ]),
                                        )
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Hủy',
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
                                          var url = await topupPackageController
                                              .processPayment(
                                                  topupPackageController
                                                      .topupPackages
                                                      .where((element) =>
                                                          element
                                                                  .isApplySale ==
                                                              true &&
                                                          element.saleEndAt!
                                                              .add(Duration(
                                                                  hours: 7))
                                                              .isAfter(DateTime
                                                                  .now()))
                                                      .toList()[index]
                                                      .id!);

                                          if (!topupPackageController
                                                  .isLoading.value &&
                                              !topupPackageController
                                                  .isError.value) {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            webViewController =
                                                WebViewController()
                                                  ..setJavaScriptMode(
                                                      JavaScriptMode
                                                          .unrestricted)
                                                  ..loadRequest(Uri.parse(url));
                                            webViewController
                                                .setNavigationDelegate(
                                                    NavigationDelegate(
                                              onPageStarted:
                                                  (String url) async {
                                                // This callback will be called when a new page starts loading
                                                print(
                                                    'Page started loading: $url');
                                                final uri = Uri.parse(url);
                                                final transactionStatus = uri
                                                        .queryParameters[
                                                    'vnp_TransactionStatus'];
                                                print(transactionStatus);

                                                if (transactionStatus != null) {
                                                  bool result =
                                                      transactionStatus == '00';
                                                  Navigator.of(navigatorKey
                                                          .currentContext!)
                                                      .pop(); // Close the payment dialog

                                                  if (result) {
                                                    await userController
                                                        .getCurrentUser();
                                                  }
                                                  showDialog(
                                                    context: navigatorKey
                                                        .currentContext!,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                        title: result
                                                            ? Text(
                                                                'Giao dịch thành công')
                                                            : Text(
                                                                'Giao dịch thất bại'),
                                                        content: result
                                                            ? Lottie.asset(
                                                                'assets/lottie/success.json',
                                                                height: 250,
                                                                width: 250,
                                                              )
                                                            : Lottie.asset(
                                                                'assets/lottie/fail.json',
                                                                height: 250,
                                                                width: 250,
                                                              ),
                                                        actions: [
                                                          appButton(
                                                              text: 'Đồng ý',
                                                              onTap: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              context: context),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                }
                                              },
                                              onPageFinished: (String url) {
                                                // This callback will be called when a page finishes loading
                                                print(
                                                    'Page finished loading: $url');
                                              },
                                              onWebResourceError:
                                                  (WebResourceError error) {
                                                // This callback will be called if there's an error loading the page
                                                print(
                                                    'Error loading page: ${error.description}');
                                              },
                                            ));

                                            showDialog(
                                              context:
                                                  navigatorKey.currentContext!,
                                              builder: (context) {
                                                return Dialog(
                                                  child: WebViewWidget(
                                                      controller:
                                                          webViewController),
                                                );
                                              },
                                            );
                                          } else {
                                            Navigator.pop(context);
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (context) {
                                                return FailDialog(
                                                    text: 'Giao dịch thất bại');
                                              },
                                            );
                                          }
                                        },
                                        child: Text('Mua',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Roboto',
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    top: MediaQuery.of(context).size.height *
                                            0.5 -
                                        (280 / 2) -
                                        156.5,
                                    left: MediaQuery.of(context).size.width *
                                            0.5 -
                                        (280 / 2) -
                                        97.2,
                                    child: Image.asset(
                                      "assets/images/2.png",
                                      height: 280,
                                      width: 280,
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: AnimatedListView(
                        itemCount: topupPackageController.topupPackages.length,
                        slideConfiguration: SlideConfiguration(
                            delay: Duration(milliseconds: 80),
                            verticalOffset: 300),
                        itemBuilder: (context, index) {
                          TopupPackage topupPackage =
                              topupPackageController.topupPackages[index];
                          return InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Stack(
                                    children: [
                                      AlertDialog(
                                        title: Container(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/images/packaging.png',
                                                height: 70,
                                                width: 70,
                                                fit: BoxFit.cover,
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Container(
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Color.fromARGB(
                                                      98, 250, 2, 2),
                                                ),
                                                child: Text(
                                                  topupPackage.title!,
                                                  style: TextStyle(
                                                      fontFamily: "Roboto"),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                if (topupPackage.isApplySale! &&
                                                    topupPackage.saleStartAt!
                                                        .add(Duration(hours: 7))
                                                        .isBefore(
                                                            DateTime.now()) &&
                                                    topupPackage.saleEndAt!
                                                        .add(Duration(hours: 7))
                                                        .isAfter(
                                                            DateTime.now()))
                                                  Text(
                                                    topupPackage.price!
                                                            .toStringAsFixed(0)
                                                            .formatNumberWithComma() +
                                                        " VNĐ",
                                                    textAlign: TextAlign.start,
                                                    style: boldTextStyle(
                                                      fontFamily: 'Roboto',
                                                      size: 15,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                    ),
                                                  )
                                                else
                                                  Text(
                                                    topupPackage.price!
                                                            .toStringAsFixed(0)
                                                            .formatNumberWithComma() +
                                                        " VNĐ",
                                                    textAlign: TextAlign.start,
                                                    style: boldTextStyle(
                                                      fontFamily: 'Roboto',
                                                      size: 15,
                                                    ),
                                                  ),
                                                if (topupPackage.isApplySale! &&
                                                    topupPackage.saleStartAt!
                                                        .add(Duration(hours: 7))
                                                        .isBefore(
                                                            DateTime.now()) &&
                                                    topupPackage.saleEndAt!
                                                        .add(Duration(hours: 7))
                                                        .isAfter(
                                                            DateTime.now()))
                                                  Row(
                                                    children: [
                                                      Icon(Icons
                                                          .arrow_right_alt_outlined),
                                                      Text(
                                                        topupPackage.salePrice!
                                                                .toStringAsFixed(
                                                                    0)
                                                                .formatNumberWithComma() +
                                                            " VNĐ",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 3,
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: boldTextStyle(
                                                          fontFamily: 'Roboto',
                                                          size: 15,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Color.fromARGB(
                                                    97, 2, 250, 19),
                                              ),
                                              child: Text(
                                                "+" +
                                                    topupPackage.pointEarned
                                                        .toString() +
                                                    ' Điểm',
                                                style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Container(
                                              child: Column(children: [
                                                Text(
                                                  topupPackage.description!,
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto'),
                                                  textAlign: TextAlign.center,
                                                ),
                                                20.height,
                                                if (topupPackage.isApplySale! &&
                                                    topupPackage.saleStartAt!
                                                        .add(Duration(hours: 7))
                                                        .isBefore(
                                                            DateTime.now()) &&
                                                    topupPackage.saleEndAt!
                                                        .add(Duration(hours: 7))
                                                        .isAfter(
                                                            DateTime.now()))
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "Giảm giá sẽ kết thúc sau: ",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Roboto',
                                                            fontSize: 16),
                                                      ),
                                                      SizedBox(
                                                        width: 30,
                                                      ),
                                                      Text(
                                                        topupPackage.saleEndAt!
                                                                .difference(
                                                                    DateTime
                                                                        .now())
                                                                .inDays
                                                                .toString() +
                                                            ' ngày',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Roboto',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18),
                                                      ),
                                                    ],
                                                  ),
                                              ]),
                                            )
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Hủy',
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
                                                    WidgetStateProperty.all(
                                                        context.primaryColor),
                                                shape:
                                                    WidgetStateProperty.all(
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)))),
                                            onPressed: () async {
                                              showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (context) {
                                                    return LoadingDialog();
                                                  });
                                              var url =
                                                  await topupPackageController
                                                      .processPayment(
                                                          topupPackage.id!);

                                              if (!topupPackageController
                                                      .isLoading.value &&
                                                  !topupPackageController
                                                      .isError.value) {
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                                webViewController =
                                                    WebViewController()
                                                      ..setJavaScriptMode(
                                                          JavaScriptMode
                                                              .unrestricted)
                                                      ..loadRequest(
                                                          Uri.parse(url));
                                                webViewController
                                                    .setNavigationDelegate(
                                                        NavigationDelegate(
                                                  onPageStarted: (String url) {
                                                    // This callback will be called when a new page starts loading
                                                    print(
                                                        'Page started loading: $url');
                                                  },
                                                  onPageFinished:
                                                      (String url) async {
                                                    // This callback will be called when a page finishes loading
                                                    print(
                                                        'Page finished loading: $url');
                                                    final uri = Uri.parse(url);
                                                    final transactionStatus = uri
                                                            .queryParameters[
                                                        'vnp_TransactionStatus'];
                                                    print(transactionStatus);

                                                    if (transactionStatus !=
                                                        null) {
                                                      bool result =
                                                          transactionStatus ==
                                                              '00';
                                                      Navigator.of(navigatorKey
                                                              .currentContext!)
                                                          .pop(); // Close the payment dialog

                                                      if (result) {
                                                        await userController
                                                            .getCurrentUser();
                                                      }
                                                      showDialog(
                                                        context: navigatorKey
                                                            .currentContext!,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20)),
                                                            title: result
                                                                ? Text(
                                                                    'Giao dịch thành công')
                                                                : Text(
                                                                    'Giao dịch thất bại'),
                                                            content: result
                                                                ? Lottie.asset(
                                                                    'assets/lottie/success.json',
                                                                    height: 250,
                                                                    width: 250,
                                                                  )
                                                                : Lottie.asset(
                                                                    'assets/lottie/fail.json',
                                                                    height: 250,
                                                                    width: 250,
                                                                  ),
                                                            actions: [
                                                              appButton(
                                                                  text:
                                                                      'Đồng ý',
                                                                  onTap: () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  context:
                                                                      context),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    }
                                                  },
                                                  onWebResourceError:
                                                      (WebResourceError error) {
                                                    // This callback will be called if there's an error loading the page
                                                    print(
                                                        'Error loading page: ${error.description}');
                                                  },
                                                ));

                                                showDialog(
                                                  context: navigatorKey
                                                      .currentContext!,
                                                  builder: (context) {
                                                    return Dialog(
                                                      child: WebViewWidget(
                                                          controller:
                                                              webViewController),
                                                    );
                                                  },
                                                );
                                              } else {
                                                Navigator.pop(context);
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (context) {
                                                    return FailDialog(
                                                        text:
                                                            'Giao dịch thất bại');
                                                  },
                                                );
                                              }
                                            },
                                            child: Text('Mua',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Roboto',
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ],
                                      ),
                                      Positioned(
                                        top:
                                            MediaQuery.of(context).size.height *
                                                    0.5 -
                                                (280 / 2) -
                                                156.5,
                                        left:
                                            MediaQuery.of(context).size.width *
                                                    0.5 -
                                                (280 / 2) -
                                                97.2,
                                        child: Image.asset(
                                          "assets/images/2.png",
                                          height: 280,
                                          width: 280,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width:
                                          (MediaQuery.of(context).size.width -
                                                  70) *
                                              0.7,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:
                                                  Colors.grey.withOpacity(0.1),
                                            ),
                                            child: Center(
                                              child: Image.asset(
                                                images[index],
                                                width: 30,
                                                height: 30,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 15),
                                          Container(
                                            width: (MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    90) *
                                                0.5,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  topupPackage.title!,
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: "Roboto",
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  topupPackage.pointEarned
                                                          .toString() +
                                                      " Điểm",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: "Roboto",
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width:
                                          (MediaQuery.of(context).size.width -
                                                  40) *
                                              0.3,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            topupPackage.price!
                                                    .toStringAsFixed(0)
                                                    .formatNumberWithComma() +
                                                " VNĐ",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                              color: Colors.green,
                                              fontFamily: "Roboto",
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 65, top: 8),
                                  child: Divider(
                                    thickness: 0.8,
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
        },
      ),
    );
  }
}

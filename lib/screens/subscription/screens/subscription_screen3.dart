import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/controllers/expertise_package_controller.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/package/expertise_package.dart';

import '../../../components/loading_widget.dart';
import '../../../components/no_data_lottie_widget.dart';

class SubscriptionScreen3 extends StatefulWidget {
  @override
  _SubscriptionScreen3 createState() => _SubscriptionScreen3();
}

class _SubscriptionScreen3 extends State<SubscriptionScreen3> {
  Color _color = Color.fromRGBO(98, 121, 193, 1);
  bool tap = true;

  late ExpertisePackageController expertisePackageController =
      Get.put(ExpertisePackageController());

  @override
  void initState() {
    super.initState();
    expertisePackageController.fetchExpetisePackages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        language.purchasePackage,
        style: TextStyle(
          color: Colors.black,
          fontFamily: "Roboto",
        ),
      )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                color: _color,
              ),
              child: Image.asset("assets/images/sale.png", fit: BoxFit.cover),
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(padding: EdgeInsets.only(left: 15)),
                Text(
                  language.packages,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                  ),
                ),
              ],
            ),
            Obx(() {
              if (expertisePackageController.isLoading.value)
                return LoadingWidget().center();
              else if (expertisePackageController.isError.value ||
                  expertisePackageController.expetisePackages.isEmpty)
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: NoDataWidget(
                    imageWidget: NoDataLottieWidget(),
                    title: expertisePackageController.isError.value
                        ? language.somethingWentWrong
                        : language.noDataFound,
                    onRetry: () {
                      expertisePackageController.fetchExpetisePackages();
                    },
                    retryText: '   ' + language.clickToRefresh + '   ',
                  ).center(),
                );
              else
                return Container(
                  padding: EdgeInsets.all(10),
                  height: MediaQuery.of(context).size.height * 0.6 - 51,
                  child: AnimatedListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    slideConfiguration: SlideConfiguration(
                        delay: Duration(milliseconds: 100),
                        verticalOffset: 300),
                    itemCount:
                        expertisePackageController.expetisePackages.length,
                    itemBuilder: (context, index) {
                      ExpertisePackage expertisePackage =
                          expertisePackageController.expetisePackages[index];
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
                                              color:
                                                  Color.fromARGB(98, 250, 2, 2),
                                            ),
                                            child: Text(
                                              expertisePackage.title!,
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
                                            if (expertisePackage.isApplySale! &&
                                                expertisePackage.saleStartAt!
                                                    .add(Duration(hours: 7))
                                                    .isBefore(DateTime.now()) &&
                                                expertisePackage.saleEndAt!
                                                    .add(Duration(hours: 7))
                                                    .isAfter(DateTime.now()))
                                              Text(
                                                expertisePackage.price!
                                                    .toStringAsFixed(0)
                                                    .formatNumberWithComma(),
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
                                                expertisePackage.price!
                                                    .toStringAsFixed(0)
                                                    .formatNumberWithComma(),
                                                textAlign: TextAlign.start,
                                                style: boldTextStyle(
                                                  fontFamily: 'Roboto',
                                                  size: 15,
                                                ),
                                              ),
                                            if (expertisePackage.isApplySale! &&
                                                expertisePackage.saleStartAt!
                                                    .add(Duration(hours: 7))
                                                    .isBefore(DateTime.now()) &&
                                                expertisePackage.saleEndAt!
                                                    .add(Duration(hours: 7))
                                                    .isAfter(DateTime.now()))
                                              Row(
                                                children: [
                                                  Icon(Icons
                                                      .arrow_right_alt_outlined),
                                                  Text(
                                                    !expertisePackage
                                                            .salePercent!.isZero
                                                        ? (expertisePackage
                                                                    .price! *
                                                                expertisePackage
                                                                    .salePercent! /
                                                                100)
                                                            .toStringAsFixed(0)
                                                            .formatNumberWithComma()
                                                        : expertisePackage
                                                            .salePrice!
                                                            .toStringAsFixed(0)
                                                            .formatNumberWithComma(),
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
                                                expertisePackage
                                                    .numberOfExpertise
                                                    .toString() +
                                                language.requestPackageCount,
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
                                              expertisePackage.description!,
                                              style: TextStyle(
                                                  fontFamily: 'Roboto'),
                                              textAlign: TextAlign.center,
                                            ),
                                            20.height,
                                            if (expertisePackage.isApplySale! &&
                                                expertisePackage.saleStartAt!
                                                    .add(Duration(hours: 7))
                                                    .isBefore(DateTime.now()) &&
                                                expertisePackage.saleEndAt!
                                                    .add(Duration(hours: 7))
                                                    .isAfter(DateTime.now()))
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Sale will end in: ",
                                                    style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize: 20),
                                                  ),
                                                  SizedBox(
                                                    width: 30,
                                                  ),
                                                  Text(
                                                    expertisePackage.saleEndAt!
                                                            .difference(
                                                                DateTime.now())
                                                            .inDays
                                                            .toString() +
                                                        ' days',
                                                    style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
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
                                        child: Text('Cancel',
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
                                        onPressed: () {},
                                        child: Text('Purchase',
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
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color.fromARGB(24, 0, 0, 0)),
                              borderRadius: radius(10),
                              color: Color.fromARGB(33, 200, 198, 198)),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/packaging.png',
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.cover,
                                        ).cornerRadiusWithClipRRect(15),
                                        12.width,
                                        Expanded(
                                          child: Container(
                                            height: 100,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  expertisePackage.title!,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 3,
                                                  textAlign: TextAlign.start,
                                                  style: boldTextStyle(
                                                      fontFamily: 'Roboto',
                                                      size: 18),
                                                ),
                                                Spacer(),
                                                Text(
                                                  expertisePackage.description!,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  textAlign: TextAlign.start,
                                                  style: boldTextStyle(
                                                    size: 15,
                                                    fontFamily: 'Roboto',
                                                    color: Color.fromARGB(
                                                        118, 0, 0, 0),
                                                  ),
                                                ),
                                                Spacer(),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    if (expertisePackage
                                                            .isApplySale! &&
                                                        expertisePackage
                                                            .saleStartAt!
                                                            .add(Duration(
                                                                hours: 7))
                                                            .isBefore(DateTime
                                                                .now()) &&
                                                        expertisePackage
                                                            .saleEndAt!
                                                            .add(Duration(
                                                                hours: 7))
                                                            .isAfter(
                                                                DateTime.now()))
                                                      Text(
                                                        expertisePackage.price!
                                                            .toStringAsFixed(0)
                                                            .formatNumberWithComma(),
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: boldTextStyle(
                                                          fontFamily: 'Roboto',
                                                          size: 15,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough,
                                                        ),
                                                      )
                                                    else
                                                      Text(
                                                        expertisePackage.price!
                                                            .toStringAsFixed(0)
                                                            .formatNumberWithComma(),
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: boldTextStyle(
                                                          fontFamily: 'Roboto',
                                                          size: 15,
                                                        ),
                                                      ),
                                                    if (expertisePackage
                                                            .isApplySale! &&
                                                        expertisePackage
                                                            .saleStartAt!
                                                            .add(Duration(
                                                                hours: 7))
                                                            .isBefore(DateTime
                                                                .now()) &&
                                                        expertisePackage
                                                            .saleEndAt!
                                                            .add(Duration(
                                                                hours: 7))
                                                            .isAfter(
                                                                DateTime.now()))
                                                      Row(
                                                        children: [
                                                          Icon(Icons
                                                              .arrow_right_alt_outlined),
                                                          Text(
                                                            !expertisePackage
                                                                    .salePercent!
                                                                    .isZero
                                                                ? (expertisePackage
                                                                            .price! *
                                                                        expertisePackage
                                                                            .salePercent! /
                                                                        100)
                                                                    .toStringAsFixed(
                                                                        0)
                                                                    .formatNumberWithComma()
                                                                : expertisePackage
                                                                    .salePrice!
                                                                    .toStringAsFixed(
                                                                        0)
                                                                    .formatNumberWithComma(),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 3,
                                                            textAlign:
                                                                TextAlign.start,
                                                            style:
                                                                boldTextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              size: 15,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    Spacer(),
                                                    Icon(
                                                      Icons
                                                          .shopping_cart_checkout,
                                                      color: Colors.black,
                                                      size: 25.0,
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
                              if (expertisePackage.isApplySale! &&
                                  expertisePackage.saleStartAt!
                                      .add(Duration(hours: 7))
                                      .isBefore(DateTime.now()) &&
                                  expertisePackage.saleEndAt!
                                      .add(Duration(hours: 7))
                                      .isAfter(DateTime.now()))
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Image.asset(
                                    "assets/images/saleicon.png",
                                    height: 30,
                                    width: 30,
                                  ), // Replace this with your widget
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
            }),
          ],
        ),
      ),
    );
  }
}

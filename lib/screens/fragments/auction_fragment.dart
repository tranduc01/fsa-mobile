import 'package:date_count_down/date_count_down.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/screens/auction/screen/auction_detail_screen.dart';

import '../../components/no_data_lottie_widget.dart';
import '../../controllers/auction_controller.dart';
import '../../main.dart';

class AuctionFragment extends StatefulWidget {
  final ScrollController controller;
  const AuctionFragment({super.key, required this.controller});
  @override
  _AutionFragmentState createState() => _AutionFragmentState();
}

class _AutionFragmentState extends State<AuctionFragment> {
  late AuctionController auctionController = Get.put(AuctionController());
  int mPage = 1;
  bool mIsLastPage = false;

  @override
  void initState() {
    auctionController.fetchAuctions(null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          Container(
            child: TabBar(
              labelColor: Colors.black,
              unselectedLabelColor: Color.fromARGB(171, 105, 104, 104),
              labelStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
              isScrollable: true,
              physics: BouncingScrollPhysics(),
              indicator: BoxDecoration(),
              tabs: [
                Tab(
                    child: Text(
                  language.auctionDiscover,
                )),
                Tab(
                  child: Text(
                    language.auctionUpcoming,
                  ),
                ),
                Tab(
                    child: Text(
                  language.auctionOngoing,
                )),
                Tab(
                  child: Text(
                    language.auctionEnded,
                  ),
                ),
              ],
              onTap: (index) {
                int? status;
                switch (index) {
                  case 0:
                    status = null;
                    break;
                  case 1:
                    status = 0;
                    break;
                  case 2:
                    status = 1;
                    break;
                  case 3:
                    status = 3;
                    break;
                  default:
                    status = 0;
                }
                auctionController.fetchAuctions(status);
              },
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            child: TabBarView(children: [
              auctionWidget(),
              auctionWidget(),
              auctionWidget(),
              auctionWidget(),
            ]),
          ),
        ],
      ),
    );
  }

  Widget auctionWidget() {
    return Obx(() {
      if (auctionController.isLoading.value)
        return LoadingWidget().center();
      else if (auctionController.isError.value ||
          auctionController.auctions.isEmpty)
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: NoDataWidget(
            imageWidget: NoDataLottieWidget(),
            title: auctionController.isError.value
                ? language.somethingWentWrong
                : language.noDataFound,
            onRetry: () {
              auctionController.fetchAuctions(null);
            },
            retryText: '   ' + language.clickToRefresh + '   ',
          ).center(),
        );
      else
        return AnimatedListView(
          padding: EdgeInsets.only(bottom: 200),
          itemCount: auctionController.auctions.length,
          slideConfiguration: SlideConfiguration(
              delay: Duration(milliseconds: 80), verticalOffset: 300),
          itemBuilder: (context, index) {
            var auction = auctionController.auctions[index];
            return InkWell(
              onTap: () {
                AuctionDetailSceen(
                  id: auction.id!,
                ).launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
              },
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.all(20),
                    height: 300.0,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Container(
                          height: 200.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: auction.thumbnail != null
                                  ? NetworkImage(auction.thumbnail!)
                                  : AssetImage('assets/images/images.png')
                                      as ImageProvider<Object>,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(73, 158, 158, 158),
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                            ),
                          ),
                          padding: EdgeInsets.all(10.0),
                          height: 100.0,
                          width: MediaQuery.of(context).size.width - 40,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(
                                child: Text(
                                  auction.title!,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                    fontFamily: 'Roboto',
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              if (auction.startDate!
                                      .add(Duration(hours: 7))
                                      .isAfter(DateTime.now()) &&
                                  auction.endDate!
                                      .add(Duration(hours: 7))
                                      .isAfter(DateTime.now()))
                                Column(
                                  children: [
                                    if (auction.startRegisterAt!
                                        .isAfter(DateTime.now()))
                                      Text('Start register in: ' +
                                          auction.startRegisterAt!
                                              .difference(DateTime.now())
                                              .inDays
                                              .toString() +
                                          ' days' +
                                          ' ' +
                                          auction.startRegisterAt!
                                              .difference(DateTime.now())
                                              .inHours
                                              .remainder(24)
                                              .toString() +
                                          ' hours' +
                                          ' ' +
                                          auction.startRegisterAt!
                                              .difference(DateTime.now())
                                              .inMinutes
                                              .remainder(60)
                                              .toString() +
                                          ' minutes'),
                                    if (auction.endRegisterAt!
                                            .isAfter(DateTime.now()) &&
                                        auction.startRegisterAt!
                                            .isBefore(DateTime.now()))
                                      Text('End register in: ' +
                                          auction.endRegisterAt!
                                              .difference(DateTime.now())
                                              .inDays
                                              .toString() +
                                          ' days' +
                                          ' ' +
                                          auction.endRegisterAt!
                                              .difference(DateTime.now())
                                              .inHours
                                              .remainder(24)
                                              .toString() +
                                          ' hours' +
                                          ' ' +
                                          auction.endRegisterAt!
                                              .difference(DateTime.now())
                                              .inMinutes
                                              .remainder(60)
                                              .toString() +
                                          ' minutes'),
                                  ],
                                )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (auction.startDate!
                          .add(Duration(hours: 7))
                          .isBefore(DateTime.now()) &&
                      auction.endDate!
                          .add(Duration(hours: 7))
                          .isAfter(DateTime.now()))
                    Positioned(
                      top: 35,
                      right: 35,
                      child: Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text(
                          language.auctionOnGoing,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    bottom: 100,
                    right: 20,
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                            )),
                        child: Row(
                          children: [
                            Container(
                                padding: EdgeInsets.all(5.0),
                                child: CountDownText(
                                  due: auction.startDate!
                                          .add(Duration(hours: 7))
                                          .isBefore(DateTime.now())
                                      ? auction.endDate!.add(Duration(hours: 7))
                                      : auction.startDate!
                                          .add(Duration(hours: 7)),
                                  finishedText: language.auctionEnded,
                                  showLabel: true,
                                  daysTextShort: "d ",
                                  hoursTextShort: "h ",
                                  minutesTextShort: "m ",
                                  secondsTextShort: "s ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                )),
                            Container(
                              padding: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(color: Colors.black),
                              child: Text(
                                language.auctionStart +
                                    auction.reservePrice!
                                        .toStringAsFixed(0)
                                        .formatNumberWithComma(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            );
          },
          shrinkWrap: true,
        );
    });
  }
}

import 'package:date_count_down/date_count_down.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/screens/auction/screen/auction_detail_screen.dart';

import '../../components/no_data_lottie_widget.dart';
import '../../controllers/auction_controller.dart';

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
                    'Discover',
                  )),
                  Tab(
                    child: Text(
                      'Upcoming',
                    ),
                  ),
                  Tab(
                      child: Text(
                    'Ongoing',
                  )),
                  Tab(
                    child: Text(
                      'My Auctions',
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
                      status = 2;
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
                Container(child: auctionWidget()),
                Container(child: auctionWidget()),
                Container(child: auctionWidget()),
                Container(child: auctionWidget()),
              ]),
            ),
          ],
        ));
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
                ? 'Something Went Wrong'
                : 'No data found',
            onRetry: () {
              auctionController.fetchAuctions(0);
            },
            retryText: '   Click to Refresh   ',
          ).center(),
        );
      else
        return AnimatedListView(
          padding: EdgeInsets.only(bottom: mIsLastPage ? 16 : 60),
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
                              10.height,
                              Row(
                                children: [
                                  Text(
                                    auction.title!,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.remove_red_eye,
                                    color: Colors.black,
                                    size: 14.0,
                                  ),
                                  5.width,
                                  Text(
                                    auction.view.toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.0,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                ],
                              ),
                              Flexible(
                                  child: Text(
                                auction.description!,
                                style: TextStyle(
                                  color: const Color.fromARGB(160, 0, 0, 0),
                                  fontSize: 14.0,
                                  fontFamily: 'Roboto',
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                textAlign: TextAlign.start,
                              )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (auction.startDate!.isBefore(DateTime.now()))
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
                          "Đang diễn ra",
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
                                  due: DateTime.parse(auction.startDate!
                                          .isBefore(DateTime.now())
                                      ? auction.endDate.toString()
                                      : auction.startDate.toString()),
                                  finishedText: "Ended",
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
                                'Start: ' +
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

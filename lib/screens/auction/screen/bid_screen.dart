import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
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
  TextEditingController commentController = TextEditingController();
  FocusNode commentFocus = FocusNode();

  late AuctionController auctionController = Get.put(AuctionController());
  late UserController userController = Get.put(UserController());

  int mPage = 1;
  bool mIsLastPage = false;

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

  Future<void> onRefresh() async {
    mPage = 1;
    auctionController.fetchAuction(widget.auctionId);
  }

  @override
  void dispose() {
    setStatusBarColorBasedOnTheme();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Obx(
            () {
              if (auctionController.isError.value) {
                return NoDataWidget(
                  imageWidget: NoDataLottieWidget(),
                  title: auctionController.isError.value
                      ? language.somethingWentWrong
                      : language.noDataFound,
                  onRetry: () {
                    onRefresh();
                  },
                  retryText: '   ${language.clickToRefresh}   ',
                ).center();
              }

              if (auctionController.auction.value.auctionBids!.isEmpty) {
                return NoDataWidget(
                  imageWidget: NoDataLottieWidget(),
                  title: language.noDataFound,
                  onRetry: () {
                    onRefresh();
                  },
                  retryText: '   ${language.clickToRefresh}   ',
                ).center();
              } else {
                return AnimatedListView(
                  shrinkWrap: true,
                  slideConfiguration: SlideConfiguration(
                    delay: Duration(milliseconds: 80),
                    verticalOffset: 300,
                  ),
                  physics: AlwaysScrollableScrollPhysics(),
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
                      //future = getCommentsList();
                    }
                  },
                );
              }
            },
          ),
          Obx(
            () {
              if (auctionController.isLoading.value) {
                return Positioned(
                  bottom: mPage != 1 ? 10 : null,
                  child: LoadingWidget(
                      isBlurBackground: mPage == 1 ? true : false),
                );
              } else {
                return Offstage();
              }
            },
          ),
        ],
      ),
    );
  }
}

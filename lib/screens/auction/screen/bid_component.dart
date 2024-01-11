import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../controllers/user_controller.dart';
import '../../../models/auction/bid.dart';
import '../../../utils/app_constants.dart';

class BidComponent extends StatefulWidget {
  final Bid bid;

  BidComponent({
    required this.bid,
  });

  @override
  State<BidComponent> createState() => _BidComponentState();
}

class _BidComponentState extends State<BidComponent> {
  bool isChange = false;
  late PageController pageController;
  late UserController userController = Get.put(UserController());

  @override
  void initState() {
    pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        8.height,
        Row(
          children: [
            widget.bid.bidder!.avatarUrl != null
                ? Image.network(
                    widget.bid.bidder!.avatarUrl.validate(),
                    height: 36,
                    width: 36,
                    fit: BoxFit.cover,
                  ).cornerRadiusWithClipRRect(100)
                : Image.asset(
                    'assets/images/profile.png',
                    height: 36,
                    width: 36,
                    fit: BoxFit.cover,
                  ).cornerRadiusWithClipRRect(100),
            16.width,
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: '${widget.bid.bidder!.name.validate()} ',
                          style:
                              boldTextStyle(size: 14, fontFamily: fontFamily)),
                      if (widget.bid.bidder!.isVerified.validate())
                        WidgetSpan(
                            child: Image.asset(ic_tick_filled,
                                height: 18,
                                width: 18,
                                color: blueTickColor,
                                fit: BoxFit.cover)),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                ),
                4.height,
                Text(convertToAgo(widget.bid.bidAt.toString().validate()),
                    style: secondaryTextStyle(size: 12)),
              ],
            ).expand(),
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Color.fromARGB(31, 0, 0, 0),
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: Text(
                  parseHtmlString(widget.bid.bidAmount
                          ?.toStringAsFixed(0)
                          .formatNumberWithComma()) +
                      ' điểm',
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ],
    );
  }
}

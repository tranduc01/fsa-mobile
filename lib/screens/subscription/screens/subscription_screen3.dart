import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class SubscriptionScreen3 extends StatefulWidget {
  @override
  _SubscriptionScreen3 createState() => _SubscriptionScreen3();
}

class _SubscriptionScreen3 extends State<SubscriptionScreen3> {
  String _image =
      "https://scontent.fsgn5-14.fna.fbcdn.net/v/t1.15752-9/368880605_308510311698750_1411479145021421749_n.jpg?_nc_cat=106&ccb=1-7&_nc_sid=ae9488&_nc_ohc=km19GMKqkR0AX_qWzd-&_nc_ht=scontent.fsgn5-14.fna&oh=03_AdQntgZRqpL_W9TL3DtgoweirTR1z7mtU3CnCTRLKKsKwg&oe=650C55E3";
  Color _backgroundColor = Color.fromRGBO(0, 61, 70, 1);
  Color _color = Color.fromRGBO(98, 121, 193, 1);
  bool tap = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        "Subscription",
        style: TextStyle(
          color: Colors.black,
          fontFamily: "Roboto",
        ),
      )),
      body: Column(
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
                "Package",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height * 0.6 - 51,
            child: AnimatedListView(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: BouncingScrollPhysics(),
              slideConfiguration: SlideConfiguration(
                  delay: Duration(milliseconds: 100), verticalOffset: 300),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                      border: Border.all(color: Color.fromARGB(24, 0, 0, 0)),
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
                                Image.network(
                                  _image,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace) {
                                    return Image.asset(
                                      'assets/images/packaging.png',
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ).cornerRadiusWithClipRRect(15);
                                  },
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
                                          'Combo 1',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                          textAlign: TextAlign.start,
                                          style: boldTextStyle(
                                              fontFamily: 'Roboto', size: 18),
                                        ),
                                        Spacer(),
                                        Text(
                                          'Combo 1 bao gồm 5 lần yêu cầu đánh giá',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          textAlign: TextAlign.start,
                                          style: boldTextStyle(
                                            size: 15,
                                            fontFamily: 'Roboto',
                                            color: Color.fromARGB(118, 0, 0, 0),
                                          ),
                                        ),
                                        Spacer(),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              '100.000 VNĐ',
                                              textAlign: TextAlign.start,
                                              style: boldTextStyle(
                                                fontFamily: 'Roboto',
                                                size: 15,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                              ),
                                            ),
                                            Icon(
                                                Icons.arrow_right_alt_outlined),
                                            Text(
                                              '50.000 VNĐ',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3,
                                              textAlign: TextAlign.start,
                                              style: boldTextStyle(
                                                fontFamily: 'Roboto',
                                                size: 15,
                                              ),
                                            ),
                                            Spacer(),
                                            Icon(
                                              Icons.shopping_cart_checkout,
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

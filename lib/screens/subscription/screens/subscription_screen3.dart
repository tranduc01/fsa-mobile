import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';

class SubscriptionScreen3 extends StatefulWidget {
  @override
  _SubscriptionScreen3 createState() => _SubscriptionScreen3();
}

class _SubscriptionScreen3 extends State<SubscriptionScreen3> {
  Color _backgroundColor = Color.fromRGBO(0, 61, 70, 1);
  Color _color = Color.fromRGBO(98, 121, 193, 1);
  bool tap = true;
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
                language.packages,
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
                return InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        late double feedbackRating = 0;
                        return Stack(
                          children: [
                            AlertDialog(
                              title: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                        borderRadius: BorderRadius.circular(10),
                                        color: Color.fromARGB(98, 250, 2, 2),
                                      ),
                                      child: Text(
                                        'Combo 1',
                                        style: TextStyle(fontFamily: "Roboto"),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "100.000 VNĐ",
                                        style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 15,
                                            decoration:
                                                TextDecoration.lineThrough),
                                      ),
                                      Icon(Icons.arrow_right_alt_outlined),
                                      Text(
                                        '50.000 VNĐ',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        textAlign: TextAlign.start,
                                        style: boldTextStyle(
                                          fontFamily: 'Roboto',
                                          size: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Color.fromARGB(97, 2, 250, 19),
                                    ),
                                    child: Text(
                                      "+ 5 lần yêu cầu đánh giá",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: Column(children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.check),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            "Lợi ích 1",
                                            style:
                                                TextStyle(fontFamily: 'Roboto'),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.check),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            "Lợi ích 2",
                                            style:
                                                TextStyle(fontFamily: 'Roboto'),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.check),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            "Lợi ích 3",
                                            style:
                                                TextStyle(fontFamily: 'Roboto'),
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
                                          MaterialStateProperty.all(
                                              context.primaryColor),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)))),
                                  onPressed: () {},
                                  child: Text(language.purchase,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Roboto',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            Positioned(
                              top: MediaQuery.of(context).size.height * 0.5 -
                                  (280 / 2) -
                                  156.5, // Half of screen height minus half of image height
                              left: MediaQuery.of(context).size.width * 0.5 -
                                  (280 / 2) -
                                  97.2, // Half of screen width minus half of image width
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
                                              color:
                                                  Color.fromARGB(118, 0, 0, 0),
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
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                ),
                                              ),
                                              Icon(Icons
                                                  .arrow_right_alt_outlined),
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SubscriptionScreen3 extends StatefulWidget {
  @override
  _SubscriptionScreen3 createState() => _SubscriptionScreen3();
}

class _SubscriptionScreen3 extends State<SubscriptionScreen3> {
  String _image =
      "https://scontent.fsgn5-14.fna.fbcdn.net/v/t1.15752-9/368880605_308510311698750_1411479145021421749_n.jpg?_nc_cat=106&ccb=1-7&_nc_sid=ae9488&_nc_ohc=km19GMKqkR0AX_qWzd-&_nc_ht=scontent.fsgn5-14.fna&oh=03_AdQntgZRqpL_W9TL3DtgoweirTR1z7mtU3CnCTRLKKsKwg&oe=650C55E3";
  Color _backgroundColor = Color.fromRGBO(0, 61, 70, 1);
  Color _color = Color.fromRGBO(98, 121, 193, 1);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 24.0,
            left: 16.0,
            right: 16.0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.deepPurple,
              ),
            ),
          ),
          Positioned(
            top: 32.0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: NetworkImage(_image),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                children: <Widget>[
                  SafeArea(
                    top: true,
                    left: true,
                    right: true,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.0),
                      height: 40.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Spacer(),
                          Container(
                            height: 40.0,
                            width: 200.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Student Assistant ",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      height: 24.0,
                                      width: 40.0,
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(242, 197, 145, 1),
                                        borderRadius:
                                            BorderRadius.circular(2.0),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Plus",
                                          style: TextStyle(
                                            color: _backgroundColor,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Text(
                                  "open full access to space",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          Container(
                            height: 32.0,
                            width: 32.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.black),
                            child: Center(
                                child: Icon(
                              Icons.close,
                              size: 20.0,
                              color: Colors.white,
                            )),
                          )
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    height: 250.0,
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 16.0, right: 8.0, top: 64.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Flexible(
                                  flex: 6,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "3",
                                        style: TextStyle(
                                          color: _color,
                                          fontSize: 40.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "months",
                                        style: TextStyle(
                                          color: _color,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      Text(
                                        "\$26.99",
                                        style: TextStyle(
                                          color: _color,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  color: _color,
                                  height: 2.0,
                                ),
                                Flexible(
                                  flex: 3,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "\$8.99",
                                        style: TextStyle(
                                          color: _color,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "per month",
                                        style: TextStyle(
                                          color: _color.withOpacity(0.5),
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Stack(
                            children: <Widget>[
                              Positioned(
                                top: 8.0,
                                right: 8.0,
                                left: 8.0,
                                bottom: 12.0,
                                child: Container(
                                  height: 250.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: _color,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height: 16.0,
                                          child: Center(
                                            child: Text(
                                              "POPULAR".toUpperCase(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 4.0,
                                        ),
                                        Flexible(
                                          flex: 6,
                                          child: Container(
                                            color: Colors.white,
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    "12",
                                                    style: TextStyle(
                                                      color: _color,
                                                      fontSize: 40.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    "months",
                                                    style: TextStyle(
                                                      color: _color,
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 8.0,
                                                  ),
                                                  Text(
                                                    "\$119. 88",
                                                    style: TextStyle(
                                                      color: _color
                                                          .withOpacity(0.5),
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                    ),
                                                  ),
                                                  Text(
                                                    "\$79.99",
                                                    style: TextStyle(
                                                      color: _color,
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 2.0,
                                          color: _color,
                                        ),
                                        Flexible(
                                          flex: 3,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(8.0),
                                                bottomRight:
                                                    Radius.circular(8.0),
                                              ),
                                            ),
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    "\$6.67",
                                                    style: TextStyle(
                                                      color: _color,
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    "per month",
                                                    style: TextStyle(
                                                      color: _color
                                                          .withOpacity(0.5),
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Icon(
                                  Icons.check_circle,
                                  size: 28.0,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(
                              margin: EdgeInsets.only(
                                  left: 8.0, right: 16.0, top: 64.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Colors.white,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Flexible(
                                    flex: 6,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "6",
                                          style: TextStyle(
                                            color: _color,
                                            fontSize: 40.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "months",
                                          style: TextStyle(
                                            color: _color,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8.0,
                                        ),
                                        Text(
                                          "\$46.99",
                                          style: TextStyle(
                                            color: _color,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    color: _color,
                                    height: 2.0,
                                  ),
                                  Flexible(
                                    flex: 3,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "\$7.99",
                                          style: TextStyle(
                                            color: _color,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "per month",
                                          style: TextStyle(
                                            color: _color.withOpacity(0.5),
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    "Select your plan after 7 days",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Trial period",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 16.0,
                    ),
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Center(
                      child: Text(
                        "Try for free",
                        style: TextStyle(
                          color: _color,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    "By clicking subscribe, you agree to the rules",
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w600,
                      fontSize: 10.0,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "for ",
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w600,
                            fontSize: 10.0,
                          ),
                        ),
                        TextSpan(
                          text: "using the services ",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 10.0,
                          ),
                        ),
                        TextSpan(
                          text: "and ",
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w600,
                            fontSize: 10.0,
                          ),
                        ),
                        TextSpan(
                          text: "processing personal data",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 10.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 32.0,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

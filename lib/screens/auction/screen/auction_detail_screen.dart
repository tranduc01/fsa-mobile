import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

class AcutionDetailSceen extends StatefulWidget {
  @override
  _AcutionDetailSceenState createState() => _AcutionDetailSceenState();
}

class _AcutionDetailSceenState extends State<AcutionDetailSceen> {
  bool isShowOrchidInfo = false;
  bool isShowAuctionInfo = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Stack(
                children: [
                  ImageSlideshow(
                    height: screenHeight * 0.535,
                    children: [
                      ClipRRect(
                        child: ImageFiltered(
                          imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Image.network(
                            "https://hoatuoithanhthao.com/media/ftp/hoa-lan-5.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      ClipRRect(
                        child: ImageFiltered(
                          imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Image.network(
                            "https://hoatuoithanhthao.com/media/ftp/hoa-lan.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                    autoPlayInterval: 15000,
                    isLoop: true,
                    initialPage: 0,
                  ),
                  Stack(
                    children: [
                      // Your existing Container widget
                      Container(
                        margin: EdgeInsets.only(
                          top: screenHeight * 0.1,
                          left: 10.0,
                          right: 10.0,
                        ),
                        height: screenHeight * 0.4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.white.withOpacity(0.5),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20.0),
                          ),
                          child: ImageSlideshow(
                            height: screenHeight * 0.535,
                            children: [
                              Image.network(
                                "https://hoatuoithanhthao.com/media/ftp/hoa-lan-5.jpg",
                                fit: BoxFit.cover,
                              ),
                              Image.network(
                                "https://hoatuoithanhthao.com/media/ftp/hoa-lan.jpg",
                                fit: BoxFit.cover,
                              ),
                            ],
                            autoPlayInterval: 15000,
                            isLoop: true,
                            initialPage: 0,
                          ),
                        ),
                      ),
                      // Back button
                      Positioned(
                        top: screenHeight *
                            0.05, // same as the top margin of the Container
                        left: 5, // same as the left margin of the Container
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            Text(
                              "Chi tiết đấu giá",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment(0.8, 1),
                    colors: <Color>[
                      Color(0xFFebf4f5),
                      Color.fromARGB(160, 181, 198, 224),
                    ],
                  ),
                ),
                height: screenHeight * 0.07,
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
                height: screenHeight * 0.395,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "HOA LAN ĐỘT BIẾN",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: isShowOrchidInfo
                                ? Icon(Icons.keyboard_arrow_up)
                                : Icon(Icons.keyboard_arrow_down),
                            onPressed: () {
                              setState(() {
                                isShowOrchidInfo = !isShowOrchidInfo;
                              });
                            },
                          ),
                        ],
                      ),
                      Visibility(
                        child: Text(
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec euismod, nisl sed aliquet ultricies, nunc nisl ultricies nunc, quis aliquam nisl nisl eu nisl. Donec euismod, nisl sed aliquet ultricies, nunc nisl ultricies nunc, quis aliquam nisl nisl eu nisl. Donec euismod, nisl sed aliquet ultricies, nunc nisl ultricies nunc, quis aliquam nisl nisl eu nisl. Donec euismod, nisl sed aliquet ultricies, nunc nisl ultricies nunc, quis aliquam nisl nisl eu nisl. Donec euismod, nisl sed aliquet ultricies, nunc nisl ultricies nunc, quis aliquam nisl nisl eu nisl. Donec euismod, nisl sed aliquet ultricies, nunc nisl ultricies nunc, quis aliquam nisl nisl eu nisl. Donec euismod, nisl sed aliquet ultricies, nunc nisl ultricies nunc, quis aliquam nisl nisl eu nisl."),
                        visible: isShowOrchidInfo,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "THÔNG TIN ĐẤU GIÁ",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: isShowAuctionInfo
                                ? Icon(Icons.keyboard_arrow_up)
                                : Icon(Icons.keyboard_arrow_down),
                            onPressed: () {
                              setState(() {
                                isShowAuctionInfo = !isShowAuctionInfo;
                              });
                            },
                          ),
                        ],
                      ),
                      Visibility(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Colors.white,
                                  ),
                                  child: Icon(
                                    Icons.people_alt_outlined,
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      color: Colors.white,
                                    ),
                                    child: Text(
                                      "12 người đã tham gia đấu giá",
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Colors.white,
                                  ),
                                  child: Icon(
                                    Icons.call_made_outlined,
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          "bước nhảy nhỏ nhất: ",
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                        Text(
                                          "50.000 VND",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Colors.white,
                                  ),
                                  child: Icon(
                                    Icons.campaign_outlined,
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          "giá đấu hiện tại: ",
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                        Text(
                                          "250.000 VND",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        visible: isShowAuctionInfo,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          Positioned(
            top: 430,
            left: 10,
            right: 10,
            child: Container(
              padding: EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width,
              height: 110,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
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
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              "100.000 VND",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 25.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "Giá khởi điểm",
                              style: TextStyle(
                                color: const Color.fromARGB(194, 0, 0, 0),
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 1,
                        color: Colors.black,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              "500.000 VND",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 25.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "Giá cao nhất",
                              style: TextStyle(
                                color: const Color.fromARGB(194, 0, 0, 0),
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.timer_sharp),
                                Text(
                                  " 17 ngày 8 giờ",
                                  style: TextStyle(
                                    color: const Color.fromARGB(194, 0, 0, 0),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

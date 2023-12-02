import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/screens/auction/screen/auction_detail_screen.dart';

class AutionScreen extends StatefulWidget {
  @override
  _AutionScreenState createState() => _AutionScreenState();
}

String heroTag1 =
    "https://cdn.tgdd.vn/Files/2021/07/24/1370576/hoa-lan-tim-dac-diem-y-nghia-va-cach-trong-hoa-no-dep-202107242028075526.jpg";
String heroTag2 =
    "https://cdn.tgdd.vn/Files/2021/07/23/1370384/cach-nhan-biet-cac-loai-phong-lan-va-ky-thuat-trong-phu-hop-cho-tung-loai-202107232038443447.jpg";
String heroTag3 =
    "https://vuanem.com/blog/wp-content/uploads/2022/11/y-nghia-hoa-phong-lan.jpg";
String heroTag4 = "https://hoatuoithanhthao.com/media/ftp/hoa-lan-3.jpg";
String heroTag5 =
    "https://dienhoaxanh.com/wp-content/uploads/2021/09/y-nghia-hoa-lan-do.jpg";

class _AutionScreenState extends State<AutionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 50.0, right: 20.0, left: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 200.0,
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 200.0,
                      autoPlay: true,
                    ),
                    items: [
                      auctionWidget(heroTag1, true),
                      auctionWidget(heroTag2, true),
                      auctionWidget(heroTag3, true),
                      auctionWidget(heroTag4, true),
                      auctionWidget(heroTag5, true),
                    ].map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(color: Colors.amber),
                              child: i);
                        },
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: Text(
                    "Có thể bạn sẽ thích",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  height: 250.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: auctionWidget2(heroTag1)),
                      Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: auctionWidget2(heroTag2)),
                      Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: auctionWidget2(heroTag3)),
                      Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: auctionWidget2(heroTag4)),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Nhiều hơn",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: auctionWidget3(heroTag1),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: auctionWidget3(heroTag2),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: auctionWidget3(heroTag3),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: auctionWidget3(heroTag4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String heroTag1 =
      "https://cdn.tgdd.vn/Files/2021/07/24/1370576/hoa-lan-tim-dac-diem-y-nghia-va-cach-trong-hoa-no-dep-202107242028075526.jpg";
  String heroTag2 =
      "https://cdn.tgdd.vn/Files/2021/07/23/1370384/cach-nhan-biet-cac-loai-phong-lan-va-ky-thuat-trong-phu-hop-cho-tung-loai-202107232038443447.jpg";
  String heroTag3 =
      "https://vuanem.com/blog/wp-content/uploads/2022/11/y-nghia-hoa-phong-lan.jpg";
  String heroTag4 = "https://hoatuoithanhthao.com/media/ftp/hoa-lan-3.jpg";
  String heroTag5 =
      "https://dienhoaxanh.com/wp-content/uploads/2021/09/y-nghia-hoa-lan-do.jpg";
  Widget auctionWidget(String heroTag, bool isDisplay) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return AcutionDetailSceen();
            },
          ),
        );
      },
      child: Hero(
        tag: heroTag,
        child: Container(
          height: isDisplay ? 250.0 : 100.0,
          width: isDisplay ? 400.0 : 150.0,
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(heroTag),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (isDisplay)
                Positioned(
                  bottom: 20,
                  left: 13,
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(138, 255, 255, 255),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Hoa lan đột biến",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.monetization_on_outlined,
                              color: Colors.black,
                            ),
                            Text(
                              "Giá khởi điểm: 100.000đ",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget auctionWidget2(String heroTag) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return AcutionDetailSceen();
            },
          ),
        );
      },
      child: Hero(
        tag: heroTag,
        child: Container(
          height: 150.0,
          child: Column(
            children: [
              Container(
                height: 150.0,
                width: 150.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(heroTag),
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
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                ),
                padding: EdgeInsets.all(10.0),
                height: 85.0,
                width: 150.0,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Hoa lan đột biến",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 15.0,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Giá khởi điểm: ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10.0,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.monetization_on_outlined,
                          color: Colors.black,
                          size: 15.0,
                        ),
                        Text(
                          '100.000đ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: Colors.black,
                          size: 12.0,
                        ),
                        Text(
                          ' 8 đã tham gia đấu giá',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10.0,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget auctionWidget3(String heroTag) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return AcutionDetailSceen();
            },
          ),
        );
      },
      child: Hero(
        tag: heroTag,
        child: Container(
          height: 100.0,
          child: Row(
            children: [
              Container(
                height: 100.0,
                width: 100.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(heroTag),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                ),
                padding: EdgeInsets.all(10.0),
                height: 100.0,
                width: MediaQuery.of(context).size.width - 142,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Hoa lan đột biến",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 15.0,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Giá khởi điểm: ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10.0,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.monetization_on_outlined,
                          color: Colors.black,
                          size: 15.0,
                        ),
                        Text(
                          '100.000đ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: Colors.black,
                          size: 12.0,
                        ),
                        Text(
                          ' 8 đã tham gia đấu giá',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10.0,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

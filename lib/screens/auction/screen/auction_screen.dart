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
                      auctionWidget(heroTag1),
                      auctionWidget(heroTag2),
                      auctionWidget(heroTag3),
                      auctionWidget(heroTag4),
                      auctionWidget(heroTag5),
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
                  )),
            ],
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
  Widget auctionWidget(String heroTag) {
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
          height: 250.0,
          width: 400.0,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}

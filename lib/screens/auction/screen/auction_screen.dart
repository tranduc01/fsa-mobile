import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/screens/auction/screen/auction_detail_screen.dart';

class AutionScreen extends StatefulWidget {
  @override
  _AutionScreenState createState() => _AutionScreenState();
}

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Tuanbe",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.purple,
                      image: DecorationImage(
                        image: NetworkImage(
                            "https://scontent.fsgn5-9.fna.fbcdn.net/v/t1.6435-9/195462539_2596085170685401_8094832095637303646_n.jpg?_nc_cat=102&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=0Rf2T1o-ABkAX8RfomW&_nc_ht=scontent.fsgn5-9.fna&_nc_e2o=f&oh=00_AfA17CvntVIHB2zD8nsa6ig6sZX7l-oQEhjVaqPqnWAyeQ&oe=65424A6C"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                ],
              ),
              Text(
                'Đấu giá lan',
                style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                "Gần đây",
                style: TextStyle(
                  color: black,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.5),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                        ),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: "Tìm kiếm hoa bạn muốn đấu giá",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Stack(
                    children: <Widget>[
                      Icon(Icons.notifications_none),
                      Positioned(
                        top: -1,
                        right: 1,
                        child: Container(
                          padding: EdgeInsets.all(2.0),
                          child: Text(
                            "2",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.0,
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                height: 400.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    auctionWidget("auction1"),
                    auctionWidget("auction2"),
                    auctionWidget("auction3"),
                    auctionWidget("auction4"),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

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
          padding: EdgeInsets.only(top: 10.0),
          width: 250.0,
          height: 400.0,
          child: Stack(
            children: <Widget>[
              Container(
                width: 230.0,
                height: 375.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(
                        "https://hoatuoithanhthao.com/media/ftp/hoa-lan-5.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 1,
                right: 15,
                child: FloatingActionButton(
                  heroTag: null,
                  mini: true,
                  backgroundColor: Colors.orange,
                  child: Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                  ),
                  onPressed: () => print("next"),
                ),
              ),
              Positioned(
                bottom: 60,
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

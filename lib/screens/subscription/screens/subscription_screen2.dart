import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialv/screens/stats/daily_json.dart';

class SubscriptionScreen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Student Assistsant Subscription",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StudentAssistantSubscription(),
    );
  }
}

class StudentAssistantSubscription extends StatefulWidget {
  @override
  _StudentAssistantSubscription createState() =>
      _StudentAssistantSubscription();
}

class _StudentAssistantSubscription
    extends State<StudentAssistantSubscription> {
  List expenses = [
    {
      "icon": Icons.arrow_back,
      "color": Colors.blue,
      "label": "Gói 50.000",
      "cost": "50.000 VNĐ",
      "image": "assets/images/hot-deal.png"
    },
    {
      "icon": Icons.arrow_forward,
      "color": Colors.red,
      "label": "Gói 100.000",
      "cost": "100.000 VNĐ",
      "image": "assets/images/hot-deal.png"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "Subscriptions",
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontFamily: "Roboto"),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              height: 100,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment(0.8, 1),
                  colors: <Color>[
                    Color(0xFFfdeff9),
                    Color(0xFFec38bc),
                    Color(0xFF7303c0),
                    Color(0xFF03001e),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 10),
                    child: Text(
                      "Your Points",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Roboto",
                        fontSize: 30,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 10),
                    child: Text(
                      "100.000",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Roboto",
                        fontSize: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Wrap(
              spacing: 20,
              children: List.generate(
                expenses.length,
                (index) {
                  return Container(
                    width: (MediaQuery.of(context).size.width - 60) / 2,
                    height: 180,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment(0.8, 1),
                        colors: <Color>[
                          Color(0xFFf6d5f7),
                          Color(0xFFfbe9d7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.01),
                          spreadRadius: 10,
                          blurRadius: 3,
                          // changes position of shadow
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 25, right: 25, top: 20, bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: Center(
                              child: Image.asset(
                                expenses[index]['image'],
                                width: 200,
                                height: 200,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                expenses[index]['label'],
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: Color(0xff67727d),
                                    fontFamily: "Roboto"),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                expenses[index]['cost'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  fontFamily: "Roboto",
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                  children: List.generate(daily.length, (index) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: (MediaQuery.of(context).size.width - 70) * 0.7,
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey.withOpacity(0.1),
                                ),
                                child: Center(
                                  child: Image.asset(
                                    daily[index]['icon'],
                                    width: 30,
                                    height: 30,
                                  ),
                                ),
                              ),
                              SizedBox(width: 15),
                              Container(
                                width:
                                    (MediaQuery.of(context).size.width - 90) *
                                        0.5,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      daily[index]['name'],
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Roboto",
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      daily[index]['date'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black.withOpacity(0.5),
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "Roboto",
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: (MediaQuery.of(context).size.width - 40) * 0.3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                daily[index]['price'],
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Colors.green,
                                  fontFamily: "Roboto",
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 65, top: 8),
                      child: Divider(
                        thickness: 0.8,
                      ),
                    )
                  ],
                );
              })),
            ),
          ],
        ),
      ),
    );
  }
}

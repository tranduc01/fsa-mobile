import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/common_models.dart';

class RankingBottomSheetWidget extends StatefulWidget {
  final VoidCallback? callback;

  RankingBottomSheetWidget({this.callback});

  @override
  State<RankingBottomSheetWidget> createState() => _RankingWidgetState();
}

class _RankingWidgetState extends State<RankingBottomSheetWidget> {
  List<DrawerModel> options = getDrawerOptions();

  int selectedIndex = -1;
  bool isLoading = false;
  bool backToHome = true;
  String selectedDropdown = 'Today';

  @override
  void initState() {
    super.initState();
    if (appStore.isLoading) {
      isLoading = true;
      appStore.setLoading(false);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    if (isLoading && backToHome) widget.callback?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            width: SizeConfig.screenHeight,
            height: 220,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment(0.8, 1),
              colors: <Color>[
                Color(0xFFEF6DA0),
                Color(0xFFEE8E6B),
              ],
            )),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Expertise Rating',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto',
                            ),
                          ),
                          DropdownButton<String>(
                            value: selectedDropdown,
                            onChanged: (String? value) {
                              setState(() {
                                selectedDropdown = value!;
                              });
                            },
                            items: <String>['Today', 'Week', 'Month', 'Year']
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto',
                            ),
                            dropdownColor: Color.fromARGB(234, 255, 255, 255),
                            underline: Container(),
                            borderRadius: BorderRadius.circular(10),
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                            ),
                          )
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'You',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto',
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromARGB(71, 255, 255, 255),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/icons/reward.png',
                                        height: 30,
                                        width: 30,
                                      ),
                                      SizedBox(
                                        width: 25,
                                      ),
                                      Text(
                                        '100',
                                        style: TextStyle(
                                          fontSize: 24,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Roboto',
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/icons/winner.png',
                                        height: 30,
                                        width: 30,
                                      ),
                                      SizedBox(
                                        width: 25,
                                      ),
                                      Text(
                                        '111',
                                        style: TextStyle(
                                          fontSize: 24,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Roboto',
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        TabBar(
                          labelColor: Colors.black,
                          unselectedLabelColor:
                              const Color.fromARGB(255, 105, 104, 104),
                          labelStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                          ),
                          tabs: [
                            Tab(text: 'Tab 1'),
                            Tab(text: 'Tab 2'),
                            Tab(text: 'Tab 3'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          children: [
                            SingleChildScrollView(
                              child: Column(children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Image.asset(
                                        "assets/icons/gold.png",
                                        height: 40,
                                        width: 40,
                                      ),
                                    ),
                                    Spacer(),
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      child: Image.network(
                                        "https://picsum.photos/250?image=9",
                                        height: 40,
                                        width: 40,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Flexible(
                                      child: Text(
                                        'Tran Duc',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ),
                                    Spacer(),
                                    Flexible(
                                      child: Text(
                                        '99999',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Image.asset(
                                        "assets/icons/silver.png",
                                        height: 40,
                                        width: 40,
                                      ),
                                    ),
                                    Spacer(),
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      child: Image.network(
                                        "https://picsum.photos/250?image=9",
                                        height: 40,
                                        width: 40,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Flexible(
                                      child: Text(
                                        'Tran Duc Duc Duc Duc Duc ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ),
                                    Spacer(),
                                    Flexible(
                                      child: Text(
                                        '6',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Image.asset(
                                        "assets/icons/bronze.png",
                                        height: 40,
                                        width: 40,
                                      ),
                                    ),
                                    Spacer(),
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      child: Image.network(
                                        "https://picsum.photos/250?image=9",
                                        height: 40,
                                        width: 40,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Flexible(
                                      child: Text(
                                        'Tran Duc',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ),
                                    Spacer(),
                                    Flexible(
                                      child: Text(
                                        '6666',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '4',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30,
                                            color: const Color.fromARGB(
                                                127, 0, 0, 0)),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Spacer(),
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      child: Image.network(
                                        "https://picsum.photos/250?image=9",
                                        height: 40,
                                        width: 40,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Flexible(
                                      child: Text(
                                        'Tran Duc',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ),
                                    Spacer(),
                                    Flexible(
                                      child: Text(
                                        '99999',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    )
                                  ],
                                ),
                              ]),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          children: [Text('Tab 2'), Text('2'), Text('2')],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          children: [Text('Tab 3'), Text('3'), Text('3')],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

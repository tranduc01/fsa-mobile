import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/utils/app_constants.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletState();
}

class _WalletState extends State<WalletScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  TextEditingController amountController = TextEditingController();
  TextEditingController moneyController = TextEditingController();
  @override
  void initState() {
    _animationController = BottomSheet.createAnimationController(this);
    _animationController.duration = const Duration(milliseconds: 500);
    _animationController.drive(CurveTween(curve: Curves.easeOutQuad));
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.scaffoldBackgroundColor,
        title: Text('My Wallet', style: boldTextStyle(size: 20)),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.25,
                decoration: BoxDecoration(
                    borderRadius: radius(20),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                        Color(0xFFa18cd1),
                        Color(0xFFfbc2eb),
                      ],
                    )),
                child: Column(children: [
                  30.height,
                  Text(
                    'My Balance',
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(92, 0, 0, 0)),
                  ),
                  5.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.token_outlined,
                        size: 30,
                      ),
                      Text(
                        '120000',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 27,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  5.height,
                  Text(
                    'Points',
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(141, 0, 0, 0)),
                  ),
                  30.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.all(8)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          side: MaterialStateProperty.all(
                            BorderSide(
                                color: const Color.fromARGB(129, 0, 0, 0),
                                width: 2),
                          ),
                        ),
                        onPressed: () {},
                        child: Row(
                          children: [
                            Image.asset(
                              ic_wallet_in,
                              width: 40,
                              height: 40,
                            ),
                            10.width,
                            Text(
                              'Top Up',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto'),
                            )
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.all(8)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          side: MaterialStateProperty.all(
                            BorderSide(
                                color: const Color.fromARGB(129, 0, 0, 0),
                                width: 2),
                          ),
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            elevation: 0,
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            transitionAnimationController: _animationController,
                            builder: (context) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: FractionallySizedBox(
                                  heightFactor: 0.5,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 45,
                                        height: 5,
                                        //clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            color: Colors.white),
                                      ),
                                      8.height,
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        decoration: BoxDecoration(
                                          color: context.cardColor,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(16),
                                              topRight: Radius.circular(16)),
                                        ),
                                        child: PopScope(
                                          onPopInvoked: (didPop) {
                                            if (didPop) {
                                              amountController.clear();
                                              moneyController.clear();
                                            }
                                          },
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                Text(
                                                  'Withdraw Request',
                                                  style: TextStyle(
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Roboto'),
                                                ),
                                                20.height,
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    'Enter Points',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily: 'Roboto'),
                                                  ),
                                                ),
                                                10.height,
                                                TextFormField(
                                                  controller: amountController,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        width: 3,
                                                        color:
                                                            Color(0xFFB4D4FF),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50.0),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        width: 3,
                                                        color:
                                                            Color(0xFFB4D4FF),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50.0),
                                                    ),
                                                    suffixIcon: Icon(
                                                      Icons.token_outlined,
                                                      color: Colors.black,
                                                      size: 30,
                                                    ),
                                                  ),
                                                  onChanged: (value) {
                                                    if (value.isNotEmpty) {
                                                      moneyController
                                                          .text = (int.parse(
                                                                  value) *
                                                              1000)
                                                          .toString()
                                                          .formatNumberWithComma();
                                                      setState(() {});
                                                    } else {
                                                      moneyController.text = '';
                                                      setState(() {});
                                                    }
                                                  },
                                                ),
                                                20.height,
                                                Icon(
                                                  Icons.arrow_downward,
                                                  size: 30,
                                                ),
                                                20.height,
                                                TextFormField(
                                                  controller: moneyController,
                                                  readOnly: true,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        width: 3,
                                                        color:
                                                            Color(0xFFB4D4FF),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50.0),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        width: 3,
                                                        color:
                                                            Color(0xFFB4D4FF),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50.0),
                                                    ),
                                                    suffixIcon: Icon(
                                                      Icons
                                                          .currency_exchange_outlined,
                                                      color: Colors.black,
                                                      size: 30,
                                                    ),
                                                  ),
                                                ),
                                                30.height,
                                                appButton(
                                                    text:
                                                        'Create Withdraw Request',
                                                    context: context,
                                                    onTap: () {
                                                      showConfirmDialogCustom(
                                                        context,
                                                        title: 'Are you sure you want to withdraw from ' +
                                                            amountController
                                                                .text
                                                                .formatNumberWithComma() +
                                                            ' points to ' +
                                                            moneyController.text
                                                                .formatNumberWithComma() +
                                                            ' ?',
                                                        onAccept: (p0) {
                                                          toast('Withdraw');
                                                        },
                                                      );
                                                    })
                                              ],
                                            ),
                                          ),
                                        ),
                                      ).expand(),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Row(
                          children: [
                            Image.asset(
                              ic_wallet_out,
                              width: 40,
                              height: 40,
                            ),
                            10.width,
                            Text(
                              'Withdraw',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto'),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ]),
              ),
              DefaultTabController(
                length: 5,
                child: Column(
                  children: [
                    Container(
                      child: TabBar(
                        labelColor: Colors.black,
                        unselectedLabelColor:
                            Color.fromARGB(171, 105, 104, 104),
                        labelStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                        ),
                        isScrollable: true,
                        physics: BouncingScrollPhysics(),
                        indicator: BoxDecoration(),
                        tabs: [
                          Tab(
                              child: Text(
                            'All',
                          )),
                          Tab(
                            child: Text(
                              'Deposit',
                            ),
                          ),
                          Tab(
                              child: Text(
                            'Withdraw',
                          )),
                          Tab(
                              child: Text(
                            'Earned',
                          )),
                          Tab(
                              child: Text(
                            'Used',
                          )),
                        ],
                        onTap: (index) {
                          int? status;
                          switch (index) {
                            case 0:
                              status = null;
                              break;
                            case 1:
                              status = 0;
                              break;
                            case 2:
                              status = 1;
                              break;
                            case 3:
                              status = 3;
                              break;
                            default:
                              status = 0;
                          }
                          //auctionController.fetchAuctions(status);
                        },
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height,
                      child: TabBarView(children: [
                        historyWidget(),
                        historyWidget(),
                        historyWidget(),
                        historyWidget(),
                        historyWidget(),
                      ]),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget historyWidget() {
    return AnimatedListView(
      padding: EdgeInsets.only(bottom: 400),
      itemCount: 10,
      physics: BouncingScrollPhysics(),
      slideConfiguration: SlideConfiguration(
          delay: Duration(milliseconds: 80), verticalOffset: 300),
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  (index % 2 == 0)
                      ? Image.asset(
                          ic_receive_money,
                          width: 80,
                          height: 80,
                        )
                      : Image.asset(
                          ic_send_money,
                          width: 80,
                          height: 80,
                        ),
                  12.width,
                  Expanded(
                    child: Container(
                      height: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(
                                'title',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                textAlign: TextAlign.start,
                                style: boldTextStyle(
                                    fontFamily: 'Roboto', size: 18),
                              ),
                              10.width,
                              Container(
                                decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(118, 76, 175, 79),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: Color.fromARGB(24, 0, 0, 0))),
                                padding: EdgeInsets.all(3),
                                child: Text(
                                  'Status',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Roboto',
                                      color: Color.fromARGB(255, 0, 0, 0)),
                                ),
                              )
                            ],
                          ),
                          10.height,
                          Flexible(
                            child: Text(
                              DateFormat('dd/MM/yyyy hh:mm:ss a')
                                  .format(DateTime.now()),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textAlign: TextAlign.start,
                              style: boldTextStyle(
                                size: 15,
                                fontFamily: 'Roboto',
                                color: Color.fromARGB(118, 0, 0, 0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  (index % 2 == 0)
                      ? Column(
                          children: [
                            Text('+ 120.000',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                    fontFamily: 'Roboto')),
                            Text('50.000 VNĐ',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: const Color.fromARGB(120, 0, 0, 0),
                                    fontFamily: 'Roboto')),
                          ],
                        )
                      : Column(
                          children: [
                            Text('- 120.000',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                    fontFamily: 'Roboto')),
                            Text('50.000 VNĐ',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: const Color.fromARGB(120, 0, 0, 0),
                                    fontFamily: 'Roboto')),
                          ],
                        ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:socialv/main.dart';
import 'package:socialv/screens/auction/screen/bid_screen.dart';
import 'package:socialv/screens/post/screens/image_screen.dart';
import 'package:socialv/utils/html_widget.dart';

import '../../../components/loading_widget.dart';
import '../../../controllers/auction_controller.dart';
import '../../../utils/images.dart';

class AuctionDetailSceen extends StatefulWidget {
  final int id;
  const AuctionDetailSceen({Key? key, required this.id}) : super(key: key);
  @override
  _AuctionDetailSceenState createState() => _AuctionDetailSceenState();
}

class _AuctionDetailSceenState extends State<AuctionDetailSceen>
    with TickerProviderStateMixin {
  bool isShowOrchidInfo = false;
  bool isShowAuctionInfo = false;
  final storage = new FlutterSecureStorage();
  late AnimationController _animationController;
  late AuctionController auctionController = Get.put(AuctionController());

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await auctionController.fetchAuction(widget.id);
    });

    onHandle();

    _animationController = BottomSheet.createAnimationController(this);
    _animationController.duration = const Duration(milliseconds: 500);
    _animationController.drive(CurveTween(curve: Curves.easeOutQuad));
    super.initState();
  }

  Future<void> onHandle() async {
    var token = await storage.read(key: 'jwt');

    final hubConnection = HubConnectionBuilder()
        .withUrl('https://api.chiasekienthucphonglan.io.vn/hubs/auction',
            options: HttpConnectionOptions(
                accessTokenFactory: () => Future.value(token)))
        .build();

    hubConnection.on('BidAuction', (arguments) {
      arguments!.forEach((element) {
        auctionController.auction.value.currentBidPrice =
            element['bidAmount'] != null ? element['bidAmount'].toDouble() : 0;
        setState(() {});
      });
    });

    await hubConnection.start();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    return Obx(
      () => Scaffold(
        floatingActionButton: Align(
          alignment: Alignment.bottomCenter,
          child: FloatingActionButton.extended(
            label: Text(
                auctionController.auction.value.currentBidPrice!
                    .toStringAsFixed(0)
                    .formatNumberWithComma(),
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
            icon: Image.asset(
              ic_auction,
              height: 30,
              width: 30,
              color: Colors.black,
            ),
            backgroundColor: Colors.white,
            onPressed: () {
              showModalBottomSheet(
                elevation: 0,
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                transitionAnimationController: _animationController,
                builder: (context) {
                  return FractionallySizedBox(
                    heightFactor: 0.7,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 45,
                          height: 5,
                          //clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white),
                        ),
                        8.height,
                        Container(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: BoxDecoration(
                            color: context.cardColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16)),
                          ),
                          child: BidScreen(auctionId: widget.id),
                        ).expand(),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: screenHeight * 0.535,
                      child: auctionController.auction.value.thumbnail != null
                          ? Image.network(
                              auctionController.auction.value.thumbnail!,
                              fit: BoxFit.cover,
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                return Image.asset(
                                  'assets/images/images.png',
                                  fit: BoxFit.cover,
                                );
                              },
                            )
                          : Image.asset('assets/images/images.png',
                              fit: BoxFit.cover),
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
                        ),
                        // Back button
                        Positioned(
                          top: screenHeight * 0.05,
                          left: 5,
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.arrow_back),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              Text(
                                language.auctionDetail,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
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
                  height: screenHeight * 0.465,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        DefaultTabController(
                          length: 3,
                          child: Column(
                            children: [
                              TabBar(
                                tabs: [
                                  Tab(
                                    child: DefaultTextStyle(
                                      child: Text(
                                        language.auctionImage +
                                            '(${auctionController.auction.value.orchid!.medias!.length})',
                                        style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.bold),
                                      ),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontFamily: 'Roboto'),
                                    ),
                                  ),
                                  Tab(
                                    child: DefaultTextStyle(
                                      child: Text(
                                        language.auctionInfomation,
                                        style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.bold),
                                      ),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontFamily: 'Roboto'),
                                    ),
                                  ),
                                  Tab(
                                    child: DefaultTextStyle(
                                      child: Text(language.auctionOrchid),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Roboto',
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                height:
                                    330, // specify the height of the container
                                child: TabBarView(
                                  children: [
                                    Container(
                                      height: 330,
                                      child: MasonryGridView.builder(
                                        itemCount: auctionController.auction
                                            .value.orchid!.medias!.length,
                                        gridDelegate:
                                            const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                        ),
                                        itemBuilder: (context, index) =>
                                            Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: GestureDetector(
                                            child: Image.network(
                                              auctionController.auction.value
                                                  .orchid!.medias![index].url!,
                                              fit: BoxFit.fill,
                                            ).cornerRadiusWithClipRRect(20),
                                            onTap: () => ImageScreen(
                                                    imageURl: auctionController
                                                        .auction
                                                        .value
                                                        .orchid!
                                                        .medias![index]
                                                        .url!)
                                                .launch(context),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 330,
                                      child: SingleChildScrollView(
                                          child: Column(
                                        children: [
                                          HtmlWidget(
                                            postContent: auctionController
                                                .auction.value.description,
                                          )
                                        ],
                                      )),
                                    ),
                                    Container(
                                      height: 350,
                                      child: SingleChildScrollView(
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              10.height,
                                              Text(
                                                auctionController.auction.value
                                                    .orchid!.name!,
                                                style: TextStyle(
                                                    fontSize: 30,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Roboto'),
                                              ),
                                              15.height,
                                              Text(
                                                auctionController.auction.value
                                                    .orchid!.description!,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromARGB(
                                                        134, 0, 0, 0),
                                                    fontFamily: 'Roboto'),
                                              ),
                                              25.height,
                                              Align(
                                                alignment: Alignment.center,
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.9,
                                                          height: 80,
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10),
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.5),
                                                                  spreadRadius:
                                                                      3,
                                                                  blurRadius: 7,
                                                                  offset: Offset(
                                                                      0,
                                                                      3), // changes position of shadow
                                                                ),
                                                              ]),
                                                          child: Row(
                                                            children: [
                                                              Image.asset(
                                                                  ic_botanical,
                                                                  height: 30,
                                                                  width: 30),
                                                              10.width,
                                                              Expanded(
                                                                  child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    language
                                                                        .botanicalName,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontFamily:
                                                                            'Roboto'),
                                                                  ),
                                                                  Flexible(
                                                                    child: Text(
                                                                      auctionController
                                                                          .auction
                                                                          .value
                                                                          .orchid!
                                                                          .botanicalName!,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color: Color.fromARGB(
                                                                              134,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                          fontFamily:
                                                                              'Roboto'),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      maxLines:
                                                                          2,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                    ),
                                                                  )
                                                                ],
                                                              ))
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    20.height,
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.4,
                                                          height: 80,
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10),
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.5),
                                                                  spreadRadius:
                                                                      3,
                                                                  blurRadius: 7,
                                                                  offset: Offset(
                                                                      0,
                                                                      3), // changes position of shadow
                                                                ),
                                                              ]),
                                                          child: Row(
                                                            children: [
                                                              Image.asset(
                                                                  ic_plant,
                                                                  height: 30,
                                                                  width: 30),
                                                              10.width,
                                                              Expanded(
                                                                  child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    language
                                                                        .plantType,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontFamily:
                                                                            'Roboto'),
                                                                  ),
                                                                  Flexible(
                                                                    child: Text(
                                                                      auctionController
                                                                          .auction
                                                                          .value
                                                                          .orchid!
                                                                          .plantType!,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color: Color.fromARGB(
                                                                              134,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                          fontFamily:
                                                                              'Roboto'),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      maxLines:
                                                                          2,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                    ),
                                                                  )
                                                                ],
                                                              ))
                                                            ],
                                                          ),
                                                        ),
                                                        30.width,
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.4,
                                                          height: 80,
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10),
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.5),
                                                                  spreadRadius:
                                                                      3,
                                                                  blurRadius: 7,
                                                                  offset: Offset(
                                                                      0,
                                                                      3), // changes position of shadow
                                                                ),
                                                              ]),
                                                          child: Row(
                                                            children: [
                                                              Image.asset(
                                                                  ic_family,
                                                                  height: 30,
                                                                  width: 30),
                                                              10.width,
                                                              Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      language
                                                                          .family,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontFamily:
                                                                              'Roboto'),
                                                                    ),
                                                                    Flexible(
                                                                      child:
                                                                          Text(
                                                                        auctionController
                                                                            .auction
                                                                            .value
                                                                            .orchid!
                                                                            .family!,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            color: Color.fromARGB(
                                                                                134,
                                                                                0,
                                                                                0,
                                                                                0),
                                                                            fontFamily:
                                                                                'Roboto'),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        maxLines:
                                                                            2,
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    20.height,
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.9,
                                                          height: 80,
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10),
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.5),
                                                                  spreadRadius:
                                                                      3,
                                                                  blurRadius: 7,
                                                                  offset: Offset(
                                                                      0,
                                                                      3), // changes position of shadow
                                                                ),
                                                              ]),
                                                          child: Row(
                                                            children: [
                                                              Image.asset(
                                                                ic_location,
                                                                height: 30,
                                                                width: 30,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                              10.width,
                                                              Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      language
                                                                          .nativeArea,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontFamily:
                                                                              'Roboto'),
                                                                    ),
                                                                    Flexible(
                                                                      child:
                                                                          Text(
                                                                        auctionController
                                                                            .auction
                                                                            .value
                                                                            .orchid!
                                                                            .nativeArea!,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            color: Color.fromARGB(
                                                                                134,
                                                                                0,
                                                                                0,
                                                                                0),
                                                                            fontFamily:
                                                                                'Roboto'),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        maxLines:
                                                                            2,
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    20.height,
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.4,
                                                          height: 80,
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10),
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.5),
                                                                  spreadRadius:
                                                                      3,
                                                                  blurRadius: 7,
                                                                  offset: Offset(
                                                                      0,
                                                                      3), // changes position of shadow
                                                                ),
                                                              ]),
                                                          child: Row(
                                                            children: [
                                                              Image.asset(
                                                                  ic_plant_height,
                                                                  height: 30,
                                                                  width: 30),
                                                              10.width,
                                                              Expanded(
                                                                  child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    language
                                                                        .height,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontFamily:
                                                                            'Roboto'),
                                                                  ),
                                                                  Flexible(
                                                                    child: Text(
                                                                      auctionController
                                                                          .auction
                                                                          .value
                                                                          .orchid!
                                                                          .height!,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color: Color.fromARGB(
                                                                              134,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                          fontFamily:
                                                                              'Roboto'),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      maxLines:
                                                                          2,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                    ),
                                                                  )
                                                                ],
                                                              ))
                                                            ],
                                                          ),
                                                        ),
                                                        30.width,
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.4,
                                                          height: 80,
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10),
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.5),
                                                                  spreadRadius:
                                                                      3,
                                                                  blurRadius: 7,
                                                                  offset: Offset(
                                                                      0,
                                                                      3), // changes position of shadow
                                                                ),
                                                              ]),
                                                          child: Row(
                                                            children: [
                                                              Image.asset(
                                                                ic_sun,
                                                                height: 30,
                                                                width: 30,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                              10.width,
                                                              Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      language
                                                                          .sunExposure,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontFamily:
                                                                              'Roboto'),
                                                                    ),
                                                                    Flexible(
                                                                      child:
                                                                          Text(
                                                                        auctionController
                                                                            .auction
                                                                            .value
                                                                            .orchid!
                                                                            .sunExposure!,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            color: Color.fromARGB(
                                                                                134,
                                                                                0,
                                                                                0,
                                                                                0),
                                                                            fontFamily:
                                                                                'Roboto'),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        maxLines:
                                                                            2,
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Positioned(
              top: screenHeight * 0.24,
              left: 10,
              right: 10,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: IntrinsicWidth(
                      child: RawMaterialButton(
                        fillColor: Colors.white,
                        onPressed: () {
                          showModalBottomSheet(
                            elevation: 0,
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            transitionAnimationController: _animationController,
                            builder: (context) {
                              return FractionallySizedBox(
                                heightFactor: 0.7,
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
                                      width: MediaQuery.of(context).size.width,
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.all(10),
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      decoration: BoxDecoration(
                                        color: context.cardColor,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(16),
                                            topRight: Radius.circular(16)),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            "Số người tham gia: 0",
                                            style: TextStyle(
                                                fontFamily: "Roboto",
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                          Container(
                                            child:
                                                Column(children: [Container()]),
                                          )
                                        ],
                                      ),
                                    ).expand(),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.group_outlined,
                                  color: Colors.black,
                                  size: 20,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "Số người tham gia: 0",
                                  style: TextStyle(
                                    fontFamily: "Roboto",
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      top: 10.0,
                      left: 20.0,
                      right: 20.0,
                      bottom: 9.0,
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: 190,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TimerCountdown(
                              format:
                                  CountDownTimerFormat.daysHoursMinutesSeconds,
                              endTime: DateTime.parse(auctionController
                                      .auction.value.startDate!
                                      .add(Duration(hours: 7))
                                      .isBefore(DateTime.now())
                                  ? auctionController.auction.value.endDate!
                                      .add(Duration(hours: 7))
                                      .toString()
                                  : auctionController.auction.value.startDate!
                                      .add(Duration(hours: 7))
                                      .toString()),
                              timeTextStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',
                              ),
                              colonsTextStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',
                              ),
                              descriptionTextStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                                fontFamily: 'Roboto',
                              ),
                              daysDescription: language.auctionDays,
                              hoursDescription: language.auctionHours,
                              minutesDescription: language.auctionMinutes,
                              secondsDescription: language.auctionSeconds,
                              spacerWidth: 5,
                              onEnd: () {
                                print("Timer finished");
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                auctionController.auction.value.title!,
                                style: TextStyle(
                                    color: const Color.fromARGB(194, 0, 0, 0),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                    fontFamily: 'Roboto'),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        auctionController
                                            .auction.value.reservePrice!
                                            .toStringAsFixed(0)
                                            .formatNumberWithComma(),
                                        style: TextStyle(
                                          color: const Color.fromARGB(
                                              194, 0, 0, 0),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0,
                                          fontFamily: 'Roboto',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        language.auctionStartPrice,
                                        style: secondaryTextStyle(
                                          color: const Color.fromARGB(
                                              194, 0, 0, 0),
                                          fontFamily: 'Roboto',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        auctionController
                                            .auction.value.soldDirectlyPrice!
                                            .toStringAsFixed(0)
                                            .formatNumberWithComma(),
                                        style: TextStyle(
                                          color: const Color.fromARGB(
                                              194, 0, 0, 0),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0,
                                          fontFamily: 'Roboto',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        language.auctionSoldDirectlyPrices,
                                        style: secondaryTextStyle(
                                          color: const Color.fromARGB(
                                              194, 0, 0, 0),
                                          fontFamily: 'Roboto',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        auctionController
                                            .auction.value.stepPrice!
                                            .toStringAsFixed(0)
                                            .formatNumberWithComma(),
                                        style: TextStyle(
                                          color: const Color.fromARGB(
                                              194, 0, 0, 0),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0,
                                          fontFamily: 'Roboto',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        language.auctionStepPrice,
                                        style: secondaryTextStyle(
                                          color: const Color.fromARGB(
                                              194, 0, 0, 0),
                                          fontFamily: 'Roboto',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ],
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
            Positioned(
              child: LoadingWidget()
                  .center()
                  .visible(auctionController.isLoading.value),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/utils/app_constants.dart';

import '../../controllers/orchid_controller.dart';
import '../post/screens/image_screen.dart';

class SingleOrchidScreen extends StatefulWidget {
  final int orchidId;

  const SingleOrchidScreen({required this.orchidId});

  @override
  State<SingleOrchidScreen> createState() => _SingleOrchidScreenState();
}

class _SingleOrchidScreenState extends State<SingleOrchidScreen> {
  PageController pageController = PageController();
  late OrchidController orchidController = Get.put(OrchidController());
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await orchidController.fetchOrchid(widget.orchidId);
    });

    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => orchidController.isLoading.value
            ? LoadingWidget()
            : NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      title: Text(
                        'Orchid Detail',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      leading: IconButton(
                        color: Colors.white,
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      backgroundColor: Colors.transparent,
                      expandedHeight: MediaQuery.of(context).size.height * 0.5,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                          background: Stack(
                        children: [
                          Positioned.fill(
                            child:
                                orchidController.orchid.value.medias!.length > 1
                                    ? Column(
                                        children: [
                                          Expanded(
                                            child: CarouselSlider(
                                              items:
                                                  orchidController
                                                      .orchid.value.medias!
                                                      .map(
                                                          (item) =>
                                                              GestureDetector(
                                                                onTap: () => ImageScreen(
                                                                        imageURl: item
                                                                            .url
                                                                            .validate())
                                                                    .launch(
                                                                        context),
                                                                child:
                                                                    Container(
                                                                  child: Stack(
                                                                    children: [
                                                                      item.url !=
                                                                              null
                                                                          ? Image
                                                                              .network(
                                                                              item.url!,
                                                                              fit: BoxFit.cover,
                                                                              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                                                return Image.asset(
                                                                                  'assets/images/images.png',
                                                                                  fit: BoxFit.cover,
                                                                                );
                                                                              },
                                                                            )
                                                                          : Image.asset(
                                                                              'assets/images/images.png',
                                                                              fit: BoxFit.cover),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ))
                                                      .toList(),
                                              carouselController: _controller,
                                              options: CarouselOptions(
                                                  autoPlay: true,
                                                  enlargeCenterPage: false,
                                                  aspectRatio: 1,
                                                  onPageChanged:
                                                      (index, reason) {
                                                    setState(() {
                                                      _current = index;
                                                    });
                                                  }),
                                            ),
                                          ),
                                          if (orchidController
                                                  .orchid.value.medias!.length >
                                              1)
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: orchidController
                                                  .orchid.value.medias!
                                                  .asMap()
                                                  .entries
                                                  .map((entry) {
                                                return GestureDetector(
                                                  onTap: () => _controller
                                                      .animateToPage(entry.key),
                                                  child: Container(
                                                    width: 12.0,
                                                    height: 12.0,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8.0,
                                                            horizontal: 4.0),
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: (Theme.of(context)
                                                                        .brightness ==
                                                                    Brightness
                                                                        .dark
                                                                ? Colors.white
                                                                : Colors.black)
                                                            .withOpacity(
                                                                _current ==
                                                                        entry
                                                                            .key
                                                                    ? 0.9
                                                                    : 0.4)),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                        ],
                                      )
                                    : orchidController
                                            .orchid.value.medias!.isNotEmpty
                                        ? GestureDetector(
                                            onTap: () => ImageScreen(
                                                    imageURl: orchidController
                                                        .orchid
                                                        .value
                                                        .medias![0]
                                                        .url
                                                        .validate())
                                                .launch(context),
                                            child: Image.network(
                                              orchidController
                                                  .orchid.value.medias![0].url!,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : Image.asset(
                                            'assets/images/images.png',
                                            fit: BoxFit.cover,
                                          ),
                          ),
                        ],
                      )),
                    ),
                  ];
                },
                body: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        10.height,
                        Text(
                          orchidController.orchid.value.name!,
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto'),
                        ),
                        15.height,
                        Text(
                          orchidController.orchid.value.description!,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(134, 0, 0, 0),
                              fontFamily: 'Roboto'),
                        ),
                        25.height,
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    height: 80,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 3,
                                            blurRadius: 7,
                                            offset: Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ]),
                                    child: Row(
                                      children: [
                                        Image.asset(ic_botanical,
                                            height: 30, width: 30),
                                        10.width,
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Botanical Name',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Roboto'),
                                            ),
                                            Flexible(
                                              child: Text(
                                                orchidController.orchid.value
                                                    .botanicalName!,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromARGB(
                                                        134, 0, 0, 0),
                                                    fontFamily: 'Roboto'),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                textAlign: TextAlign.start,
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    height: 80,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 3,
                                            blurRadius: 7,
                                            offset: Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ]),
                                    child: Row(
                                      children: [
                                        Image.asset(ic_plant,
                                            height: 30, width: 30),
                                        10.width,
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Plant Type',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Roboto'),
                                            ),
                                            Flexible(
                                              child: Text(
                                                orchidController
                                                    .orchid.value.plantType!,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromARGB(
                                                        134, 0, 0, 0),
                                                    fontFamily: 'Roboto'),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                textAlign: TextAlign.start,
                                              ),
                                            )
                                          ],
                                        ))
                                      ],
                                    ),
                                  ),
                                  30.width,
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    height: 80,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 3,
                                            blurRadius: 7,
                                            offset: Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ]),
                                    child: Row(
                                      children: [
                                        Image.asset(ic_family,
                                            height: 30, width: 30),
                                        10.width,
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Family',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Roboto'),
                                              ),
                                              Flexible(
                                                child: Text(
                                                  orchidController
                                                      .orchid.value.family!,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color.fromARGB(
                                                          134, 0, 0, 0),
                                                      fontFamily: 'Roboto'),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  textAlign: TextAlign.start,
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    height: 80,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 3,
                                            blurRadius: 7,
                                            offset: Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ]),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          ic_location,
                                          height: 30,
                                          width: 30,
                                          color: Colors.black,
                                        ),
                                        10.width,
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Native Area',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Roboto'),
                                              ),
                                              Flexible(
                                                child: Text(
                                                  orchidController
                                                      .orchid.value.nativeArea!,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color.fromARGB(
                                                          134, 0, 0, 0),
                                                      fontFamily: 'Roboto'),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  textAlign: TextAlign.start,
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    height: 80,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 3,
                                            blurRadius: 7,
                                            offset: Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ]),
                                    child: Row(
                                      children: [
                                        Image.asset(ic_plant_height,
                                            height: 30, width: 30),
                                        10.width,
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Height',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Roboto'),
                                            ),
                                            Flexible(
                                              child: Text(
                                                orchidController
                                                    .orchid.value.height!,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromARGB(
                                                        134, 0, 0, 0),
                                                    fontFamily: 'Roboto'),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                textAlign: TextAlign.start,
                                              ),
                                            )
                                          ],
                                        ))
                                      ],
                                    ),
                                  ),
                                  30.width,
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    height: 80,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 3,
                                            blurRadius: 7,
                                            offset: Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ]),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          ic_sun,
                                          height: 30,
                                          width: 30,
                                          color: Colors.black,
                                        ),
                                        10.width,
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Sun Exposure',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Roboto'),
                                              ),
                                              Flexible(
                                                child: Text(
                                                  orchidController.orchid.value
                                                      .sunExposure!,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color.fromARGB(
                                                          134, 0, 0, 0),
                                                      fontFamily: 'Roboto'),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  textAlign: TextAlign.start,
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
      ),
    );
  }
}

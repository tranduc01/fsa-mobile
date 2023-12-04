import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/controllers/orchid_controller.dart';
import 'package:socialv/screens/orchid/single_orchid_screen.dart';

import '../../components/loading_widget.dart';
import '../../components/no_data_lottie_widget.dart';
import '../../utils/alphabet_scroll.dart';

class OrchidFragment extends StatefulWidget {
  final ScrollController controller;

  const OrchidFragment({super.key, required this.controller});

  @override
  State<OrchidFragment> createState() => _OrchidFragment();
}

class _OrchidFragment extends State<OrchidFragment> {
  TextEditingController searchController = TextEditingController();
  late OrchidController orchidController = Get.put(OrchidController());

  bool hasShowClearTextIcon = false;

  @override
  void initState() {
    super.initState();

    orchidController.fetchOrchids();

    searchController.addListener(() {
      if (searchController.text.isNotEmpty) {
        showClearTextIcon();
      } else {
        hasShowClearTextIcon = false;
        setState(() {});
      }
    });
  }

  void showClearTextIcon() {
    if (!hasShowClearTextIcon) {
      hasShowClearTextIcon = true;
      setState(() {});
    } else {
      return;
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          15.height,
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchBar(
                controller: searchController,
                padding: const MaterialStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16.0)),
                leading: const Icon(Icons.search),
                hintText: 'Search Orchid',
              )),
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Expanded(
                          child: AlphabetScrollView(
                            list: orchidController.orchids
                                .map((e) => AlphaModel(e.name!,
                                    id: e.id,
                                    secondaryKey: e.botanicalName,
                                    tertiaryKey: e.imageUrl))
                                .toList(),
                            alignment: LetterAlignment.right,
                            itemExtent: 130,
                            unselectedTextStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Roboto',
                                color: Colors.black),
                            selectedTextStyle: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',
                                color: context.primaryColor),
                            overlayWidget: (value) => Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: context.primaryColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '$value'.toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            itemBuilder: (_, k, id, first, second, third) {
                              return GestureDetector(
                                onTap: () {
                                  SingleOrchidScreen(orchidId: id)
                                      .launch(context);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: 10, right: 35, top: 8),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color.fromARGB(24, 0, 0, 0)),
                                      borderRadius: radius(10),
                                      color: Color.fromARGB(33, 200, 198, 198)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Row(
                                          children: [
                                            third.isEmptyOrNull
                                                ? Image.asset(
                                                    'assets/images/images.png',
                                                    fit: BoxFit.cover,
                                                    height: 100,
                                                    width: 100,
                                                  ).cornerRadiusWithClipRRect(
                                                    25)
                                                : Image.network(
                                                    third!,
                                                    height: 100,
                                                    width: 100,
                                                    fit: BoxFit.cover,
                                                    errorBuilder:
                                                        (BuildContext context,
                                                            Object exception,
                                                            StackTrace?
                                                                stackTrace) {
                                                      return Image.asset(
                                                        'assets/images/images.png',
                                                        height: 100,
                                                        width: 100,
                                                        fit: BoxFit.cover,
                                                      ).cornerRadiusWithClipRRect(
                                                          15);
                                                    },
                                                  ).cornerRadiusWithClipRRect(
                                                    15),
                                            12.width,
                                            Expanded(
                                              child: Container(
                                                height: 100,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      '$first',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 3,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: boldTextStyle(
                                                          fontFamily: 'Roboto',
                                                          size: 18),
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                        '$second',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: boldTextStyle(
                                                          size: 15,
                                                          fontFamily: 'Roboto',
                                                          color: Color.fromARGB(
                                                              118, 0, 0, 0),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              if (orchidController.isError.value ||
                  orchidController.orchids.isEmpty)
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: NoDataWidget(
                    imageWidget: NoDataLottieWidget(),
                    title: orchidController.isError.value
                        ? 'Something Went Wrong'
                        : 'No data found',
                    onRetry: () {
                      orchidController.fetchOrchids();
                    },
                    retryText: '   Click to Refresh   ',
                  ).center(),
                ),
              Positioned(
                child: Obx(() => LoadingWidget(isBlurBackground: true)
                    .center()
                    .visible(orchidController.isLoading.value)),
              ),
            ],
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/main.dart';

class ExpertiseRequestFragment extends StatefulWidget {
  final ScrollController controller;

  const ExpertiseRequestFragment({required this.controller});

  @override
  State<ExpertiseRequestFragment> createState() =>
      _ExpertiseRequestFragmentState();
}

class _ExpertiseRequestFragmentState extends State<ExpertiseRequestFragment>
    with SingleTickerProviderStateMixin {
  int mPage = 1;
  bool mIsLastPage = false;
  int selectedIndex = 0;
  final List<String> choicesList = ['All', 'Pending', 'Approved', 'Rejected'];
  final List<Color> colorList = [
    const Color.fromARGB(127, 33, 149, 243),
    const Color.fromARGB(127, 255, 235, 59),
    Color.fromARGB(127, 76, 175, 79),
    Color.fromARGB(127, 244, 67, 54)
  ];
  @override
  void initState() {
    super.initState();
    selectedIndex = 0;
    widget.controller.addListener(() {
      if (widget.controller.position.pixels ==
          widget.controller.position.maxScrollExtent) {
        if (!mIsLastPage) {
          mPage++;
          setState(() {});
        }
      }
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Column(
          children: [
            16.height,
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List<Widget>.generate(
                choicesList.length,
                (index) => ChoiceChip(
                  label: Text(
                    choicesList[index],
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
                  ),
                  selected: selectedIndex == index,
                  selectedColor: colorList[index],
                  onSelected: (selected) {
                    setState(() {
                      selectedIndex = selected ? index : 0;
                    });
                  },
                ),
              ).toList(),
            ),
            Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: radius(10),
                  color: Color.fromARGB(33, 200, 198, 198),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xffDDDDDD),
                      blurRadius: 6.0,
                      spreadRadius: 2.0,
                      offset: Offset(0.0, 0.0),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          // widget.post.thumbnail != null
                          //     ? Image.network(
                          //         widget.post.thumbnail!,
                          //         height: 100,
                          //         width: 100,
                          //         fit: BoxFit.cover,
                          //         errorBuilder: (BuildContext context,
                          //             Object exception, StackTrace? stackTrace) {
                          //           return Image.asset(
                          //             'assets/images/images.png',
                          //             height: 100,
                          //             width: 100,
                          //             fit: BoxFit.cover,
                          //           ).cornerRadiusWithClipRRect(15);
                          //         },
                          //       ).cornerRadiusWithClipRRect(15)
                          //     :
                          Image.asset(
                            'assets/images/images.png',
                            fit: BoxFit.cover,
                            height: 100,
                            width: 100,
                          ).cornerRadiusWithClipRRect(15),
                          12.width,
                          Expanded(
                              child: Container(
                            height: 90,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'ER231123110512',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      textAlign: TextAlign.start,
                                      style: boldTextStyle(
                                          fontFamily: 'Roboto', size: 18),
                                    ),
                                    Spacer(),
                                    Container(
                                      width: 55,
                                      decoration: BoxDecoration(
                                        color: Colors.yellow[700],
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            color: Color.fromARGB(24, 0, 0, 0)),
                                      ),
                                      padding: EdgeInsets.all(6),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.star_rate_rounded,
                                                size: 15),
                                            Text(
                                              '10',
                                              style: boldTextStyle(
                                                size: 15,
                                                fontFamily: 'Roboto',
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Spacer(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('12-12-2023',
                                        style: boldTextStyle(
                                            size: 15,
                                            fontFamily: 'Roboto',
                                            color:
                                                Color.fromARGB(118, 0, 0, 0))),
                                    Container(
                                        decoration: BoxDecoration(
                                            color: colorList[selectedIndex],
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                                color: Color.fromARGB(
                                                    24, 0, 0, 0))),
                                        padding: EdgeInsets.all(6),
                                        child: Text(
                                          choicesList[selectedIndex],
                                          style: boldTextStyle(
                                              size: 15,
                                              fontFamily: 'Roboto',
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0)),
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          )),
                        ],
                      ),
                    )
                  ],
                ))
          ],
        ),
        Positioned(
          bottom: mPage != 1 ? 10 : null,
          child: Observer(
            builder: (_) => SizedBox(
              height: mPage == 1 ? context.height() * 0.5 : null,
              child: LoadingWidget(isBlurBackground: false)
                  .center()
                  .visible(appStore.isLoading),
            ),
          ),
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../components/create_expertise_request_component.dart';

class CreateExpertiseRequestResultScreen extends StatefulWidget {
  const CreateExpertiseRequestResultScreen({Key? key}) : super(key: key);

  @override
  State<CreateExpertiseRequestResultScreen> createState() =>
      _CreateExpertiseRequestResultScreenState();
}

class _CreateExpertiseRequestResultScreenState
    extends State<CreateExpertiseRequestResultScreen> {
  PageController _pageController = PageController(initialPage: 0);
  List<Widget> createAlbumWidgets = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    createAlbumWidgets.addAll(
      [
        CreateExpertiseRequestComponent(
          onNextPage: (int nextPageIndex) {
            _pageController.animateToPage(nextPageIndex,
                duration: const Duration(milliseconds: 250),
                curve: Curves.linear);
            setState(() {});
          },
        ),
        //AlbumUploadScreen(),
      ],
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.scaffoldBackgroundColor,
        title: Text('Expertise Result', style: boldTextStyle(size: 20)),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.iconColor),
          onPressed: () {
            finish(context);
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius:
              radiusOnly(topRight: defaultRadius, topLeft: defaultRadius),
        ),
        child: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: createAlbumWidgets,
        ),
      ),
    );
  }
}

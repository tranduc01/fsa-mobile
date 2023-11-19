import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/screens/profile/components/verify_face_component.dart';
import '../../../models/common_models.dart';
import '../../../models/posts/media_model.dart';

class VerifyFaceScreen extends StatefulWidget {
  final PostMedia frontIdMedia;

  const VerifyFaceScreen({Key? key, required this.frontIdMedia})
      : super(key: key);

  @override
  State<VerifyFaceScreen> createState() => _VerifyFaceState();
}

MediaModel? selectedAlbumMedia;
bool isAlbumCreated = false;

class _VerifyFaceState extends State<VerifyFaceScreen> {
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
        VerifyFaceComponent(
          onNextPage: (int nextPageIndex) {
            _pageController.animateToPage(nextPageIndex,
                duration: const Duration(milliseconds: 250),
                curve: Curves.linear);
            setState(() {});
          },
          frontIdMedia: widget.frontIdMedia,
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
        title: Text('Verify Your Identity', style: boldTextStyle(size: 20)),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.iconColor),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
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

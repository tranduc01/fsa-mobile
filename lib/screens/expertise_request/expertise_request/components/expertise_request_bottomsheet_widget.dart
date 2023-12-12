import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/main.dart';
import 'package:tap_to_expand/tap_to_expand.dart';

import '../../../../controllers/user_controller.dart';

class ExpertiseResultBottomSheetWidget extends StatefulWidget {
  ExpertiseResultBottomSheetWidget({Key? key}) : super(key: key);

  @override
  State<ExpertiseResultBottomSheetWidget> createState() =>
      _ExpertiseResultBottomSheetWidgetState();
}

class _ExpertiseResultBottomSheetWidgetState
    extends State<ExpertiseResultBottomSheetWidget> {
  int selectedIndex = -1;
  bool isLoading = false;
  bool backToHome = true;
  late UserController userController = Get.find();

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  20.height,
                  Column(
                    children: [
                      userController.user.value.avatarUrl.isEmptyOrNull
                          ? Image.asset("assets/images/profile.png",
                                  height: 62, width: 62, fit: BoxFit.cover)
                              .cornerRadiusWithClipRRect(100)
                          : Image.network(userController.user.value.avatarUrl!,
                                  height: 62, width: 62, fit: BoxFit.cover)
                              .cornerRadiusWithClipRRect(100),
                      10.height,
                      Text(
                        'Nguyễn Văn A',
                        style: boldTextStyle(size: 20),
                      ),
                      10.height,
                      Text(
                        'Chuyên gia tư vấn',
                        style: secondaryTextStyle(size: 16),
                      ),
                    ],
                  ),
                  20.height,
                  Text('Kết quả đánh giá', style: boldTextStyle(size: 25)),
                  Center(
                    child: TapToExpand(
                      content: Text(
                        'Cái cây này có thể dùng để làm gì đó nè Cái cây này có thể dùng để làm gì đó nè Cái cây này có thể dùng để làm gì đó nè Cái cây này có thể dùng để làm gì đó nè Cái cây này có thể dùng để làm gì đó nè Cái cây này có thể dùng để làm gì đó nè Cái cây này có thể dùng để làm gì đó nè Cái cây này có thể dùng để làm gì đó nè ',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            color: Colors.white,
                            height: 1.5),
                      ),
                      title: const Text(
                        'Tiêu chí 1',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      color: Colors.blueGrey,
                      onTapPadding: 10,
                      closedHeight: 70,
                      scrollable: true,
                      borderRadius: 10,
                      openedHeight: 200,
                    ),
                  ),
                ],
              ),
            ).expand(),
          ],
        ),
        LoadingWidget().center().visible(appStore.isLoading)
      ],
    );
  }
}

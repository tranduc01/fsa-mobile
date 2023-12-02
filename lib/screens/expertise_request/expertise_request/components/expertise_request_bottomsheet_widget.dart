import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/main.dart';
import 'package:tap_to_expand/tap_to_expand.dart';

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
                      Image.network(
                              'https://scontent.fsgn16-1.fna.fbcdn.net/v/t39.30808-6/353017930_6153557468098795_166607921767111563_n.jpg?_nc_cat=108&ccb=1-7&_nc_sid=5f2048&_nc_ohc=W6LrcRHkvIUAX_iHmEz&_nc_ht=scontent.fsgn16-1.fna&oh=00_AfBhfixdYyCvfg2hmq1m2iA2Jfv_Zeso_Jd2WFyEUKq7ig&oe=6568B66C',
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover)
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

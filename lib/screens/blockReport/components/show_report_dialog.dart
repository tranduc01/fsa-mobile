import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/utils/app_constants.dart';

class ShowReportDialog extends StatefulWidget {
  final bool isPostReport;
  final int? postId;
  final int? userId;

  const ShowReportDialog({
    required this.isPostReport,
    this.postId,
    this.userId,
  });

  @override
  State<ShowReportDialog> createState() => _ShowReportDialogState();
}

class _ShowReportDialogState extends State<ShowReportDialog> {
  final reportFormKey = GlobalKey<FormState>();

  TextEditingController report = TextEditingController();

  int selectedIndex = 0;

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                30.height,
                Text(language.whatAreYouReportingFor, style: boldTextStyle()),
                Text(
                  '${language.reportText} ${widget.isPostReport ? language.reportPortText : language.reportAccountText}',
                  style: secondaryTextStyle(),
                ).paddingAll(16),
                Form(
                  key: reportFormKey,
                  child: TextField(
                    enabled: !appStore.isLoading,
                    controller: report,
                    maxLines: 3,
                    minLines: 2,
                    decoration: inputDecorationFilled(
                      context,
                      label: language.report,
                      fillColor: context.scaffoldBackgroundColor,
                      // labelStyle: secondaryTextStyle(weight: FontWeight.w600),
                    ),
                  ).paddingSymmetric(horizontal: 16),
                ),
                16.height,
                Row(
                  children: [
                    AppButton(
                      elevation: 0,
                      shapeBorder: RoundedRectangleBorder(
                        borderRadius: radius(defaultAppButtonRadius),
                        side: BorderSide(color: viewLineColor),
                      ),
                      color: context.scaffoldBackgroundColor,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.close,
                              color: textPrimaryColorGlobal, size: 20),
                          6.width,
                          Text(language.cancel, style: boldTextStyle()),
                        ],
                      ).fit(),
                      onTap: () {
                        if (!appStore.isLoading) finish(context, false);
                      },
                    ).expand(),
                    16.width,
                    AppButton(
                      elevation: 0,
                      color: Colors.red,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.report_gmailerrorred,
                              color: Colors.white, size: 20),
                          6.width,
                          Text(language.report,
                              style: boldTextStyle(color: Colors.white)),
                        ],
                      ).fit(),
                      onTap: () {
                        // if (!appStore.isLoading)
                        //   ifNotTester(() async {
                        //     if (reportFormKey.currentState!.validate()) {
                        //       reportFormKey.currentState!.save();

                        //       appStore.setLoading(true);

                        //       if (widget.isPostReport) {
                        //         await reportPost(
                        //           report: report.text,
                        //           postId: widget.postId.validate(),
                        //           reportType: '',
                        //           userId: widget.userId.validate(),
                        //         ).then((value) {
                        //           toast(value.message);
                        //           appStore.setLoading(false);
                        //           finish(context);
                        //         }).catchError((e) {
                        //           toast(e.toString());
                        //           appStore.setLoading(false);
                        //         });
                        //       } else if (widget.isGroupReport) {
                        //         await reportGroup(
                        //           report: report.text,
                        //           groupId: widget.groupId.validate(),
                        //           reportType: '',
                        //         ).then((value) {
                        //           toast(value.message);
                        //           appStore.setLoading(false);
                        //           finish(context);
                        //         }).catchError((e) {
                        //           toast(e.toString());
                        //           appStore.setLoading(false);
                        //         });
                        //       } else {
                        //         await reportUser(
                        //           report: report.text,
                        //           userId: widget.userId.validate(),
                        //           reportType: '',
                        //         ).then((value) {
                        //           toast(value.message);
                        //           appStore.setLoading(false);
                        //           finish(context);
                        //         }).catchError((e) {
                        //           toast(e.toString());
                        //           appStore.setLoading(false);
                        //         });
                        //       }
                        //     }
                        //   });
                      },
                    ).expand(),
                  ],
                ).paddingAll(16),
              ],
            ),
          ),
          LoadingWidget().center().visible(appStore.isLoading)
        ],
      ),
    );
  }
}

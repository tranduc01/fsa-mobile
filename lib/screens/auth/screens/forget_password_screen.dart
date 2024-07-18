import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/controllers/user_controller.dart';
import 'package:socialv/main.dart';
import 'package:socialv/screens/auth/screens/sign_in_screen.dart';
import 'package:socialv/utils/common.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final forgetPassFormKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  late UserController userController = Get.find();

  @override
  void dispose() {
    appStore.setLoading(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0),
      body: Observer(
        builder: (_) => Stack(
          children: [
            Column(
              children: [
                headerContainer(
                  child: Text(
                    language.forgetPassword,
                    style: boldTextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ).paddingOnly(bottom: 16),
                  context: context,
                ),
                Form(
                  key: forgetPassFormKey,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: context.cardColor,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          20.height,
                          Text(language.enterTheEmailAssociated,
                              style: secondaryTextStyle(),
                              textAlign: TextAlign.center),
                          50.height,
                          AppTextField(
                            enabled: !appStore.isLoading,
                            autoFocus: true,
                            controller: emailController,
                            textFieldType: TextFieldType.EMAIL,
                            textStyle: boldTextStyle(),
                            isValidationRequired: true,
                            decoration: inputDecoration(
                              context,
                              label: language.enterYourEmail,
                              labelStyle:
                                  secondaryTextStyle(weight: FontWeight.w600),
                            ),
                          ).paddingSymmetric(horizontal: 16),
                          100.height,
                          appButton(
                              context: context,
                              text: language.getMail,
                              onTap: () async {
                                hideKeyboard(context);

                                if (!appStore.isLoading) {
                                  if (forgetPassFormKey.currentState!
                                      .validate()) {
                                    forgetPassFormKey.currentState!.save();
                                    appStore.setLoading(true);

                                    await userController.forgotPassword(
                                        emailController.text.trim().validate());
                                    if (userController.isUpdateSuccess.value) {
                                      appStore.setLoading(false);
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16)),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Lottie.asset(
                                                    'assets/lottie/email-sent.json'),
                                                Text(
                                                  'Email đã được gửi đến hòm thư của bạn. Vui lòng kiểm tra và làm theo hướng dẫn.',
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        WidgetStateProperty
                                                            .all(context
                                                                .primaryColor),
                                                    shape: WidgetStateProperty
                                                        .all(RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)))),
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  'Đồng ý',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'Roboto',
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )
                                            ],
                                          );
                                        },
                                      );
                                    } else {
                                      appStore.setLoading(false);
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16)),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Lottie.asset(
                                                    'assets/lottie/fail.json'),
                                                Text(
                                                  'Email không khớp với bất kỳ tài khoản nào. Vui lòng kiểm tra lại.',
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        WidgetStateProperty
                                                            .all(context
                                                                .primaryColor),
                                                    shape: WidgetStateProperty
                                                        .all(RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)))),
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  'Đồng ý',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'Roboto',
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  }
                                }
                              }),
                          16.height,
                          Text(
                            language.backToLogin,
                            style: secondaryTextStyle(),
                          ).onTap(() {
                            finish(context);
                            SignInScreen().launch(context);
                          })
                        ],
                      ),
                    ),
                  ).expand(),
                )
              ],
            ),
            LoadingWidget().visible(appStore.isLoading)
          ],
        ),
      ),
    );
  }
}

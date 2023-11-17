import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/controllers/user_controller.dart';
import 'package:socialv/main.dart';
import 'package:socialv/screens/auth/screens/forget_password_screen.dart';
import 'package:socialv/screens/common/fail_dialog.dart';
import 'package:socialv/screens/common/loading_dialog.dart';
import 'package:socialv/screens/dashboard_screen.dart';

import '../../../utils/app_constants.dart';

class LoginInComponent extends StatefulWidget {
  final VoidCallback? callback;
  final int? activityId;

  LoginInComponent({this.callback, this.activityId});

  @override
  State<LoginInComponent> createState() => _LoginInComponentState();
}

class _LoginInComponentState extends State<LoginInComponent> {
  final loginFormKey = GlobalKey<FormState>();
  final UserController userController = Get.put(UserController());

  bool doRemember = false;

  TextEditingController nameCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();

  FocusNode name = FocusNode();
  FocusNode password = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(fn) {}

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: context.cardColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.height,
            Text(language.welcomeBack, style: boldTextStyle(size: 24))
                .paddingSymmetric(horizontal: 16),
            8.height,
            Text(
              language.youHaveBeenMissed,
              style: secondaryTextStyle(weight: FontWeight.w500),
            ).paddingSymmetric(horizontal: 16),
            Form(
              key: loginFormKey,
              child: Container(
                child: Column(
                  children: [
                    30.height,
                    AppTextField(
                      enabled: !appStore.isLoading,
                      controller: nameCont,
                      nextFocus: password,
                      focus: name,
                      textFieldType: TextFieldType.USERNAME,
                      textStyle: boldTextStyle(),
                      decoration: inputDecoration(
                        context,
                        label: '${language.username}/${language.email}',
                        labelStyle: secondaryTextStyle(weight: FontWeight.w600),
                      ),
                    ).paddingSymmetric(horizontal: 16),
                    16.height,
                    AppTextField(
                      enabled: !appStore.isLoading,
                      controller: passwordCont,
                      focus: password,
                      textFieldType: TextFieldType.PASSWORD,
                      textStyle: boldTextStyle(),
                      suffixIconColor:
                          appStore.isDarkMode ? bodyDark : bodyWhite,
                      decoration: inputDecoration(
                        context,
                        label: language.password,
                        contentPadding: EdgeInsets.all(0),
                        labelStyle: secondaryTextStyle(weight: FontWeight.w600),
                      ),
                      isPassword: true,
                      onFieldSubmitted: (x) {
                        if (loginFormKey.currentState!.validate()) {
                          loginFormKey.currentState!.save();
                          hideKeyboard(context);

                          userController.login(nameCont.text.trim().validate(),
                              passwordCont.text.trim().validate());
                        } else {
                          appStore.setLoading(false);
                        }
                      },
                    ).paddingSymmetric(horizontal: 16),
                    12.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Observer(
                          builder: (_) => Row(
                            children: [
                              Checkbox(
                                shape: RoundedRectangleBorder(
                                    borderRadius: radius(2)),
                                activeColor: context.primaryColor,
                                value: appStore.doRemember,
                                onChanged: (val) {
                                  appStore.setRemember(!appStore.doRemember);
                                  setState(() {});
                                },
                              ),
                              Text(language.rememberMe,
                                      style: secondaryTextStyle())
                                  .onTap(() {
                                appStore.setRemember(!appStore.doRemember);
                                setState(() {});
                              }),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            ForgetPasswordScreen().launch(context);
                          },
                          child: Text(
                            language.forgetPassword,
                            style: secondaryTextStyle(
                                color: context.primaryColor,
                                fontStyle: FontStyle.italic),
                          ),
                        ).paddingRight(8)
                      ],
                    ),
                    32.height,
                    appButton(
                      context: context,
                      text: language.login.capitalizeFirstLetter(),
                      onTap: () async {
                        if (loginFormKey.currentState!.validate()) {
                          loginFormKey.currentState!.save();
                          hideKeyboard(context);

                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return LoadingDialog();
                              });

                          await userController.login(
                              nameCont.text.trim().validate(),
                              passwordCont.text.trim().validate());

                          if (userController.isLoggedIn.value) {
                            toast('Login Successfully');
                            push(DashboardScreen(),
                                isNewTask: true,
                                pageRouteAnimation: PageRouteAnimation.Slide);
                          } else {
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return FailDialog(text: 'Login Failed');
                              },
                            );
                          }
                        } else {
                          appStore.setLoading(false);
                        }
                      },
                    ),
                    16.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(language.dHaveAnAccount,
                            style: secondaryTextStyle()),
                        4.width,
                        Text(
                          language.signUp,
                          style: secondaryTextStyle(
                              color: context.primaryColor,
                              decoration: TextDecoration.underline),
                        ).onTap(() {
                          widget.callback?.call();
                        },
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent)
                      ],
                    ),
                    16.height,
                    Row(
                      children: [
                        AppButton(
                          shapeBorder: RoundedRectangleBorder(
                              borderRadius: radius(defaultAppButtonRadius)),
                          onTap: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GoogleLogoWidget(size: 14),
                              6.width,
                              Text(language.signInWithGoogle,
                                      style: primaryTextStyle(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis)
                                  .flexible(),
                            ],
                          ).center(),
                          elevation: 1,
                          color: context.cardColor,
                        ).expand(),
                      ],
                    ).paddingSymmetric(horizontal: 16),
                    50.height,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

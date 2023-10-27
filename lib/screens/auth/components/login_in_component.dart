import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/controllers/user_controller.dart';
import 'package:socialv/main.dart';
import 'package:socialv/screens/auth/screens/forget_password_screen.dart';
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

                          userController.Login(nameCont.text.trim().validate(),
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
                                return Dialog(
                                  shadowColor: Colors.transparent,
                                  backgroundColor: Colors.transparent,
                                  child: Image.asset(
                                    'assets/icons/loading.gif',
                                    height: 180,
                                    width: 180,
                                  ),
                                );
                              });

                          await userController.Login(
                              nameCont.text.trim().validate(),
                              passwordCont.text.trim().validate());

                          Future.delayed(Duration(seconds: 3), () {
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
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Container(
                                      width: 200,
                                      padding: EdgeInsets.all(16),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.asset('assets/images/fail.gif'),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            'Login Failed',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          SizedBox(height: 20),
                                          Text(
                                            'Please check your Email and Password!',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: const Color.fromARGB(
                                                  106, 0, 0, 0),
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          Center(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                'Try Again',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateColor
                                                        .resolveWith((states) {
                                                  if (states.contains(
                                                      MaterialState.pressed)) {
                                                    return const Color.fromARGB(
                                                        137, 244, 67, 54);
                                                  }
                                                  return Colors.white;
                                                }),
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      side: BorderSide(
                                                          color: Colors.red,
                                                          width: 2)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          });
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

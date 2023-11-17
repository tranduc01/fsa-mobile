import 'package:get/get.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/controllers/user_controller.dart';
import 'package:socialv/main.dart';
import 'package:socialv/screens/common/fail_dialog.dart';
import 'package:socialv/screens/common/loading_dialog.dart';

import '../../../utils/app_constants.dart';

class SignUpComponent extends StatefulWidget {
  final VoidCallback? callback;
  final int? activityId;

  SignUpComponent({this.callback, this.activityId});

  @override
  State<SignUpComponent> createState() => _SignUpComponentState();
}

class _SignUpComponentState extends State<SignUpComponent> {
  List<String> message = [];

  final signupFormKey = GlobalKey<FormState>();
  final UserController userController = Get.put(UserController());

  TextEditingController userNameCont = TextEditingController();
  TextEditingController fullNameCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  TextEditingController confirmPasswordCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController contactCont = TextEditingController();

  FocusNode userName = FocusNode();
  FocusNode fullName = FocusNode();
  FocusNode password = FocusNode();
  FocusNode confirmPassword = FocusNode();
  FocusNode email = FocusNode();
  FocusNode contact = FocusNode();

  bool agreeTNC = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: context.cardColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            10.height,
            Text(language.helloUser, style: boldTextStyle(size: 24))
                .paddingSymmetric(horizontal: 16),
            8.height,
            Text(language.createYourAccountFor,
                    style: secondaryTextStyle(weight: FontWeight.w500))
                .paddingSymmetric(horizontal: 16),
            Form(
              key: signupFormKey,
              child: Container(
                child: Column(
                  children: [
                    15.height,
                    AppTextField(
                      enabled: !appStore.isLoading,
                      controller: userNameCont,
                      nextFocus: fullName,
                      focus: userName,
                      textFieldType: TextFieldType.USERNAME,
                      textStyle: boldTextStyle(),
                      decoration: inputDecoration(
                        context,
                        label: language.username,
                        labelStyle: secondaryTextStyle(weight: FontWeight.w600),
                      ),
                    ).paddingSymmetric(horizontal: 16),
                    8.height,
                    AppTextField(
                      enabled: !appStore.isLoading,
                      controller: fullNameCont,
                      nextFocus: email,
                      focus: fullName,
                      textFieldType: TextFieldType.NAME,
                      textStyle: boldTextStyle(),
                      decoration: inputDecoration(
                        context,
                        label: language.fullName,
                        labelStyle: secondaryTextStyle(weight: FontWeight.w600),
                      ),
                    ).paddingSymmetric(horizontal: 16),
                    8.height,
                    AppTextField(
                      enabled: !appStore.isLoading,
                      controller: emailCont,
                      nextFocus: password,
                      focus: email,
                      textFieldType: TextFieldType.EMAIL,
                      textStyle: boldTextStyle(),
                      decoration: inputDecoration(
                        context,
                        label: language.yourEmail,
                        labelStyle: secondaryTextStyle(weight: FontWeight.w600),
                      ),
                    ).paddingSymmetric(horizontal: 16),
                    16.height,
                    AppTextField(
                      enabled: !appStore.isLoading,
                      controller: passwordCont,
                      nextFocus: contact,
                      focus: password,
                      textInputAction: TextInputAction.done,
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
                      validator: (value) {
                        RegExp passwordPattern = RegExp(
                            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^a-zA-Z0-9]).{6,}$');
                        if (passwordCont.text.isEmptyOrNull) {
                          return 'This field is required';
                        } else if (!passwordPattern
                            .hasMatch(passwordCont.text.trim())) {
                          return 'Password must contain at least 6 characters, 1 uppercase letter, 1 lowercase letter, 1 number and 1 special character';
                        } else {
                          return null;
                        }
                      },
                    ).paddingSymmetric(horizontal: 16),
                    16.height,
                    AppTextField(
                      enabled: !appStore.isLoading,
                      controller: confirmPasswordCont,
                      nextFocus: contact,
                      focus: confirmPassword,
                      textInputAction: TextInputAction.done,
                      textFieldType: TextFieldType.PASSWORD,
                      textStyle: boldTextStyle(),
                      suffixIconColor:
                          appStore.isDarkMode ? bodyDark : bodyWhite,
                      decoration: inputDecoration(
                        context,
                        label: 'Confirm Password',
                        contentPadding: EdgeInsets.all(0),
                        labelStyle: secondaryTextStyle(weight: FontWeight.w600),
                      ),
                      isPassword: true,
                      validator: (value) {
                        if (passwordCont.text.isEmptyOrNull) {
                          return 'This field is required';
                        } else if (passwordCont.text.trim() !=
                            confirmPasswordCont.text.trim()) {
                          return 'Password does not match';
                        } else {
                          return null;
                        }
                      },
                    ).paddingSymmetric(horizontal: 16),
                    Row(
                      children: [
                        Checkbox(
                          shape:
                              RoundedRectangleBorder(borderRadius: radius(2)),
                          activeColor: context.primaryColor,
                          value: agreeTNC,
                          onChanged: (val) {
                            agreeTNC = !agreeTNC;
                            setState(() {});
                          },
                        ),
                        RichTextWidget(
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          list: [
                            TextSpan(
                                text: language.bySigningUpYou + " ",
                                style:
                                    secondaryTextStyle(fontFamily: fontFamily)),
                            TextSpan(
                              text: "\n${language.termsCondition}",
                              style: secondaryTextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  fontStyle: FontStyle.italic,
                                  fontFamily: fontFamily),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  openWebPage(context,
                                      url: TERMS_AND_CONDITIONS_URL);
                                },
                            ),
                            TextSpan(text: " & ", style: secondaryTextStyle()),
                            TextSpan(
                              text: "${language.privacyPolicy}.",
                              style: secondaryTextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  fontStyle: FontStyle.italic),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  openWebPage(context, url: PRIVACY_POLICY_URL);
                                },
                            ),
                          ],
                        ).expand(),
                      ],
                    ).paddingSymmetric(vertical: 16),
                    appButton(
                      context: context,
                      text: language.signUp.capitalizeFirstLetter(),
                      onTap: () async {
                        if (signupFormKey.currentState!.validate()) {
                          signupFormKey.currentState!.save();
                          hideKeyboard(context);

                          if (agreeTNC) {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return LoadingDialog();
                                });

                            await userController.register(
                                fullNameCont.text.trim().validate(),
                                emailCont.text.trim().validate(),
                                passwordCont.text.trim(),
                                confirmPasswordCont.text.trim().validate());

                            if (userController.isRegistered.value) {
                              Navigator.pop(context);
                              widget.callback?.call();
                              toast('Registered Successfully');
                            } else {
                              Navigator.pop(context);
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return FailDialog(text: 'Register Failed');
                                },
                              );
                            }
                          } else {
                            toast(language.pleaseAgreeOurTerms);
                          }
                        }
                      },
                    ),
                    16.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(language.alreadyHaveAnAccount,
                            style: secondaryTextStyle()),
                        4.width,
                        Text(
                          language.signIn,
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

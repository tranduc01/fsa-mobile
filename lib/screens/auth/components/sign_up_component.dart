import 'package:get/get.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/controllers/user_controller.dart';
import 'package:socialv/main.dart';

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
                      onFieldSubmitted: (x) {
                        if (signupFormKey.currentState!.validate()) {
                          signupFormKey.currentState!.save();
                          hideKeyboard(context);

                          if (agreeTNC) {
                            userController.Register(
                                fullNameCont.text.trim().validate(),
                                emailCont.text.trim().validate(),
                                passwordCont.text.trim().validate(),
                                confirmPasswordCont.text.trim().validate());
                          } else {
                            toast(language.pleaseAgreeOurTerms);
                          }
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
                      onFieldSubmitted: (x) {
                        if (signupFormKey.currentState!.validate()) {
                          signupFormKey.currentState!.save();
                          hideKeyboard(context);

                          if (agreeTNC) {
                            userController.Register(
                                fullNameCont.text.trim().validate(),
                                emailCont.text.trim().validate(),
                                passwordCont.text.trim().validate(),
                                confirmPasswordCont.text.trim().validate());
                          } else {
                            toast(language.pleaseAgreeOurTerms);
                          }
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
                      onTap: () {
                        if (signupFormKey.currentState!.validate()) {
                          signupFormKey.currentState!.save();
                          hideKeyboard(context);

                          if (agreeTNC) {
                            if (passwordCont.text.trim() ==
                                confirmPasswordCont.text.trim()) {
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

                              userController.Register(
                                  fullNameCont.text.trim().validate(),
                                  emailCont.text.trim().validate(),
                                  passwordCont.text.trim().validate(),
                                  confirmPasswordCont.text.trim().validate());
                              Future.delayed(Duration(seconds: 3), () {
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
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Container(
                                          width: 200,
                                          padding: EdgeInsets.all(16),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Image.asset(
                                                  'assets/images/fail.gif'),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text(
                                                'Register Failed',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                              SizedBox(height: 20),
                                              Text(
                                                'Please try again!',
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
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateColor
                                                            .resolveWith(
                                                                (states) {
                                                      if (states.contains(
                                                          MaterialState
                                                              .pressed)) {
                                                        return const Color
                                                                .fromARGB(
                                                            137, 244, 67, 54);
                                                      }
                                                      return Colors.white;
                                                    }),
                                                    shape: MaterialStateProperty
                                                        .all<
                                                            RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
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
                              toast(
                                  'Password and Confirm Password does not match');
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

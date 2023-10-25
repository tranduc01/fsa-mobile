import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/screens/auth/components/login_in_component.dart';
import 'package:socialv/screens/auth/components/sign_up_component.dart';

import '../../../utils/app_constants.dart';

class SignInScreen extends StatefulWidget {
  final int? activityId;

  const SignInScreen({this.activityId});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool doRemember = false;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    setStatusBarColorBasedOnTheme();
  }

  Widget getFragment() {
    if (selectedIndex == 0) {
      return LoginInComponent(
        activityId: widget.activityId,
        callback: () {
          selectedIndex = 1;
          setState(() {});
        },
      );
    } else {
      return SignUpComponent(
        activityId: widget.activityId,
        callback: () {
          selectedIndex = 0;
          setState(() {});
        },
      );
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          GestureDetector(
            onHorizontalDragUpdate: (details) {
              int sensitivity = 8;
              if (details.delta.dx > sensitivity) {
                selectedIndex = 0;
                setState(() {});
              } else if (details.delta.dx < -sensitivity) {
                selectedIndex = 1;
                setState(() {});
              }
            },
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(APP_ICON,
                              height: 100, width: 100, fit: BoxFit.cover),
                          Text(APP_NAME,
                              style: boldTextStyle(
                                  color: context.primaryColor, size: 50)),
                        ],
                      ),
                      10.height,
                      headerContainer(
                        context: context,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                              child: Text(language.login.toUpperCase(),
                                  style: boldTextStyle(
                                      color: selectedIndex == 0
                                          ? Colors.white
                                          : Colors.white54)),
                              onPressed: () {
                                selectedIndex = 0;
                                setState(() {});
                              },
                            ),
                            TextButton(
                              child: Text(language.signUp.toUpperCase(),
                                  style: boldTextStyle(
                                      color: selectedIndex == 1
                                          ? Colors.white
                                          : Colors.white54)),
                              onPressed: () {
                                selectedIndex = 1;
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ),
                      getFragment().expand(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

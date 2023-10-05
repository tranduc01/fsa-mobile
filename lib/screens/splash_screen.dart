import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/screens/dashboard_screen.dart';

import '../utils/app_constants.dart';

class SplashScreen extends StatefulWidget {
  final int? activityId;

  const SplashScreen({this.activityId});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    setStatusBarColor(Colors.transparent);
    super.initState();
    init();
  }

  Future<void> init() async {
    afterBuildCreated(() {
      appStore.setLanguage(getStringAsync(SharePreferencesKey.LANGUAGE,
          defaultValue: Constants.defaultLanguage));

      int themeModeIndex = getIntAsync(SharePreferencesKey.APP_THEME,
          defaultValue: AppThemeMode.ThemeModeSystem);
      if (themeModeIndex == AppThemeMode.ThemeModeSystem) {
        appStore.toggleDarkMode(
            value:
                MediaQuery.of(context).platformBrightness != Brightness.light,
            isFromMain: true);
      }
    });

    if (await isAndroid12Above()) {
      await 3.seconds.delay;
    } else {
      await 3.seconds.delay;
    }

    // if (widget.activityId != null) {
    //   if (appStore.isLoggedIn) {
    //     SinglePostScreen(postId: widget.activityId.validate())
    //         .launch(context, isNewTask: true);
    //   } else {
    //     SignInScreen(activityId: widget.activityId.validate())
    //         .launch(context, isNewTask: true);
    //   }
    // } else if (appStore.isLoggedIn && !isTokenExpire) {
    //   DashboardScreen().launch(context, isNewTask: true);
    // } else {
    //   SignInScreen().launch(context, isNewTask: true);
    // }
    DashboardScreen().launch(context, isNewTask: true);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    setStatusBarColorBasedOnTheme();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment(0.8, 1),
          colors: <Color>[
            // Color.fromARGB(250, 58, 16, 120),
            // Color.fromARGB(250, 78, 49, 170),
            // Color.fromARGB(250, 47, 88, 205),
            // Color.fromARGB(250, 55, 149, 189),
            Color.fromRGBO(255, 192, 203, 0.8),
            Color.fromRGBO(255, 105, 180, 0.8)
          ],
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              APP_ICON,
              height: 300,
              width: 300,
            ),
            Image.asset(
              "assets/oka-name-slogan.png",
              height: 250,
              width: 250,
            ),
          ],
        ),
      ),
    );
  }
}

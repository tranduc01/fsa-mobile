import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/app_theme.dart';
import 'package:socialv/controllers/user_controller.dart';
import 'package:socialv/language/app_localizations.dart';
import 'package:socialv/language/languages.dart';
import 'package:socialv/models/common_models.dart';
import 'package:socialv/screens/splash_screen.dart';
import 'package:socialv/store/app_store.dart';
import 'package:socialv/store/lms_store.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:flutter_portal/flutter_portal.dart';

AppStore appStore = AppStore();
LmsStore lmsStore = LmsStore();

late BaseLanguage language;

String currentPackageName = '';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initialize(aLocaleLanguageList: languageList());

  Firebase.initializeApp().then((value) {}).catchError((e) {
    log('Error: ${e.toString()}');
  });

  defaultRadius = 32.0;
  defaultAppButtonRadius = 12;

  exitFullScreen();
  Get.put(UserController());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    afterBuildCreated(() async {
      // if (themeModeIndex == AppThemeMode.ThemeModeLight) {
      //   appStore.toggleDarkMode(value: false, isFromMain: true);
      // } else {
      //   appStore.toggleDarkMode(value: true, isFromMain: true);
      // }
      appStore.toggleDarkMode(value: false, isFromMain: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Portal(
      child: Observer(
        builder: (_) => MaterialApp(
          navigatorKey: navigatorKey,
          title: APP_NAME,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.light,
          home: SplashScreen(),
          builder: (context, child) {
            return ScrollConfiguration(
                behavior: MyBehavior(), child: child.validate());
          },
          supportedLocales: LanguageDataModel.languageLocales(),
          localizationsDelegates: [
            AppLocalizations(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) => locale,
          locale: Locale(appStore.selectedLanguage
              .validate(value: Constants.defaultLanguage)),
          onGenerateRoute: (settings) {
            String pathComponents = settings.name!.split('/').last;

            if (pathComponents.isInt) {
              return MaterialPageRoute(
                builder: (context) {
                  return SplashScreen(activityId: pathComponents.toInt());
                },
              );
            } else {
              return MaterialPageRoute(builder: (_) => SplashScreen());
            }
          },
        ),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

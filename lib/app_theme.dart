import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/utils/colors.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: appLayoutBackground,
    primaryColor: appColorPrimary,
    primaryColorDark: appColorPrimary,
    useMaterial3: false,
    hoverColor: Colors.white54,
    dividerColor: bodyWhite.withOpacity(0.4),
    fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
    appBarTheme: AppBarTheme(
      surfaceTintColor: appLayoutBackground,
      color: appLayoutBackground,
      iconTheme: IconThemeData(color: textPrimaryColor),
      systemOverlayStyle:
          SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
    ),
    tabBarTheme: TabBarTheme(
        indicator: UnderlineTabIndicator(
            borderSide: BorderSide(color: Color(0xFFB6D5EF), width: 3))),
    textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.black),
    cardTheme: CardTheme(color: Colors.white),
    cardColor: appSectionBackground,
    iconTheme: IconThemeData(color: textPrimaryColor),
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: whiteColor),
    textTheme: TextTheme(
      labelLarge: TextStyle(color: appColorPrimary),
      titleLarge: TextStyle(color: textPrimaryColor),
      titleSmall: TextStyle(color: textSecondaryColor),
    ),
    //visualDensity: VisualDensity.adaptivePlatformDensity,
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.all(appColorPrimary),
    ),
    colorScheme:
        ColorScheme.light(primary: appColorPrimary).copyWith(error: Colors.red),
  ).copyWith(
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: appColorPrimary),
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: appBackgroundColorDark,
    useMaterial3: false,
    highlightColor: appBackgroundColorDark,
    appBarTheme: AppBarTheme(
      surfaceTintColor: appBackgroundColorDark,
      color: appBackgroundColorDark,
      iconTheme: IconThemeData(color: whiteColor),
      systemOverlayStyle:
          SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
    ),
    primaryColor: appColorPrimary,
    dividerColor: bodyDark.withOpacity(0.4),
    primaryColorDark: appColorPrimary,
    textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.white),
    hoverColor: Colors.black12,
    fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
    bottomSheetTheme:
        BottomSheetThemeData(backgroundColor: appBackgroundColorDark),
    primaryTextTheme: TextTheme(
        titleLarge: primaryTextStyle(color: Colors.white),
        labelSmall: primaryTextStyle(color: Colors.white)),
    cardTheme: CardTheme(color: cardBackgroundBlackDark),
    cardColor: cardBackgroundBlackDark,
    iconTheme: IconThemeData(color: whiteColor),
    textTheme: TextTheme(
      labelLarge: TextStyle(color: appColorPrimary),
      titleLarge: TextStyle(color: whiteColor),
      titleSmall: TextStyle(color: Colors.white54),
    ),
    tabBarTheme: TabBarTheme(
        indicator:
            UnderlineTabIndicator(borderSide: BorderSide(color: Colors.white))),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.all(appColorPrimary),
    ),
    colorScheme: ColorScheme.dark(
            primary: appBackgroundColorDark, onPrimary: cardBackgroundBlackDark)
        .copyWith(secondary: whiteColor)
        .copyWith(error: Color(0xFFCF6676)),
  ).copyWith(
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: appColorPrimary),
  );
}

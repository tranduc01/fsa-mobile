import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/screens/profile/screens/edit_profile_screen.dart';
import 'package:socialv/screens/settings/screens/change_password_screen.dart';
import 'package:socialv/screens/settings/screens/language_screen.dart';
import 'package:socialv/utils/app_constants.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isUpdate = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    int themeModeIndex = getIntAsync(SharePreferencesKey.APP_THEME,
        defaultValue: AppThemeMode.ThemeModeSystem);

    window.onPlatformBrightnessChanged = () {
      if (themeModeIndex == AppThemeMode.ThemeModeSystem) {
        appStore.toggleDarkMode(
            value:
                MediaQuery.of(context).platformBrightness == Brightness.light);
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (isPop) {
        finish(context, isUpdate);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(language.settings, style: boldTextStyle(size: 20)),
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: context.iconColor),
            onPressed: () {
              finish(context);
            },
          ),
        ),
        body: Observer(
          builder: (_) => Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    SettingSection(
                      title: Text(language.appSetting.toUpperCase(),
                          style: boldTextStyle(color: context.primaryColor)),
                      headingDecoration:
                          BoxDecoration(color: context.cardColor),
                      items: [
                        SettingItemWidget(
                          title: language.appTheme,
                          titleTextStyle: primaryTextStyle(
                              color:
                                  appStore.isDarkMode ? bodyDark : bodyWhite),
                          leading: Image.asset(ic_dark_mode,
                              height: 18,
                              width: 18,
                              color: context.primaryColor,
                              fit: BoxFit.cover),
                          trailing: Icon(Icons.arrow_forward_ios,
                              color: appStore.isDarkMode ? bodyDark : bodyWhite,
                              size: 16),
                          onTap: () async {
                            await showGeneralDialog(
                              context: context,
                              transitionDuration: Duration(milliseconds: 250),
                              barrierColor: Colors.black26,
                              transitionBuilder: (ctx, a1, a2, widget) {
                                return Transform.scale(
                                  scale: a1.value,
                                  child: Opacity(
                                    opacity: a1.value,
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 3,
                                          sigmaY: 3,
                                          tileMode: TileMode.repeated),
                                      child: Dialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                defaultRadius)),
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        elevation: 0,
                                        insetAnimationCurve: Curves.linear,
                                        insetAnimationDuration: 0.seconds,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(16),
                                              width: ctx.width(),
                                              decoration: BoxDecoration(
                                                  color: context.primaryColor),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(language.appTheme,
                                                      style: boldTextStyle(
                                                          color: Colors.white,
                                                          size: 20)),
                                                  Image.asset(ic_close_square,
                                                          height: 24,
                                                          width: 24,
                                                          fit: BoxFit.cover,
                                                          color: Colors.white)
                                                      .onTap(() {
                                                    finish(ctx);
                                                  },
                                                          splashColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent)
                                                ],
                                              ),
                                            ),
                                            RadioListTile(
                                              value: getIntAsync(
                                                  SharePreferencesKey
                                                      .APP_THEME),
                                              groupValue:
                                                  AppThemeMode.ThemeModeSystem,
                                              onChanged: (val) async {
                                                appStore.toggleDarkMode(
                                                    value: MediaQuery.of(
                                                                context)
                                                            .platformBrightness ==
                                                        Brightness.dark);
                                                await setValue(
                                                    SharePreferencesKey
                                                        .APP_THEME,
                                                    AppThemeMode
                                                        .ThemeModeSystem);
                                                await setValue(
                                                    SharePreferencesKey
                                                        .IS_DARK_MODE,
                                                    MediaQuery.of(context)
                                                            .platformBrightness ==
                                                        Brightness.dark);
                                                finish(ctx);
                                              },
                                              title: Text(
                                                  language.systemDefault,
                                                  style: primaryTextStyle()),
                                            ),
                                            RadioListTile(
                                              value: getIntAsync(
                                                  SharePreferencesKey
                                                      .APP_THEME),
                                              groupValue:
                                                  AppThemeMode.ThemeModeDark,
                                              onChanged: (val) async {
                                                appStore.toggleDarkMode(
                                                    value: true);
                                                await setValue(
                                                    SharePreferencesKey
                                                        .APP_THEME,
                                                    AppThemeMode.ThemeModeDark);
                                                await setValue(
                                                    SharePreferencesKey
                                                        .IS_DARK_MODE,
                                                    true);
                                                finish(ctx);
                                              },
                                              title: Text(language.darkMode,
                                                  style: primaryTextStyle()),
                                            ),
                                            RadioListTile(
                                              value: getIntAsync(
                                                  SharePreferencesKey
                                                      .APP_THEME),
                                              groupValue:
                                                  AppThemeMode.ThemeModeLight,
                                              onChanged: (val) async {
                                                appStore.toggleDarkMode(
                                                    value: false);
                                                await setValue(
                                                    SharePreferencesKey
                                                        .APP_THEME,
                                                    AppThemeMode
                                                        .ThemeModeLight);
                                                await setValue(
                                                    SharePreferencesKey
                                                        .IS_DARK_MODE,
                                                    false);
                                                finish(ctx);
                                              },
                                              title: Text(language.lightMode,
                                                  style: primaryTextStyle()),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              pageBuilder: (context, animation1, animation2) =>
                                  Offstage(),
                            );
                          },
                        ),
                        SettingItemWidget(
                          title: language.appLanguage,
                          titleTextStyle: primaryTextStyle(
                              color:
                                  appStore.isDarkMode ? bodyDark : bodyWhite),
                          leading: Image.asset(ic_network,
                              height: 18,
                              width: 18,
                              color: context.primaryColor,
                              fit: BoxFit.cover),
                          trailing: Icon(Icons.arrow_forward_ios,
                              color: appStore.isDarkMode ? bodyDark : bodyWhite,
                              size: 16),
                          onTap: () {
                            LanguageScreen().launch(context);
                          },
                        ),
                      ],
                    ),
                    SettingSection(
                      title: Text(
                          '${language.account.toUpperCase()} ${language.settings.toUpperCase()}',
                          style: boldTextStyle(color: context.primaryColor)),
                      headingDecoration:
                          BoxDecoration(color: context.cardColor),
                      items: [
                        SettingItemWidget(
                          title: language.editProfile,
                          titleTextStyle: primaryTextStyle(
                              color:
                                  appStore.isDarkMode ? bodyDark : bodyWhite),
                          leading: Image.asset(ic_edit,
                              height: 18,
                              width: 18,
                              color: context.primaryColor,
                              fit: BoxFit.cover),
                          trailing: Icon(Icons.arrow_forward_ios,
                              color: appStore.isDarkMode ? bodyDark : bodyWhite,
                              size: 16),
                          onTap: () {
                            if (!appStore.isLoading)
                              EditProfileScreen().launch(context).then((value) {
                                isUpdate = value;
                              });
                          },
                        ),
                        SettingItemWidget(
                          title: language.changePassword,
                          titleTextStyle: primaryTextStyle(
                              color:
                                  appStore.isDarkMode ? bodyDark : bodyWhite),
                          leading: Image.asset(ic_lock,
                              height: 18,
                              width: 18,
                              color: context.primaryColor,
                              fit: BoxFit.cover),
                          trailing: Icon(Icons.arrow_forward_ios,
                              color: appStore.isDarkMode ? bodyDark : bodyWhite,
                              size: 16),
                          onTap: () {
                            if (!appStore.isLoading)
                              ChangePasswordScreen().launch(context);
                          },
                        ),
                        SettingItemWidget(
                          title: language.profileVisibility,
                          titleTextStyle: primaryTextStyle(
                              color:
                                  appStore.isDarkMode ? bodyDark : bodyWhite),
                          leading: Image.asset(ic_profile,
                              height: 18,
                              width: 18,
                              color: context.primaryColor,
                              fit: BoxFit.cover),
                          trailing: Icon(Icons.arrow_forward_ios,
                              color: appStore.isDarkMode ? bodyDark : bodyWhite,
                              size: 16),
                          onTap: () {},
                        ),
                      ],
                    ),
                    SettingSection(
                      title: Text(language.about.toUpperCase(),
                          style: boldTextStyle(color: context.primaryColor)),
                      headingDecoration:
                          BoxDecoration(color: context.cardColor),
                      items: [
                        SnapHelperWidget<PackageInfoData>(
                          future: getPackageInfo(),
                          onSuccess: (d) => SettingItemWidget(
                            title: language.rateUs,
                            titleTextStyle: primaryTextStyle(
                                color:
                                    appStore.isDarkMode ? bodyDark : bodyWhite),
                            leading: Image.asset(ic_star,
                                height: 18,
                                width: 18,
                                color: context.primaryColor,
                                fit: BoxFit.cover),
                            trailing: Icon(Icons.arrow_forward_ios,
                                color:
                                    appStore.isDarkMode ? bodyDark : bodyWhite,
                                size: 16),
                            onTap: () {},
                          ),
                        ),
                        SettingItemWidget(
                          title: language.shareApp,
                          titleTextStyle: primaryTextStyle(
                              color:
                                  appStore.isDarkMode ? bodyDark : bodyWhite),
                          leading: Image.asset(ic_send,
                              height: 18,
                              width: 18,
                              color: context.primaryColor,
                              fit: BoxFit.cover),
                          trailing: Icon(Icons.arrow_forward_ios,
                              color: appStore.isDarkMode ? bodyDark : bodyWhite,
                              size: 16),
                          onTap: () {},
                        ),
                        SettingItemWidget(
                          title: language.privacyPolicy,
                          titleTextStyle: primaryTextStyle(
                              color:
                                  appStore.isDarkMode ? bodyDark : bodyWhite),
                          leading: Image.asset(ic_shield_done,
                              height: 16,
                              width: 18,
                              color: context.primaryColor,
                              fit: BoxFit.cover),
                          trailing: Icon(Icons.arrow_forward_ios,
                              color: appStore.isDarkMode ? bodyDark : bodyWhite,
                              size: 16),
                          onTap: () {
                            if (!appStore.isLoading)
                              openWebPage(context, url: PRIVACY_POLICY_URL);
                          },
                        ),
                        SettingItemWidget(
                          title: language.termsCondition,
                          titleTextStyle: primaryTextStyle(
                              color:
                                  appStore.isDarkMode ? bodyDark : bodyWhite),
                          leading: Image.asset(ic_document,
                              height: 18,
                              width: 18,
                              color: context.primaryColor,
                              fit: BoxFit.cover),
                          trailing: Icon(Icons.arrow_forward_ios,
                              color: appStore.isDarkMode ? bodyDark : bodyWhite,
                              size: 16),
                          onTap: () {
                            if (!appStore.isLoading)
                              openWebPage(context,
                                  url: TERMS_AND_CONDITIONS_URL);
                          },
                        ),
                        SettingItemWidget(
                          title: language.helpSupport,
                          titleTextStyle: primaryTextStyle(
                              color:
                                  appStore.isDarkMode ? bodyDark : bodyWhite),
                          leading: Image.asset(ic_question_circle,
                              height: 18,
                              width: 18,
                              color: appColorPrimary,
                              fit: BoxFit.cover),
                          trailing: Icon(Icons.arrow_forward_ios,
                              color: appStore.isDarkMode ? bodyDark : bodyWhite,
                              size: 16),
                          onTap: () {
                            if (!appStore.isLoading)
                              openWebPage(context, url: SUPPORT_URL);
                          },
                        ),
                      ],
                    ),
                    SettingSection(
                      title: Text(language.manageAccount.toUpperCase(),
                          style: boldTextStyle(color: context.primaryColor)),
                      headingDecoration:
                          BoxDecoration(color: context.cardColor),
                      items: [
                        SettingItemWidget(
                          title: language.invitations,
                          titleTextStyle: primaryTextStyle(
                              color:
                                  appStore.isDarkMode ? bodyDark : bodyWhite),
                          leading: Image.asset(ic_message,
                              height: 18,
                              width: 18,
                              color: appColorPrimary,
                              fit: BoxFit.cover),
                          trailing: Icon(Icons.arrow_forward_ios,
                              color: appStore.isDarkMode ? bodyDark : bodyWhite,
                              size: 16),
                          onTap: () {},
                        ),
                        SettingItemWidget(
                          title: language.blockedAccounts,
                          titleTextStyle: primaryTextStyle(
                              color:
                                  appStore.isDarkMode ? bodyDark : bodyWhite),
                          leading: Image.asset(ic_close_square,
                              height: 18,
                              width: 18,
                              color: appColorPrimary,
                              fit: BoxFit.cover),
                          trailing: Icon(Icons.arrow_forward_ios,
                              color: appStore.isDarkMode ? bodyDark : bodyWhite,
                              size: 16),
                          onTap: () {},
                        ),
                        Observer(
                          builder: (_) => SettingItemWidget(
                            title: language.requestVerification,
                            titleTextStyle: primaryTextStyle(
                                color:
                                    appStore.isDarkMode ? bodyDark : bodyWhite),
                            leading: Image.asset(ic_tick_square,
                                height: 18,
                                width: 18,
                                color: appColorPrimary,
                                fit: BoxFit.cover),
                            trailing: appStore.verificationStatus ==
                                        VerificationStatus.accepted ||
                                    appStore.verificationStatus ==
                                        VerificationStatus.pending
                                ? Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                        color: appStore.verificationStatus ==
                                                VerificationStatus.accepted
                                            ? appGreenColor
                                            : context.primaryColor,
                                        borderRadius: radius(4)),
                                    child: Text(
                                        appStore.verificationStatus
                                            .capitalizeFirstLetter(),
                                        style: secondaryTextStyle(
                                            color: Colors.white)),
                                  )
                                : Offstage(),
                            onTap: () {},
                          ),
                        ),
                        SettingItemWidget(
                          title: language.deleteAccount,
                          titleTextStyle:
                              primaryTextStyle(color: Colors.redAccent),
                          leading: Image.asset(ic_delete,
                              height: 18,
                              width: 18,
                              color: Colors.redAccent,
                              fit: BoxFit.cover),
                          onTap: () {},
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(language.logout,
                          style: boldTextStyle(color: context.primaryColor)),
                    ).paddingAll(16),
                    30.height,
                  ],
                ),
              ),
              LoadingWidget().center().visible(appStore.isLoading),
            ],
          ),
        ),
      ),
    );
  }
}

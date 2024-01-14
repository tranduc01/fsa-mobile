import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/screens/stats/screens/stats_screen.dart';
import 'package:socialv/screens/wallet/wallet_screen.dart';

import '../screens/settings/screens/settings_screen.dart';
import '../utils/app_constants.dart';

class DrawerModel {
  String? title;
  String? image;
  Widget? attachedScreen;
  bool isNew;

  DrawerModel(
      {this.image, this.title, this.attachedScreen, this.isNew = false});
}

List<DrawerModel> getDrawerOptions() {
  List<DrawerModel> list = [];

  list.add(DrawerModel(
      image: ic_wallet, title: 'Wallet', attachedScreen: WalletScreen()));
  list.add(DrawerModel(
      image: stats, title: 'Thống kê', attachedScreen: StatsScreen()));
  list.add(DrawerModel(
      image: ic_setting,
      title: language.settings,
      attachedScreen: SettingsScreen()));

  return list;
}

class FilterModel {
  String? title;
  String? value;

  FilterModel({this.value, this.title});
}

List<FilterModel> getProductFilters() {
  List<FilterModel> list = [];

  list.add(FilterModel(value: ProductFilters.date, title: language.latest));
  list.add(
      FilterModel(value: ProductFilters.rating, title: language.averageRating));
  list.add(FilterModel(
      value: ProductFilters.popularity, title: language.popularity));
  list.add(FilterModel(value: ProductFilters.price, title: language.price));

  return list;
}

class PostMedia {
  File? file;
  String? link;
  bool isLink;

  PostMedia({this.file, this.link, this.isLink = false});
}

List<LanguageDataModel> languageList() {
  return [
    LanguageDataModel(
        id: 1,
        name: 'English',
        subTitle: 'English',
        languageCode: 'en',
        fullLanguageCode: 'en_en-US',
        flag: 'assets/flag/ic_us.png'),
    LanguageDataModel(
        id: 2,
        name: 'Vietnamese',
        subTitle: 'Tiếng Việt',
        languageCode: 'vi',
        fullLanguageCode: 'vi_vi-VI',
        flag: 'assets/flag/ic_vi.png'),
  ];
}

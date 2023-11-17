import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/dashboard_api_response.dart';
import 'package:socialv/models/posts/post_in_list_model.dart';
import 'package:socialv/models/reactions/reactions_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/fragments/forums_fragment.dart';
import 'package:socialv/screens/fragments/home_fragment.dart';
import 'package:socialv/screens/fragments/notification_fragment.dart';
import 'package:socialv/screens/fragments/profile_fragment.dart';
import 'package:socialv/screens/fragments/search_fragment.dart';
import 'package:socialv/screens/home/components/ranking_bottomsheet_widget.dart';
import 'package:socialv/screens/home/components/user_detail_bottomsheet_widget.dart';
import 'package:socialv/screens/notification/components/latest_activity_component.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';

import '../controllers/user_controller.dart';

int selectedIndex = 0;

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

List<VisibilityOptions>? visibilities;
List<VisibilityOptions>? accountPrivacyVisibility;
List<ReportType>? reportTypes;
List<PostInListModel>? postInListDashboard;
List<ReactionsModel> reactions = [
  ReactionsModel(
      id: "1",
      imageUrl:
          "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.freepik.com%2Ffree-photos-vectors%2Fcute-anima&psig=AOvVaw2RMtRmFfL-lDZ7FDxcK4X_&ust=1692713440659000&source=images&cd=vfe&opi=89978449&ved=0CBAQjRxqFwoTCKCbi4337YADFQAAAAAdAAAAABAE",
      name: "Tran Duc",
      defaultImageUrl:
          "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.freepik.com%2Ffree-photos-vectors%2Fcute-anima&psig=AOvVaw2RMtRmFfL-lDZ7FDxcK4X_&ust=1692713440659000&source=images&cd=vfe&opi=89978449&ved=0CBAQjRxqFwoTCKCbi4337YADFQAAAAAdAAAAABAE")
];

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  bool hasUpdate = false;
  late AnimationController _animationController;

  ScrollController _controller = ScrollController();

  late TabController tabController;

  bool onAnimationEnd = true;

  List<Widget> appFragments = [];

  late UserController userController = Get.put(UserController());

  @override
  void initState() {
    _animationController = BottomSheet.createAnimationController(this);
    _animationController.duration = const Duration(milliseconds: 500);
    _animationController.drive(CurveTween(curve: Curves.easeOutQuad));

    super.initState();
    tabController = TabController(length: 5, vsync: this);

    init();
  }

  Future<void> init() async {
    appFragments.addAll([
      HomeFragment(controller: _controller),
      SearchFragment(controller: _controller),
      ForumsFragment(controller: _controller),
      NotificationFragment(controller: _controller),
      ProfileFragment(controller: _controller),
    ]);

    await getReactionsList();
    defaultReactionsList();

    _controller.addListener(() {
      //
    });

    selectedIndex = 0;
    setState(() {});

    //getDetails();

    // Map req = {
    //   "player_id": getStringAsync(SharePreferencesKey.ONE_SIGNAL_PLAYER_ID),
    //   "add": 1
    // };

    // await setPlayerId(req).then((value) {
    //   //
    // }).catchError((e) {
    //   log("Player id error : ${e.toString()}");
    // });

    // getNonce().then((value) {
    //   appStore.setNonce(value.storeApiNonce.validate());
    // }).catchError(onError);

    setStatusBarColorBasedOnTheme();

    //activeUser();
    //getNotificationCount();
    //getMediaList();
  }

  Future<void> getMediaList() async {
    await getMediaTypes().then((value) {
      if (value.any((element) => element.type == MediaTypes.gif)) {
        appStore.setShowGif(true);
      }
    }).catchError((e) {
      //
    });
    setState(() {});
  }

  Future<void> getDetails() async {
    await getDashboardDetails().then((value) {
      appStore.setNotificationCount(value.notificationCount.validate());
      appStore.setVerificationStatus(value.verificationStatus.validate());
      visibilities = value.visibilities.validate();
      accountPrivacyVisibility = value.accountPrivacyVisibility.validate();
      reportTypes = value.reportTypes.validate();
      log('=======================');
      log('Report Types ========== ${reportTypes!.length}');
      appStore.setShowStoryHighlight(value.isHighlightStoryEnable.validate());
      appStore.suggestedUserList = value.suggestedUser.validate();
      appStore.suggestedGroupsList = value.suggestedGroups.validate();
      appStore.setShowWooCommerce(value.isWoocommerceEnable.validate());
      appStore.setWooCurrency(parseHtmlString(value.wooCurrency.validate()));
      appStore.setGiphyKey(parseHtmlString(value.giphyKey.validate()));
      appStore.setReactionsEnable(value.isReactionEnable.validate());
      appStore.setLMSEnable(value.isLMSEnable.validate());
      appStore.setCourseEnable(value.isCourseEnable.validate());
      appStore.setDisplayPostCount(value.displayPostCount.validate());
      appStore.setDisplayPostCommentsCount(
          value.displayPostCommentsCount.validate());
      appStore
          .setDisplayFriendRequestBtn(value.displayFriendRequestBtn.validate());
      appStore.setShopEnable(value.isShopEnable.validate());
    }).catchError(onError);
  }

  Future<void> getReactionsList() async {
    // await getReactions().then((value) {
    //   reactions = value;
    //   log('Reactions: ${reactions.length}');
    // }).catchError((e) {
    //   log('Error: ${e.toString()}');
    // });

    reactions = reactions;

    setState(() {});
  }

  Future<void> defaultReactionsList() async {
    // await getDefaultReaction().then((value) {
    //   if (value.isNotEmpty) {
    //     appStore.setDefaultReaction(value.first);
    //   } else {
    //     if (reactions.isNotEmpty) appStore.setDefaultReaction(reactions.first);
    //   }
    // }).catchError((e) {
    //   log('Error: ${e.toString()}');
    // });

    reactions = reactions;
    setState(() {});
  }

  Future<void> postIn() async {
    // await getPostInList().then((value) {
    //   if (value.isNotEmpty) {
    //     postInListDashboard = value;
    //   }
    // }).catchError(onError);

    //postInListDashboard = PostInListModel().listPostInList;
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DoublePressBackWidget(
      onWillPop: () {
        if (selectedIndex != 0) {
          selectedIndex = 0;
          tabController.index = 0;
          setState(() {});
          return Future.value(true);
        }
        return Future.value(true);
      },
      child: RefreshIndicator(
        onRefresh: () {
          if (tabController.index == 0) {
            LiveStream().emit(GetUserStories);
            LiveStream().emit(OnAddPost);
          } else if (tabController.index == 2) {
            LiveStream().emit(RefreshForumsFragment);
          } else if (tabController.index == 3) {
            LiveStream().emit(RefreshNotifications);
          } else if (tabController.index == 4) {
            LiveStream().emit(OnAddPostProfile);
          }

          return Future.value(true);
        },
        color: context.primaryColor,
        child: Scaffold(
          body: CustomScrollView(
            controller: _controller,
            slivers: <Widget>[
              Theme(
                data: ThemeData(useMaterial3: false),
                child: SliverAppBar(
                  forceElevated: true,
                  elevation: 0.5,
                  expandedHeight: 50,
                  floating: true,
                  pinned: true,
                  backgroundColor: context.scaffoldBackgroundColor,
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(APP_ICON, width: 60),
                      Text(
                        APP_NAME,
                        style: boldTextStyle(
                          color: context.primaryColor,
                          size: 24,
                          fontFamily: fontFamily,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          elevation: 0,
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          transitionAnimationController: _animationController,
                          builder: (context) {
                            return FractionallySizedBox(
                              heightFactor: 0.93,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 45,
                                    height: 5,
                                    //clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: Colors.white),
                                  ),
                                  8.height,
                                  Container(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    decoration: BoxDecoration(
                                      color: context.cardColor,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(16),
                                          topRight: Radius.circular(16)),
                                    ),
                                    child: RankingBottomSheetWidget(),
                                  ).expand(),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      icon: Image.asset(ic_ranking,
                          height: 30,
                          width: 30,
                          fit: BoxFit.fitWidth,
                          color: Colors.black),
                    ),
                    Obx(
                      () => IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onPressed: () {
                            showModalBottomSheet(
                              elevation: 0,
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              transitionAnimationController:
                                  _animationController,
                              builder: (context) {
                                return FractionallySizedBox(
                                  heightFactor: 0.93,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 45,
                                        height: 5,
                                        //clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            color: Colors.white),
                                      ),
                                      8.height,
                                      Container(
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        decoration: BoxDecoration(
                                          color: context.cardColor,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(16),
                                              topRight: Radius.circular(16)),
                                        ),
                                        child: UserDetailBottomSheetWidget(
                                          callback: () {
                                            //mPage = 1;
                                            //future = getPostList();
                                          },
                                        ),
                                      ).expand(),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          icon: userController.isLoggedIn.value
                              ? userController
                                      .user.value.avatarUrl.isEmptyOrNull
                                  ? Image.asset("assets/images/profile.gif",
                                          height: 60,
                                          width: 60,
                                          fit: BoxFit.cover)
                                      .cornerRadiusWithClipRRect(15)
                                  : Image.network(
                                          userController.user.value.avatarUrl!,
                                          height: 60,
                                          width: 60,
                                          fit: BoxFit.cover)
                                      .cornerRadiusWithClipRRect(15)
                              : Image.asset("assets/images/profile.gif",
                                      height: 60, width: 60, fit: BoxFit.cover)
                                  .cornerRadiusWithClipRRect(15)),
                    )
                  ],
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    return appFragments[tabController.index];
                  },
                  childCount: 1,
                ),
              ),
            ],
          ),
          bottomNavigationBar: TabBar(
            indicator: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: context.primaryColor,
                  width: 1.5,
                ),
              ),
            ),
            indicatorWeight: 4.0,
            controller: tabController,
            onTap: (val) async {
              selectedIndex = val;
              setState(() {});
            },
            tabs: [
              Tooltip(
                richMessage: TextSpan(
                    text: language.home,
                    style: secondaryTextStyle(color: Colors.white)),
                child: Image.asset(
                  selectedIndex == 0 ? ic_home_selected : ic_home,
                  height: 24,
                  width: 24,
                  fit: BoxFit.cover,
                  color:
                      selectedIndex == 0 ? context.primaryColor : Colors.black,
                ).paddingSymmetric(vertical: 11),
              ),
              Tooltip(
                richMessage: TextSpan(
                    text: language.searchHere,
                    style: secondaryTextStyle(color: Colors.white)),
                child: Image.asset(
                  selectedIndex == 1 ? ic_search_selected : ic_search,
                  height: 24,
                  width: 24,
                  fit: BoxFit.cover,
                  color:
                      selectedIndex == 1 ? context.primaryColor : Colors.black,
                ).paddingSymmetric(vertical: 11),
              ),
              Tooltip(
                richMessage: TextSpan(
                    text: language.forums,
                    style: secondaryTextStyle(color: Colors.white)),
                child: Image.asset(
                  selectedIndex == 2 ? ic_three_user_filled : ic_three_user,
                  height: 28,
                  width: 28,
                  fit: BoxFit.fill,
                  color:
                      selectedIndex == 2 ? context.primaryColor : Colors.black,
                ).paddingSymmetric(vertical: 9),
              ),
              Tooltip(
                richMessage: TextSpan(
                    text: language.notifications,
                    style: secondaryTextStyle(color: Colors.white)),
                child: selectedIndex == 3
                    ? Image.asset(ic_notification_selected,
                            height: 24, width: 24, fit: BoxFit.cover)
                        .paddingSymmetric(vertical: 11)
                    : Observer(
                        builder: (_) => Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              ic_notification,
                              height: 24,
                              width: 24,
                              fit: BoxFit.cover,
                              color: Colors.black,
                            ).paddingSymmetric(vertical: 11),
                            if (appStore.notificationCount != 0)
                              Positioned(
                                right: appStore.notificationCount
                                            .toString()
                                            .length >
                                        1
                                    ? -6
                                    : -4,
                                top: 3,
                                child: Container(
                                  padding: EdgeInsets.all(appStore
                                              .notificationCount
                                              .toString()
                                              .length >
                                          1
                                      ? 4
                                      : 6),
                                  decoration: BoxDecoration(
                                      color: appColorPrimary,
                                      shape: BoxShape.circle),
                                  child: Text(
                                    appStore.notificationCount.toString(),
                                    style: boldTextStyle(
                                        color: Colors.white,
                                        size: 10,
                                        weight: FontWeight.w700,
                                        letterSpacing: 0.7),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
              ),
              Tooltip(
                richMessage: TextSpan(
                    text: language.profile,
                    style: secondaryTextStyle(
                      color: Colors.white,
                    )),
                child: Image.asset(
                  selectedIndex == 4 ? ic_profile_filled : ic_profile,
                  height: 24,
                  width: 24,
                  fit: BoxFit.cover,
                  color:
                      selectedIndex == 4 ? context.primaryColor : Colors.black,
                ).paddingSymmetric(vertical: 11),
              ),
            ],
          ),
          floatingActionButton: tabController.index == 3
              ? FloatingActionButton(
                  onPressed: () {
                    //openWebPage(context, url: 'http://192.168.1.230/wp_themes/latest/socialv/atest');
                    showModalBottomSheet(
                      context: context,
                      elevation: 0,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      transitionAnimationController: _animationController,
                      builder: (context) {
                        return FractionallySizedBox(
                          heightFactor: 0.7,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 45,
                                height: 5,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.white),
                              ),
                              8.height,
                              Container(
                                padding: EdgeInsets.all(16),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: context.cardColor,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16)),
                                ),
                                child: LatestActivityComponent(),
                              ).expand(),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: cachedImage(ic_history,
                      width: 26,
                      height: 26,
                      fit: BoxFit.cover,
                      color: Colors.white),
                  backgroundColor: context.primaryColor,
                )
              : Offstage(),
        ),
      ),
    );
  }
}

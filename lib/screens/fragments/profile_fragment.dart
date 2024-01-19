import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/controllers/user_controller.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/members/member_detail_model.dart';
import 'package:socialv/screens/dashboard_screen.dart';
import 'package:socialv/screens/expertise_request/expertise_request/screens/expertise_request_screen.dart';
import 'package:socialv/screens/post/components/post_component.dart';
import 'package:socialv/screens/profile/components/profile_header_component.dart';
import 'package:socialv/screens/wallet/wallet_screen.dart';

import '../../models/enums/enums.dart';
import '../../models/posts/post.dart';
import '../../utils/app_constants.dart';
import '../gallery/screens/gallery_screen.dart';
import '../profile/screens/personal_info_screen.dart';
import '../profile/screens/verify_id_card_screen.dart';

class ProfileFragment extends StatefulWidget {
  final ScrollController? controller;

  const ProfileFragment({this.controller});

  @override
  State<ProfileFragment> createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> {
  MemberDetailModel _memberDetails = MemberDetailModel(
      id: '1',
      email: 'doantranduc01@gmail.com',
      name: 'Tran Duc',
      isUserVerified: true,
      friendsCount: 20,
      memberAvatarImage:
          'https://scontent.fsgn5-15.fna.fbcdn.net/v/t39.30808-6/353017930_6153557468098795_166607921767111563_n.jpg?_nc_cat=108&ccb=1-7&_nc_sid=5f2048&_nc_ohc=N5pLFu6oHkMAX_AbfkM&_nc_ht=scontent.fsgn5-15.fna&oh=00_AfDA4xqUbAjRrUVVTzz1PT0cybH1iGpdrZHodkqeD6fIFA&oe=654323AC',
      memberCoverImage:
          'https://scontent.fsgn5-8.fna.fbcdn.net/v/t39.30808-6/273370641_4708706809250542_6839313790496689506_n.jpg?_nc_cat=109&ccb=1-7&_nc_sid=5f2048&_nc_ohc=nyxL_IzJcsEAX-rRpUV&_nc_ht=scontent.fsgn5-8.fna&oh=00_AfCh2QxAAjNgvGHpRfuPKRk-VHX6sbBqrwkbzwobCck1NQ&oe=65435957',
      postCount: 10,
      groupsCount: 10,
      profileInfo: [
        ProfileInfo(id: 1, name: 'Detail', fields: [
          Field(id: 1, name: 'Name', value: 'Tran Duc'),
          Field(id: 2, name: 'Email', value: 'doantranduc01@gmail.com'),
          Field(id: 3, name: 'DOB', value: '28/05/2001'),
          Field(id: 4, name: 'Gender', value: 'Male'),
          Field(id: 5, name: 'Address', value: 'Binh Duong')
        ]),
        ProfileInfo(id: 2, name: 'Information', fields: [
          Field(id: 1, name: 'Name', value: 'Tran Duc'),
          Field(id: 2, name: 'Email', value: 'doantranduc01@gmail.com'),
          Field(id: 3, name: 'DOB', value: '28/05/2001'),
          Field(id: 4, name: 'Gender', value: 'Male'),
          Field(id: 5, name: 'Address', value: 'Binh Duong')
        ])
      ]);
  List<Post> _userPostList = [];
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  late Future<List<Post>> future;

  late UserController userController = Get.put(UserController());
  ScrollController _controller = ScrollController();
  int mPage = 1;
  bool mIsLastPage = false;
  bool isError = false;
  bool isLoading = false;
  bool isFavorites = false;

  @override
  void initState() {
    future = getUserPostList();
    userController.getCurrentUser();
    setStatusBarColor(Colors.transparent);
    super.initState();
    widget.controller?.addListener(() {
      if (selectedIndex == 4) {
        if (widget.controller?.position.pixels ==
            widget.controller?.position.maxScrollExtent) {
          if (!mIsLastPage) {
            mPage++;
            future = getUserPostList();
          }
        }
      }
    });
    getMemberDetails();
    LiveStream().on(OnAddPostProfile, (p0) {
      getMemberDetails();

      _userPostList.clear();
      mPage = 1;
      future = getUserPostList();
    });
  }

  Future<void> getMemberDetails() async {
    // appStore.setLoading(true);
    // await getMemberDetail(userId: appStore.loginUserId.toInt())
    //     .then((value) async {
    //   _memberDetails = value.first;
    //   setState(() {});

    //   appStore.setLoading(false);
    // }).catchError((e) {
    //   appStore.setLoading(false);
    //   toast(e.toString(), print: true);
    // });
    _memberDetails = _memberDetails;
  }

  Future<List<Post>> getUserPostList() async {
    // if (mPage == 1) _userPostList.clear();
    // isLoading = true;
    // appStore.setLoading(true);
    // setState(() {});
    // await getPost(type: isFavorites ? PostRequestType.favorites : PostRequestType.timeline, page: mPage).then((value) {
    //   mIsLastPage = value.length != PER_PAGE;
    //   isLoading = false;
    //   appStore.setLoading(false);
    //   _userPostList.addAll(value);
    //   setState(() {});
    // }).catchError((e) {
    //   isLoading = false;
    //   appStore.setLoading(false);
    //   isError = true;
    //   setState(() {});
    //   toast(e.toString(), print: true);
    // });
    // setState(() {});
    return _userPostList;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    LiveStream().dispose(OnAddPostProfile);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ProfileHeaderComponent(
                avatarUrl: userController.user.value.avatarUrl,
              ),
              userController.user.value.id != null
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RichText(
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            text: userController.user.value.name,
                            style: boldTextStyle(size: 20),
                            children: [
                              WidgetSpan(
                                child: Obx(() => userController
                                        .user.value.isVerified!
                                    ? Image.asset(ic_tick_filled,
                                        width: 20,
                                        height: 20,
                                        color: blueTickColor)
                                    : GestureDetector(
                                        child: Image.asset(
                                          'assets/icons/ic_cancel.png',
                                          width: 20,
                                          height: 20,
                                        ),
                                        onTap: () async {
                                          VerifyIdCardScreen().launch(context);
                                          toast('Please verify your account');
                                          // VerifyFaceScreen(
                                          //   frontIdMedia: PostMedia(),
                                          // ).launch(context);
                                        },
                                      ).paddingSymmetric(horizontal: 4)),
                              ),
                            ],
                          ),
                        ),
                        4.height,
                        Text(
                            userController.user.value.role
                                .map((e) => e.name)
                                .join(', '),
                            style: secondaryTextStyle(size: 12)),
                        TextIcon(
                          edgeInsets: EdgeInsets.zero,
                          spacing: 0,
                          onTap: () {
                            PersonalInfoScreen(
                                    profileInfo:
                                        _memberDetails.profileInfo.validate(),
                                    hasUserInfo: true)
                                .launch(context);
                          },
                          text: userController.user.value.userName,
                          textStyle: secondaryTextStyle(),
                          suffix: SizedBox(
                            height: 26,
                            width: 26,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                PersonalInfoScreen(
                                        profileInfo: _memberDetails.profileInfo
                                            .validate(),
                                        hasUserInfo: true)
                                    .launch(context);
                              },
                              icon: Icon(Icons.info_outline_rounded),
                              iconSize: 18,
                              splashRadius: 1,
                            ),
                          ),
                        ),
                        4.height,
                        if (userController.user.value.isVerified == false)
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color.fromARGB(94, 244, 67, 54)),
                                color: Color.fromARGB(24, 244, 67, 54),
                                borderRadius: BorderRadius.circular(8)),
                            child: Column(
                              children: [
                                TextIcon(
                                  text: 'Tài khoản của bạn chưa được xác thực',
                                  textStyle: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                  prefix: Icon(
                                    Icons.warning_amber_rounded,
                                    color: Colors.redAccent,
                                    size: 20,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    VerifyIdCardScreen().launch(context);
                                    toast('Please verify your account');
                                    // VerifyFaceScreen(
                                    //   frontIdMedia: PostMedia(),
                                    // ).launch(context);
                                  },
                                  child: Text(
                                    'Xác thực ngay',
                                    style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                )
                              ],
                            ),
                          )
                      ],
                    ).paddingAll(16)
                  : Text(
                      'Please login to view your profile!',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ).withHeight(30),
              Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('10', style: boldTextStyle(size: 18)),
                      4.height,
                      Text(language.expertiseRequestSent,
                          style: secondaryTextStyle(size: 12)),
                    ],
                  ).paddingSymmetric(vertical: 8).onTap(() {
                    widget.controller?.animateTo(
                        MediaQuery.of(context).size.height * 0.35,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.linear);
                  },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent).expand(),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            userController.user.value.totalPoint
                                .validate()
                                .toStringAsFixed(0)
                                .formatNumberWithComma(),
                            style: boldTextStyle(size: 18),
                          ),
                          10.width,
                          Icon(
                            Icons.info_outline_rounded,
                            size: 20,
                          ), // Add your icon here
                        ],
                      ),
                      4.height,
                      Text('Tổng điểm', style: secondaryTextStyle(size: 12)),
                    ],
                  ).paddingSymmetric(vertical: 8).onTap(() {
                    WalletScreen().launch(context);
                  },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent).expand(),
                ],
              ),
              TextIcon(
                onTap: () {
                  GalleryScreen(canEdit: true).launch(context);
                },
                text: language.viewGallery,
                textStyle: primaryTextStyle(color: appColorPrimary),
                prefix: Image.asset(ic_image,
                    width: 25, height: 25, color: appColorPrimary),
              ),
              if (userController.user.value.role.any((element) =>
                  element.name.toLowerCase() == Role.Member.name.toLowerCase()))
                Column(
                  children: [
                    10.height,
                    Container(
                      padding: EdgeInsets.only(left: 8, right: 8, top: 8),
                      child: Row(
                        children: [
                          Text(language.yourRequest,
                              style: boldTextStyle(
                                  color: context.primaryColor, size: 20)),
                        ],
                      ),
                    ),
                    10.height,
                    Column(
                      children: [
                        Divider(thickness: 1),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () => ExpertiseRequestScreen(
                                controller: _controller,
                                selectedIndex: 2,
                                selectedTab: 0,
                              ).launch(context),
                              child: Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                    ic_pending,
                                    height: 40,
                                    width: 40,
                                    fit: BoxFit.cover,
                                  ).paddingSymmetric(vertical: 11),
                                  Positioned(
                                    right: -8,
                                    top: -4,
                                    child: Container(
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                          color: appColorPrimary,
                                          shape: BoxShape.circle),
                                      child: Text(
                                        '3',
                                        style: boldTextStyle(
                                            color: Colors.white,
                                            size: 10,
                                            weight: FontWeight.w700,
                                            letterSpacing: 0.7),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom:
                                        -10, // Adjust the position as needed
                                    child: Container(
                                      width: 60,
                                      child: Text(
                                        'Chờ duyệt',
                                        style: boldTextStyle(
                                          color: Colors.black,
                                          size: 10,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () => ExpertiseRequestScreen(
                                controller: _controller,
                                selectedIndex: 3,
                                selectedTab: 1,
                              ).launch(context),
                              child: Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                    ic_user_pending,
                                    height: 40,
                                    width: 40,
                                    fit: BoxFit.cover,
                                  ).paddingSymmetric(vertical: 11),
                                  Positioned(
                                    right: -8,
                                    top: -4,
                                    child: Container(
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                          color: appColorPrimary,
                                          shape: BoxShape.circle),
                                      child: Text(
                                        '2',
                                        style: boldTextStyle(
                                            color: Colors.white,
                                            size: 10,
                                            weight: FontWeight.w700,
                                            letterSpacing: 0.7),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom:
                                        -17, // Adjust the position as needed
                                    child: Container(
                                      width: 60,
                                      child: Text(
                                        language
                                            .waitingForExpertExpertiseRequest,
                                        style: boldTextStyle(
                                          color: Colors.black,
                                          size: 10,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () => ExpertiseRequestScreen(
                                controller: _controller,
                                selectedIndex: 0,
                                selectedTab: 2,
                              ).launch(context),
                              child: Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                    ic_doing,
                                    height: 40,
                                    width: 40,
                                    fit: BoxFit.cover,
                                  ).paddingSymmetric(vertical: 11),
                                  Positioned(
                                    right: -8,
                                    top: -4,
                                    child: Container(
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                          color: appColorPrimary,
                                          shape: BoxShape.circle),
                                      child: Text(
                                        '2',
                                        style: boldTextStyle(
                                            color: Colors.white,
                                            size: 10,
                                            weight: FontWeight.w700,
                                            letterSpacing: 0.7),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom:
                                        -10, // Adjust the position as needed
                                    child: Text(
                                      language.doingExpertiseRequest,
                                      style: boldTextStyle(
                                        color: Colors.black,
                                        size: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () => ExpertiseRequestScreen(
                                controller: _controller,
                                selectedIndex: 1,
                                selectedTab: 3,
                              ).launch(context),
                              child: Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                    ic_approved,
                                    height: 40,
                                    width: 40,
                                    fit: BoxFit.cover,
                                  ).paddingSymmetric(vertical: 11),
                                  Positioned(
                                    right: -8,
                                    top: -4,
                                    child: Container(
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                          color: appColorPrimary,
                                          shape: BoxShape.circle),
                                      child: Text(
                                        '2',
                                        style: boldTextStyle(
                                            color: Colors.white,
                                            size: 10,
                                            weight: FontWeight.w700,
                                            letterSpacing: 0.7),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom:
                                        -10, // Adjust the position as needed
                                    child: Text(
                                      language.completedExpertiseRequest,
                                      style: boldTextStyle(
                                        color: Colors.black,
                                        size: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () => ExpertiseRequestScreen(
                                controller: _controller,
                                selectedIndex: 4,
                                selectedTab: 4,
                              ).launch(context),
                              child: Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                    ic_rejected,
                                    height: 40,
                                    width: 40,
                                    fit: BoxFit.cover,
                                  ).paddingSymmetric(vertical: 11),
                                  Positioned(
                                    right: -8,
                                    top: -4,
                                    child: Container(
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                          color: appColorPrimary,
                                          shape: BoxShape.circle),
                                      child: Text(
                                        '0',
                                        style: boldTextStyle(
                                            color: Colors.white,
                                            size: 10,
                                            weight: FontWeight.w700,
                                            letterSpacing: 0.7),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom:
                                        -10, // Adjust the position as needed
                                    child: Text(
                                      language.rejectedExpertiseRequest,
                                      style: boldTextStyle(
                                        color: Colors.black,
                                        size: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () => ExpertiseRequestScreen(
                                controller: _controller,
                                selectedIndex: 5,
                                selectedTab: 5,
                              ).launch(context),
                              child: Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                    ic_canceled,
                                    height: 40,
                                    width: 40,
                                    fit: BoxFit.cover,
                                  ).paddingSymmetric(vertical: 11),
                                  Positioned(
                                    right: -8,
                                    top: -4,
                                    child: Container(
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                          color: appColorPrimary,
                                          shape: BoxShape.circle),
                                      child: Text(
                                        '2',
                                        style: boldTextStyle(
                                            color: Colors.white,
                                            size: 10,
                                            weight: FontWeight.w700,
                                            letterSpacing: 0.7),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom:
                                        -10, // Adjust the position as needed
                                    child: Text(
                                      'Đã hủy',
                                      style: boldTextStyle(
                                        color: Colors.black,
                                        size: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        10.height,
                        Divider(
                          thickness: 1,
                        )
                      ],
                    )
                  ],
                ),
              if (userController.user.value.role.any((element) =>
                  element.name.toLowerCase() ==
                  Role.Contributor.name.toLowerCase()))
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(language.posts,
                            style: boldTextStyle(
                                color: context.primaryColor, size: 20)),
                      ],
                    ).paddingSymmetric(horizontal: 8),
                    FutureBuilder<List<Post>>(
                      future: future,
                      builder: (ctx, snap) {
                        if (snap.hasError) {
                          return NoDataWidget(
                            imageWidget: NoDataLottieWidget(),
                            title: isError
                                ? language.somethingWentWrong
                                : language.noDataFound,
                            onRetry: () {
                              isError = false;
                              LiveStream().emit(OnAddPostProfile);
                            },
                            retryText: '   ${language.clickToRefresh}   ',
                          ).center().paddingBottom(20);
                        }

                        if (snap.hasData) {
                          if (snap.data.validate().isEmpty) {
                            return appStore.isLoading
                                ? Offstage()
                                : NoDataWidget(
                                    imageWidget: NoDataLottieWidget(),
                                    title: language.noDataFound,
                                    retryText:
                                        '   ${language.clickToRefresh}   ',
                                  ).center().paddingBottom(20);
                          } else {
                            return Stack(
                              children: [
                                AnimatedListView(
                                  padding: EdgeInsets.only(
                                      left: 8, right: 8, bottom: 50, top: 8),
                                  itemCount: _userPostList.length,
                                  slideConfiguration: SlideConfiguration(
                                      delay: Duration(milliseconds: 80),
                                      verticalOffset: 300),
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return PostComponent(
                                      post: _userPostList[index],
                                      callback: () {
                                        isLoading = true;
                                        mPage = 1;
                                        getMemberDetails();
                                        future = getUserPostList();
                                      },
                                    );
                                  },
                                ),
                                if (mPage != 1 && isLoading)
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    left: 0,
                                    child: ThreeBounceLoadingWidget(),
                                  )
                              ],
                            );
                          }
                        }
                        return ThreeBounceLoadingWidget().paddingTop(16);
                      },
                    ),
                  ],
                )
            ],
          ),
        )
      ],
    );
  }
}

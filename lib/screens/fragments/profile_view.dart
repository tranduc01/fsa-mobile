import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/controllers/user_controller.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/members/member_detail_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/dashboard_screen.dart';
import 'package:socialv/screens/profile/components/profile_header_component.dart';
import '../../models/posts/post.dart';
import '../../utils/app_constants.dart';
import '../profile/screens/personal_info_screen.dart';
import '../profile/screens/verify_id_card_screen.dart';

class ProfileFragmentView extends StatefulWidget {
  final ScrollController? controller;

  const ProfileFragmentView({this.controller});

  @override
  State<ProfileFragmentView> createState() => _ProfileFragmentViewState();
}

class _ProfileFragmentViewState extends State<ProfileFragmentView> {
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
    userController.getUserById(userController.user.value.id ?? '');
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
      getCategoryList();

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
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() => ProfileHeaderComponent(
                    avatarUrl: userController.user.value.avatarUrl,
                  )),
              userController.isLoggedIn.value
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Obx(() {
                          return RichText(
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
                                            VerifyIdCardScreen()
                                                .launch(context);
                                            toast('Please verify your account');
                                            // VerifyFaceScreen(
                                            //   frontIdMedia: PostMedia(),
                                            // ).launch(context);
                                          },
                                        ).paddingSymmetric(horizontal: 4)),
                                ),
                              ],
                            ),
                          );
                        }),
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
                      ],
                    ).paddingAll(16)
                  : Text(
                      'Please login to view your profile!',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ).withHeight(30),
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  "Collection",
                  style: TextStyle(fontFamily: "Roboto", fontSize: 20),
                ).paddingAll(16),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 1.7,
                width: MediaQuery.of(context).size.width,
                child: GridView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount:
                      yourImageList.length, // Replace with your list of images
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of items in a row
                    crossAxisSpacing: 16, // Spacing between items horizontally
                    mainAxisSpacing: 16, // Spacing between items vertically
                  ),
                  itemBuilder: (context, index) {
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          yourImageList[
                              index], // Replace with your list of images
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Text(
                            'Image ${index + 1}', // Replace this with your image name
                            style: TextStyle(
                              backgroundColor: Colors.black54,
                              color: Colors.white,
                              fontFamily: "Roboto",
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          LoadingWidget().center().visible(appStore.isLoading),
        ],
      ),
    );
  }

  List<String> yourImageList = [
    'https://cdn.tgdd.vn/Files/2021/07/24/1370576/hoa-lan-tim-dac-diem-y-nghia-va-cach-trong-hoa-no-dep-202107242028075526.jpg',
    'https://nongnghiepdep.com/wp-content/uploads/2023/06/ten-cua-cac-loai-hoa-phong-lan-3.jpg',
    'https://www.tnmt.edu.vn/wp-content/uploads/2023/11/hinh-nen-hoa-lan-1-1200x675.jpg',
    'https://hoasaigon.com.vn/kcfinder/upload2018//images/hinh-anh-hoa-lan-ho-diep-1.jpg',
    // Add more image URLs as needed
  ];
}

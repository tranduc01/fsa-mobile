import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/controllers/user_controller.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/common_models.dart';
import 'package:socialv/screens/profile/screens/edit_profile_screen.dart';
import 'package:socialv/utils/app_constants.dart';

import '../../auth/screens/sign_in_screen.dart';

class UserDetailBottomSheetWidget extends StatefulWidget {
  final VoidCallback? callback;

  UserDetailBottomSheetWidget({this.callback});

  @override
  State<UserDetailBottomSheetWidget> createState() =>
      _UserDetailBottomSheetWidgetState();
}

class _UserDetailBottomSheetWidgetState
    extends State<UserDetailBottomSheetWidget> {
  List<DrawerModel> options = getDrawerOptions();
  final UserController userController = Get.find();

  int selectedIndex = -1;
  bool isLoading = false;
  bool backToHome = true;

  @override
  void initState() {
    super.initState();
    if (appStore.isLoading) {
      isLoading = true;
      appStore.setLoading(false);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    if (isLoading && backToHome) widget.callback?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          Column(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(() => userController.user.value.id != null
                        ? Row(
                            children: [
                              userController.user.value.avatarUrl.isEmptyOrNull
                                  ? Image.asset("assets/images/profile.png",
                                          height: 62,
                                          width: 62,
                                          fit: BoxFit.cover)
                                      .cornerRadiusWithClipRRect(100)
                                  : Image.network(
                                          userController.user.value.avatarUrl!,
                                          height: 62,
                                          width: 62,
                                          fit: BoxFit.cover)
                                      .cornerRadiusWithClipRRect(100),
                              //cachedImage(appStore.loginAvatarUrl, height: 62, width: 62, fit: BoxFit.cover).cornerRadiusWithClipRRect(100),
                              16.width,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(userController.user.value.name!,
                                      style: boldTextStyle(size: 18)),
                                  8.height,
                                  Text(userController.user.value.userName!,
                                      style: secondaryTextStyle(),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1),
                                ],
                              ).expand(),
                              IconButton(
                                icon: Image.asset(ic_edit,
                                    height: 16,
                                    width: 16,
                                    fit: BoxFit.cover,
                                    color: Colors.black),
                                onPressed: () {
                                  finish(context);
                                  EditProfileScreen().launch(context);
                                },
                              ),
                            ],
                          ).paddingOnly(left: 16, right: 8, bottom: 16, top: 16)
                        : InkWell(
                            child: Row(
                              children: [
                                Image.asset("assets/images/profile.png",
                                        height: 62,
                                        width: 62,
                                        fit: BoxFit.cover)
                                    .cornerRadiusWithClipRRect(100),
                                //cachedImage(appStore.loginAvatarUrl, height: 62, width: 62, fit: BoxFit.cover).cornerRadiusWithClipRRect(100),
                                16.width,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Log in',
                                        style: boldTextStyle(size: 18)),
                                    8.height,
                                    Text('Tap here to login',
                                        style: secondaryTextStyle(),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1),
                                  ],
                                ).expand(),
                                Icon(Icons.login,
                                    size: 25, color: Colors.black),
                                20.width
                              ],
                            ).paddingOnly(
                                left: 16, right: 8, bottom: 16, top: 16),
                            onTap: () {
                              SignInScreen().launch(context, isNewTask: false);
                            },
                          )),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: options.map((e) {
                        int index = options.indexOf(e);

                        return SettingItemWidget(
                          decoration: BoxDecoration(
                              color: selectedIndex == index
                                  ? context.primaryColor.withAlpha(30)
                                  : context.cardColor),
                          title: e.title.validate(),
                          titleTextStyle: boldTextStyle(size: 14),
                          leading: Image.asset(e.image.validate(),
                              height: 22,
                              width: 22,
                              fit: BoxFit.fill,
                              color: appColorPrimary),
                          trailing: e.isNew
                              ? Container(
                                  decoration: BoxDecoration(
                                      color: appGreenColor.withAlpha(30),
                                      borderRadius: radius()),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 10),
                                  child: Text(language.lblNew,
                                      style: boldTextStyle(
                                          color: appGreenColor, size: 12)),
                                )
                              : Offstage(),
                          onTap: () async {
                            selectedIndex = index;
                            setState(() {});

                            if (e.attachedScreen != null) {
                              backToHome = false;
                              finish(context);
                              e.attachedScreen.launch(context);
                            } else {
                              finish(context);
                            }
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ).expand(),
              Column(
                children: [
                  // VersionInfoWidget(prefixText: 'v'),
                  // 16.height,
                  userController.user.value.id != null
                      ? TextButton(
                          onPressed: () {
                            showConfirmDialogCustom(
                              context,
                              primaryColor: appColorPrimary,
                              title: language.logoutConfirmation,
                              onAccept: (s) {
                                userController.logout();
                              },
                            );
                          },
                          child: Text(language.logout,
                              style:
                                  boldTextStyle(color: context.primaryColor)),
                        )
                      : Offstage(),
                  20.height,
                ],
              ),
            ],
          ),
          LoadingWidget().center().visible(appStore.isLoading)
        ],
      ),
    );
  }
}

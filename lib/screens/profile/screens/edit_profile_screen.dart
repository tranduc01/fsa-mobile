import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/file_picker_dialog_component.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/controllers/user_controller.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/members/profile_field_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/common/loading_dialog.dart';
import 'package:socialv/screens/profile/components/expansion_body.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String avatarUrl = appStore.loginAvatarUrl;
  UserController userController = Get.find();

  List<ProfileFieldModel> fieldList = [
    ProfileFieldModel(
        fields: [Field(id: 1, isRequired: true, label: 'Email', type: 'text')],
        groupId: 1,
        groupName: 'Personal Information'),
  ];

  TextEditingController nameCont = TextEditingController();

  FocusNode name = FocusNode();
  FocusNode mentionName = FocusNode();
  FocusNode dOB = FocusNode();
  FocusNode location = FocusNode();
  FocusNode bio = FocusNode();

  File? avatarImage;

  @override
  void initState() {
    setStatusBarColor(Colors.transparent);
    super.initState();
    afterBuildCreated(() {
      init();
    });
  }

  Future<void> init() async {
    getFiledList();

    avatarUrl = userController.user.value.avatarUrl.validate();
    nameCont.text = userController.user.value.name.validate();
    nameCont.selection =
        TextSelection.fromPosition(TextPosition(offset: nameCont.text.length));
    setState(() {});
  }

  Future<void> getFiledList() async {
    //appStore.setLoading(true);
    isDetailChange = false;

    fieldList = fieldList;
    setState(() {});
  }

  void update() {
    ifNotTester(() async {
      if (nameCont.text.isNotEmpty && nameCont.text != appStore.loginFullName) {
        appStore.setLoading(true);

        Map request = {"name": nameCont.text};

        await updateLoginUser(request: request).then((value) {
          appStore.setLoginFullName(value.name.validate());
          toast(language.profileUpdatedSuccessfully, print: true);

          if (avatarImage == null) {
            appStore.setLoading(false);
            finish(context, true);
          }
        }).catchError((e) {
          appStore.setLoading(false);
          toast(e.toString(), print: true);
        });
      }

      if (avatarImage != null) {
        appStore.setLoading(true);
        await attachMemberImage(id: appStore.loginUserId, image: avatarImage)
            .then((value) {
          init();
        }).catchError((e) {
          appStore.setLoading(false);
          toast(language.somethingWentWrong);
        });
      }
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        finish(context, true);
        return Future.value(true);
      },
      child: Observer(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: Text(language.editProfile, style: boldTextStyle(size: 20)),
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                finish(context, true);
              },
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return LoadingDialog();
                      });
                  Future.delayed(Duration(seconds: 5), () {
                    Navigator.pop(context);
                  });
                },
                child: Text(
                  language.update.capitalizeFirstLetter(),
                  style: secondaryTextStyle(
                      color: context.primaryColor,
                      weight: FontWeight.bold,
                      fontFamily: 'Roboto',
                      size: 18),
                ),
              ).paddingSymmetric(vertical: 8, horizontal: 8),
            ],
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Image.asset(
                            'assets/images/cover.jpg',
                            width: MediaQuery.of(context).size.width,
                            height: 220,
                            fit: BoxFit.cover,
                          ).cornerRadiusWithClipRRectOnly(
                              topLeft: defaultRadius.toInt(),
                              topRight: defaultRadius.toInt()),
                          Positioned(
                            bottom: 0,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.white, width: 2),
                                      shape: BoxShape.circle),
                                  child: avatarImage == null
                                      ? cachedImage(
                                          avatarUrl,
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.cover,
                                        ).cornerRadiusWithClipRRect(100)
                                      : Image.file(
                                          File(avatarImage!.path.validate()),
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.cover,
                                        ).cornerRadiusWithClipRRect(100),
                                ),
                                Positioned(
                                  bottom: -4,
                                  right: -6,
                                  child: GestureDetector(
                                    onTap: () async {
                                      if (!appStore.isLoading) {
                                        FileTypes? file = await showInDialog(
                                          context,
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 16),
                                          title: Text(language.chooseAnAction,
                                              style: boldTextStyle()),
                                          builder: (p0) {
                                            return FilePickerDialog(
                                                isSelected: true);
                                          },
                                        );

                                        if (file != null) {
                                          // avatarImage = await getImageSource(
                                          //     isCamera: file == FileTypes.CAMERA
                                          //         ? true
                                          //         : false);
                                          setState(() {});
                                          appStore.setLoading(false);
                                        }
                                      }
                                    },
                                    child: Container(
                                      clipBehavior: Clip.antiAlias,
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: appColorPrimary,
                                          shape: BoxShape.circle),
                                      child: Icon(Icons.edit_outlined,
                                          color: Colors.white, size: 18),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      height: 280,
                    ),
                    50.height,
                    AppTextField(
                      enabled: !appStore.isLoading,
                      controller: nameCont,
                      focus: name,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      textFieldType: TextFieldType.NAME,
                      textStyle: boldTextStyle(),
                      decoration: inputDecoration(
                        context,
                        label: language.fullName,
                        labelStyle: secondaryTextStyle(weight: FontWeight.w600),
                      ),
                    ).paddingSymmetric(horizontal: 16),
                    if (fieldList.isNotEmpty)
                      Text(
                        '${language.profile} ${language.settings}',
                        style: boldTextStyle(color: context.primaryColor),
                      ).paddingAll(16),
                    if (fieldList.isNotEmpty)
                      Theme(
                        data: Theme.of(context).copyWith(useMaterial3: false),
                        child: ExpansionPanelList.radio(
                          elevation: 0,
                          children: fieldList.map<ExpansionPanelRadio>(
                            (e) {
                              return ExpansionPanelRadio(
                                value: e.groupId.validate(),
                                canTapOnHeader: true,
                                backgroundColor: context.cardColor,
                                headerBuilder:
                                    (BuildContext context, bool isExpanded) {
                                  if (isExpanded) {
                                    group = e;
                                  }
                                  return ListTile(
                                    title: Text(
                                      e.groupName.validate(),
                                      style: primaryTextStyle(
                                          color: isExpanded
                                              ? context.primaryColor
                                              : Colors.black),
                                    ),
                                  );
                                },
                                body: ExpansionBody(
                                  group: e,
                                  callback: () {
                                    appStore.setLoading(true);
                                    getFiledList();
                                  },
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    60.height,
                  ],
                ),
              ),
              LoadingWidget().visible(appStore.isLoading).center(),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/controllers/user_controller.dart';
import 'package:socialv/models/withdraw/withdraw.dart';
import 'package:socialv/screens/subscription/screens/topup_package_screen.dart';
import 'package:socialv/utils/app_constants.dart';

import '../../components/loading_widget.dart';
import '../../components/no_data_lottie_widget.dart';
import '../../controllers/withdraw_controller.dart';
import '../../main.dart';
import '../../models/enums/enums.dart';
import '../../models/package/bank.dart';
import '../common/fail_dialog.dart';
import '../common/loading_dialog.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletState();
}

class _WalletState extends State<WalletScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;

  final withdrawFormKey = GlobalKey<FormState>();
  final informationFormKey = GlobalKey<FormState>();
  TextEditingController amountController = TextEditingController();
  TextEditingController moneyController = TextEditingController();
  TextEditingController bankNumCont = TextEditingController();
  TextEditingController bankAccountName = TextEditingController();
  TextEditingController bankName = TextEditingController();
  TextEditingController bankCode = TextEditingController();
  TextEditingController bankShortName = TextEditingController();
  TextEditingController note = TextEditingController();

  final storage = new FlutterSecureStorage();
  late UserController userController = Get.find();
  late WithdrawController withdrawController = Get.put(WithdrawController());

  final List<Color> colorList = [
    Colors.blue.withOpacity(0.5),
    Colors.orange.withOpacity(0.5),
    Colors.green.withOpacity(0.5),
    Colors.red.withOpacity(0.5),
    Colors.grey.withOpacity(0.5)
  ];

  @override
  void initState() {
    _animationController = BottomSheet.createAnimationController(this);
    _animationController.duration = const Duration(milliseconds: 500);
    _animationController.drive(CurveTween(curve: Curves.easeOutQuad));
    super.initState();
  }

  Future<List<Bank>> getBanks() async {
    String jsonString = await rootBundle.loadString('banks.json');
    List<dynamic> jsonData = json.decode(jsonString);
    List<Bank> banks = jsonData.map((json) => Bank.fromJson(json)).toList();
    return banks;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.scaffoldBackgroundColor,
        title: Text('My Wallet', style: boldTextStyle(size: 20)),
        elevation: 0,
        centerTitle: true,
      ),
      body: Obx(
        () => SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Container(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.25,
                  decoration: BoxDecoration(
                      borderRadius: radius(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[
                          Color(0xFFa18cd1),
                          Color(0xFFfbc2eb),
                        ],
                      )),
                  child: Column(children: [
                    30.height,
                    Text(
                      'My Balance',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(92, 0, 0, 0)),
                    ),
                    5.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.token_outlined,
                          size: 30,
                        ),
                        Text(
                          userController.user.value.totalPoint!
                              .toStringAsFixed(0)
                              .formatNumberWithComma(),
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 27,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    5.height,
                    Text(
                      'Points',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(141, 0, 0, 0)),
                    ),
                    30.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all(EdgeInsets.all(8)),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            side: MaterialStateProperty.all(
                              BorderSide(
                                  color: const Color.fromARGB(129, 0, 0, 0),
                                  width: 2),
                            ),
                          ),
                          onPressed: () {
                            TopupPackageScreen().launch(context);
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                ic_wallet_in,
                                width: 40,
                                height: 40,
                              ),
                              10.width,
                              Text(
                                'Top Up',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Roboto'),
                              )
                            ],
                          ),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all(EdgeInsets.all(8)),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            side: MaterialStateProperty.all(
                              BorderSide(
                                  color: const Color.fromARGB(129, 0, 0, 0),
                                  width: 2),
                            ),
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              elevation: 0,
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              transitionAnimationController:
                                  _animationController,
                              builder: (context) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: FractionallySizedBox(
                                    heightFactor: 0.5,
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
                                          padding: EdgeInsets.all(10),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          decoration: BoxDecoration(
                                            color: context.cardColor,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(16),
                                                topRight: Radius.circular(16)),
                                          ),
                                          child: PopScope(
                                            onPopInvoked: (didPop) {
                                              if (didPop) {
                                                amountController.clear();
                                                moneyController.clear();
                                              }
                                            },
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'Withdraw Request',
                                                    style: TextStyle(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: 'Roboto'),
                                                  ),
                                                  20.height,
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Enter Points',
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  'Roboto'),
                                                        ),
                                                        Text(
                                                          '(1 point = 1,000 VNĐ)',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.5),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  'Roboto'),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  10.height,
                                                  Form(
                                                    key: withdrawFormKey,
                                                    child: Column(
                                                      children: [
                                                        TextFormField(
                                                          controller:
                                                              amountController,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          decoration:
                                                              InputDecoration(
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                width: 3,
                                                                color: Color(
                                                                    0xFFB4D4FF),
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50.0),
                                                            ),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                width: 3,
                                                                color: Color(
                                                                    0xFFB4D4FF),
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50.0),
                                                            ),
                                                            suffixIcon: Icon(
                                                              Icons
                                                                  .token_outlined,
                                                              color:
                                                                  Colors.black,
                                                              size: 30,
                                                            ),
                                                          ),
                                                          validator: (value) {
                                                            if (value!
                                                                .isEmpty) {
                                                              return 'Please enter amount';
                                                            }
                                                            if (int.parse(
                                                                    value) >
                                                                userController
                                                                    .user
                                                                    .value
                                                                    .totalPoint!) {
                                                              return 'Not enough points';
                                                            }
                                                            return null;
                                                          },
                                                          onChanged: (value) {
                                                            if (value
                                                                .isNotEmpty) {
                                                              moneyController
                                                                  .text = (int.parse(
                                                                          value) *
                                                                      1000)
                                                                  .toString()
                                                                  .formatNumberWithComma();
                                                              setState(() {});
                                                            } else {
                                                              moneyController
                                                                  .text = '';
                                                              setState(() {});
                                                            }
                                                          },
                                                        ),
                                                        20.height,
                                                        Icon(
                                                          Icons.arrow_downward,
                                                          size: 30,
                                                        ),
                                                        20.height,
                                                        TextFormField(
                                                          controller:
                                                              moneyController,
                                                          readOnly: true,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          decoration:
                                                              InputDecoration(
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                width: 3,
                                                                color: Color(
                                                                    0xFFB4D4FF),
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50.0),
                                                            ),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                width: 3,
                                                                color: Color(
                                                                    0xFFB4D4FF),
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50.0),
                                                            ),
                                                            suffixIcon: Icon(
                                                              Icons
                                                                  .currency_exchange_outlined,
                                                              color:
                                                                  Colors.black,
                                                              size: 30,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  30.height,
                                                  appButton(
                                                      text: 'Next',
                                                      context: context,
                                                      onTap: () async {
                                                        if (withdrawFormKey
                                                            .currentState!
                                                            .validate()) {
                                                          withdrawFormKey
                                                              .currentState!
                                                              .save();
                                                          hideKeyboard(context);
                                                          var banks =
                                                              await getBanks();
                                                          showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return PopScope(
                                                                onPopInvoked:
                                                                    (didPop) {
                                                                  if (didPop) {
                                                                    bankNumCont
                                                                        .clear();
                                                                    bankAccountName
                                                                        .clear();
                                                                    bankName
                                                                        .clear();
                                                                    bankCode
                                                                        .clear();
                                                                    bankShortName
                                                                        .clear();
                                                                    note.clear();
                                                                  }
                                                                },
                                                                child:
                                                                    AlertDialog(
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                  ),
                                                                  title: Text(
                                                                    'Withdraw Request Information',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            22,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontFamily:
                                                                            'Roboto'),
                                                                  ),
                                                                  content:
                                                                      SingleChildScrollView(
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Form(
                                                                          key:
                                                                              informationFormKey,
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              TextFormField(
                                                                                controller: bankNumCont,
                                                                                autofocus: false,
                                                                                maxLines: 1,
                                                                                decoration: InputDecoration(
                                                                                  enabledBorder: OutlineInputBorder(
                                                                                    borderSide: BorderSide(
                                                                                      width: 3,
                                                                                      color: Color(0xFFB4D4FF),
                                                                                    ),
                                                                                    borderRadius: BorderRadius.circular(20.0),
                                                                                  ),
                                                                                  focusedBorder: OutlineInputBorder(
                                                                                    borderSide: BorderSide(
                                                                                      width: 3,
                                                                                      color: Color(0xFFB4D4FF),
                                                                                    ),
                                                                                    borderRadius: BorderRadius.circular(20.0),
                                                                                  ),
                                                                                  hintText: 'Bank account number',
                                                                                  hintStyle: TextStyle(
                                                                                    fontSize: 16,
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontFamily: 'Roboto',
                                                                                  ),
                                                                                  label: Text(
                                                                                    'Bank account number',
                                                                                    style: TextStyle(
                                                                                      fontSize: 16,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontFamily: 'Roboto',
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                validator: (value) {
                                                                                  if (value!.isEmpty) {
                                                                                    return 'Please enter bank account number';
                                                                                  }
                                                                                  return null;
                                                                                },
                                                                              ),
                                                                              20.height,
                                                                              TextFormField(
                                                                                controller: bankAccountName,
                                                                                autofocus: false,
                                                                                maxLines: 1,
                                                                                decoration: InputDecoration(
                                                                                  enabledBorder: OutlineInputBorder(
                                                                                    borderSide: BorderSide(
                                                                                      width: 3,
                                                                                      color: Color(0xFFB4D4FF),
                                                                                    ),
                                                                                    borderRadius: BorderRadius.circular(20.0),
                                                                                  ),
                                                                                  focusedBorder: OutlineInputBorder(
                                                                                    borderSide: BorderSide(
                                                                                      width: 3,
                                                                                      color: Color(0xFFB4D4FF),
                                                                                    ),
                                                                                    borderRadius: BorderRadius.circular(20.0),
                                                                                  ),
                                                                                  hintText: 'Bank account name',
                                                                                  hintStyle: TextStyle(
                                                                                    fontSize: 16,
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontFamily: 'Roboto',
                                                                                  ),
                                                                                  label: Text(
                                                                                    'Bank account name',
                                                                                    style: TextStyle(
                                                                                      fontSize: 16,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontFamily: 'Roboto',
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                validator: (value) {
                                                                                  if (value!.isEmpty) {
                                                                                    return 'Please enter bank account name';
                                                                                  }
                                                                                  return null;
                                                                                },
                                                                              ),
                                                                              20.height,
                                                                              DropdownSearch<Bank>(
                                                                                popupProps: PopupProps.modalBottomSheet(
                                                                                  showSearchBox: true,
                                                                                  itemBuilder: (context, item, isSelected) {
                                                                                    return ListTile(
                                                                                      title: Text(item.code!),
                                                                                      subtitle: Text(item.shortName!),
                                                                                      leading: Image.network(item.logo!, width: 50, height: 50),
                                                                                    );
                                                                                  },
                                                                                ),
                                                                                items: banks,
                                                                                dropdownDecoratorProps: DropDownDecoratorProps(
                                                                                  dropdownSearchDecoration: InputDecoration(
                                                                                    enabledBorder: OutlineInputBorder(
                                                                                      borderSide: BorderSide(
                                                                                        width: 3,
                                                                                        color: Color(0xFFB4D4FF),
                                                                                      ),
                                                                                      borderRadius: BorderRadius.circular(20.0),
                                                                                    ),
                                                                                    focusedBorder: OutlineInputBorder(
                                                                                      borderSide: BorderSide(
                                                                                        width: 3,
                                                                                        color: Color(0xFFB4D4FF),
                                                                                      ),
                                                                                      borderRadius: BorderRadius.circular(20.0),
                                                                                    ),
                                                                                    hintText: 'Select bank',
                                                                                    hintStyle: TextStyle(
                                                                                      fontSize: 16,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontFamily: 'Roboto',
                                                                                    ),
                                                                                    label: Text(
                                                                                      'Bank',
                                                                                      style: TextStyle(
                                                                                        fontSize: 16,
                                                                                        fontWeight: FontWeight.w500,
                                                                                        fontFamily: 'Roboto',
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                validator: (value) {
                                                                                  if (value == null) {
                                                                                    return 'Please select a bank';
                                                                                  }
                                                                                  return null;
                                                                                },
                                                                                onChanged: (value) {
                                                                                  bankName.text = value!.name!;
                                                                                  bankCode.text = value.code!;
                                                                                  bankShortName.text = value.shortName!;
                                                                                  setState(() {});
                                                                                },
                                                                              ),
                                                                              20.height,
                                                                              TextFormField(
                                                                                readOnly: true,
                                                                                controller: bankName,
                                                                                autofocus: false,
                                                                                maxLines: 2,
                                                                                decoration: InputDecoration(
                                                                                  enabledBorder: OutlineInputBorder(
                                                                                    borderSide: BorderSide(
                                                                                      width: 3,
                                                                                      color: Color(0xFFB4D4FF),
                                                                                    ),
                                                                                    borderRadius: BorderRadius.circular(20.0),
                                                                                  ),
                                                                                  focusedBorder: OutlineInputBorder(
                                                                                    borderSide: BorderSide(
                                                                                      width: 3,
                                                                                      color: Color(0xFFB4D4FF),
                                                                                    ),
                                                                                    borderRadius: BorderRadius.circular(20.0),
                                                                                  ),
                                                                                  hintText: 'Bank name',
                                                                                  hintStyle: TextStyle(
                                                                                    fontSize: 16,
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontFamily: 'Roboto',
                                                                                  ),
                                                                                  label: Text(
                                                                                    'Bank name',
                                                                                    style: TextStyle(
                                                                                      fontSize: 16,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontFamily: 'Roboto',
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              20.height,
                                                                              TextFormField(
                                                                                controller: note,
                                                                                autofocus: false,
                                                                                maxLines: 3,
                                                                                decoration: InputDecoration(
                                                                                  enabledBorder: OutlineInputBorder(
                                                                                    borderSide: BorderSide(
                                                                                      width: 3,
                                                                                      color: Color(0xFFB4D4FF),
                                                                                    ),
                                                                                    borderRadius: BorderRadius.circular(20.0),
                                                                                  ),
                                                                                  focusedBorder: OutlineInputBorder(
                                                                                    borderSide: BorderSide(
                                                                                      width: 3,
                                                                                      color: Color(0xFFB4D4FF),
                                                                                    ),
                                                                                    borderRadius: BorderRadius.circular(20.0),
                                                                                  ),
                                                                                  hintText: 'Note',
                                                                                  hintStyle: TextStyle(
                                                                                    fontSize: 16,
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontFamily: 'Roboto',
                                                                                  ),
                                                                                  label: Text(
                                                                                    'Note',
                                                                                    style: TextStyle(
                                                                                      fontSize: 16,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontFamily: 'Roboto',
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  actions: [
                                                                    appButton(
                                                                        text:
                                                                            'Create Withdraw Request',
                                                                        onTap:
                                                                            () {
                                                                          if (informationFormKey
                                                                              .currentState!
                                                                              .validate()) {
                                                                            informationFormKey.currentState!.save();
                                                                            hideKeyboard(context);
                                                                            showConfirmDialogCustom(
                                                                              context,
                                                                              title: 'Are you sure you want to withdraw from ' + amountController.text.formatNumberWithComma() + ' points to ' + moneyController.text.formatNumberWithComma() + ' ?',
                                                                              onAccept: (p0) async {
                                                                                showDialog(
                                                                                    context: context,
                                                                                    barrierDismissible: false,
                                                                                    builder: (context) {
                                                                                      return LoadingDialog();
                                                                                    });

                                                                                await withdrawController.createWithdrawRequest(int.parse(amountController.text), bankNumCont.text, bankAccountName.text, bankName.text, bankCode.text, bankShortName.text, note.text);
                                                                                if (withdrawController.isCreateSuccess.value) {
                                                                                  Navigator.pop(context);
                                                                                  Navigator.pop(context);
                                                                                  Navigator.pop(context);
                                                                                  String? jwt = await storage.read(key: 'jwt');
                                                                                  await userController.getUserById(JwtDecoder.decode(jwt!)!['uid']);
                                                                                  await withdrawController.fetchWithdraws();
                                                                                  toast('Withdraw Request Create Successfully');
                                                                                } else {
                                                                                  Navigator.pop(context);
                                                                                  showDialog(
                                                                                    context: context,
                                                                                    barrierDismissible: false,
                                                                                    builder: (context) {
                                                                                      return FailDialog(text: 'Create Failed');
                                                                                    },
                                                                                  );
                                                                                }
                                                                              },
                                                                            );
                                                                          }
                                                                        },
                                                                        context:
                                                                            context)
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        }
                                                      })
                                                ],
                                              ),
                                            ),
                                          ),
                                        ).expand(),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                ic_wallet_out,
                                width: 40,
                                height: 40,
                              ),
                              10.width,
                              Text(
                                'Withdraw',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Roboto'),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  ]),
                ),
                DefaultTabController(
                  length: 5,
                  child: Column(
                    children: [
                      Container(
                        child: TabBar(
                          labelColor: Colors.black,
                          unselectedLabelColor:
                              Color.fromARGB(171, 105, 104, 104),
                          labelStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                          ),
                          isScrollable: true,
                          physics: BouncingScrollPhysics(),
                          indicator: BoxDecoration(),
                          tabs: [
                            Tab(
                                child: Text(
                              'All',
                            )),
                            Tab(
                              child: Text(
                                'Deposit',
                              ),
                            ),
                            Tab(
                                child: Text(
                              'Withdraw',
                            )),
                            Tab(
                                child: Text(
                              'Earned',
                            )),
                            Tab(
                                child: Text(
                              'Used',
                            )),
                          ],
                          onTap: (index) async {
                            switch (index) {
                              case 0:
                                break;
                              case 1:
                                break;
                              case 2:
                                await withdrawController.fetchWithdraws();
                                break;
                              case 3:
                                break;
                              case 4:
                                break;
                            }
                          },
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height,
                        child: TabBarView(children: [
                          historyWidget(),
                          historyWidget(),
                          withdrawWidget(),
                          historyWidget(),
                          historyWidget(),
                        ]),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget historyWidget() {
    return AnimatedListView(
      padding: EdgeInsets.only(bottom: 400),
      itemCount: 10,
      physics: BouncingScrollPhysics(),
      slideConfiguration: SlideConfiguration(
          delay: Duration(milliseconds: 80), verticalOffset: 300),
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  (index % 2 == 0)
                      ? Image.asset(
                          ic_receive_money,
                          width: 80,
                          height: 80,
                        )
                      : Image.asset(
                          ic_send_money,
                          width: 80,
                          height: 80,
                        ),
                  12.width,
                  Expanded(
                    child: Container(
                      height: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(
                                'title',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                textAlign: TextAlign.start,
                                style: boldTextStyle(
                                    fontFamily: 'Roboto', size: 18),
                              ),
                              10.width,
                              Container(
                                decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(118, 76, 175, 79),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: Color.fromARGB(24, 0, 0, 0))),
                                padding: EdgeInsets.all(3),
                                child: Text(
                                  'Status',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Roboto',
                                      color: Color.fromARGB(255, 0, 0, 0)),
                                ),
                              )
                            ],
                          ),
                          10.height,
                          Flexible(
                            child: Text(
                              DateFormat('dd/MM/yyyy hh:mm:ss a')
                                  .format(DateTime.now()),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textAlign: TextAlign.start,
                              style: boldTextStyle(
                                size: 15,
                                fontFamily: 'Roboto',
                                color: Color.fromARGB(118, 0, 0, 0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  (index % 2 == 0)
                      ? Column(
                          children: [
                            Text('+ 120.000',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                    fontFamily: 'Roboto')),
                            Text('50.000 VNĐ',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: const Color.fromARGB(120, 0, 0, 0),
                                    fontFamily: 'Roboto')),
                          ],
                        )
                      : Column(
                          children: [
                            Text('- 120.000',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                    fontFamily: 'Roboto')),
                            Text('50.000 VNĐ',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: const Color.fromARGB(120, 0, 0, 0),
                                    fontFamily: 'Roboto')),
                          ],
                        ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Widget withdrawWidget() {
    if (withdrawController.isLoading.value)
      return LoadingWidget().center();
    else if (withdrawController.isError.value ||
        withdrawController.withdraws.isEmpty)
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: NoDataWidget(
          imageWidget: NoDataLottieWidget(),
          title: withdrawController.isError.value
              ? language.somethingWentWrong
              : language.noDataFound,
          onRetry: () {
            withdrawController.fetchWithdraws();
          },
          retryText: '   ' + language.clickToRefresh + '   ',
        ).center(),
      );
    else
      return AnimatedListView(
        padding: EdgeInsets.only(bottom: 400),
        itemCount: withdrawController.withdraws.length,
        physics: BouncingScrollPhysics(),
        slideConfiguration: SlideConfiguration(
            delay: Duration(milliseconds: 80), verticalOffset: 300),
        itemBuilder: (context, index) {
          Withdraw withdraw = withdrawController.withdraws[index];
          return InkWell(
            onTap: () {
              print('Tapped');
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Image.asset(
                        ic_send_money,
                        width: 80,
                        height: 80,
                      ),
                      12.width,
                      Expanded(
                        child: Container(
                          height: 100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: colorList[withdraw.status!],
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            color:
                                                Color.fromARGB(24, 0, 0, 0))),
                                    padding: EdgeInsets.all(4),
                                    child: Text(
                                      WithdrawStatus
                                          .values[withdraw.status!].name,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(255, 0, 0, 0)),
                                    ),
                                  )
                                ],
                              ),
                              10.height,
                              Flexible(
                                child: Text(
                                  DateFormat('dd/MM/yyyy hh:mm:ss a').format(
                                      withdraw.createdAt!
                                          .add(Duration(hours: 7))),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                  style: boldTextStyle(
                                    size: 15,
                                    fontFamily: 'Roboto',
                                    color: Color.fromARGB(118, 0, 0, 0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                              '- ' +
                                  withdraw.point!
                                      .toStringAsFixed(0)
                                      .formatNumberWithComma() +
                                  ' Points',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                  fontFamily: 'Roboto')),
                          Text(
                              (withdraw.point! * 1000)
                                      .toStringAsFixed(0)
                                      .formatNumberWithComma() +
                                  ' VNĐ',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(120, 0, 0, 0),
                                  fontFamily: 'Roboto')),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      );
  }
}

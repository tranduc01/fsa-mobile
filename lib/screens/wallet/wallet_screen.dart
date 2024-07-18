import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/controllers/system_config_controller.dart';
import 'package:socialv/controllers/user_controller.dart';
import 'package:socialv/models/transaction/transaction_log.dart';
import 'package:socialv/models/withdraw/withdraw.dart';
import 'package:socialv/utils/app_constants.dart';

import '../../components/loading_widget.dart';
import '../../components/no_data_lottie_widget.dart';
import '../../controllers/transaction_log_controller.dart';
import '../../controllers/withdraw_controller.dart';
import '../../main.dart';
import '../../models/enums/enums.dart';
import '../../models/package/bank.dart';
import '../common/fail_dialog.dart';
import '../common/loading_dialog.dart';
import '../subscription/top-up/topup_package_screen.dart';
import 'withdraw_detail_bottomsheet_widget.dart';

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

  late UserController userController = Get.find();
  late WithdrawController withdrawController = Get.put(WithdrawController());
  late TransactionLogController transactionController =
      Get.put(TransactionLogController());
  late SystemConfigController systemConfigController = Get.find();

  final List<Color> colorList = [
    Colors.blue.withOpacity(0.5),
    Colors.orange.withOpacity(0.5),
    Colors.green.withOpacity(0.5),
    Colors.red.withOpacity(0.5),
    Colors.grey.withOpacity(0.5)
  ];

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await transactionController.fetchTransactions(null);
    });
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
        title: Text('Ví', style: boldTextStyle(size: 20)),
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
                      'Số dư của tôi',
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
                        if (userController.user.value.totalPoint != null)
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
                      'Điểm',
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
                                WidgetStateProperty.all(EdgeInsets.all(8)),
                            backgroundColor:
                                WidgetStateProperty.all(Colors.white),
                            shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            side: WidgetStateProperty.all(
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
                                'Nạp',
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
                                WidgetStateProperty.all(EdgeInsets.all(8)),
                            backgroundColor:
                                WidgetStateProperty.all(Colors.white),
                            shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            side: WidgetStateProperty.all(
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
                                            onPopInvoked: (isPop) {
                                              amountController.clear();
                                              moneyController.clear();
                                            },
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'Yêu cầu rút tiền',
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
                                                          'Nhập điểm',
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  'Roboto'),
                                                        ),
                                                        Text(
                                                          '(1 điểm = 1,000 VNĐ)',
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
                                                              return 'Hãy nhập số điểm';
                                                            }

                                                            var minAmount = systemConfigController
                                                                .systemConfigs
                                                                .firstWhere(
                                                                    (element) =>
                                                                        element
                                                                            .key ==
                                                                        'WithdrawRequest.MinPoint')
                                                                .value;
                                                            if (int.parse(
                                                                    value) <
                                                                int.parse(
                                                                    minAmount!)) {
                                                              return 'Số điểm rút tối thiểu là ' +
                                                                  minAmount
                                                                      .formatNumberWithComma() +
                                                                  ' điểm';
                                                            }

                                                            var maxAmount = systemConfigController
                                                                .systemConfigs
                                                                .firstWhere(
                                                                    (element) =>
                                                                        element
                                                                            .key ==
                                                                        'WithdrawRequest.MaxPoint')
                                                                .value;
                                                            if (int.parse(
                                                                    value) >
                                                                int.parse(
                                                                    maxAmount!)) {
                                                              return 'Số điểm rút tối đa là ' +
                                                                  maxAmount
                                                                      .formatNumberWithComma() +
                                                                  ' điểm';
                                                            }

                                                            if (int.parse(
                                                                    value) >
                                                                userController
                                                                    .user
                                                                    .value
                                                                    .totalPoint!) {
                                                              return 'Số dư không khả dụng';
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
                                                      text: 'Tiếp tục',
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
                                                                    (isPop) {
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
                                                                    'Thông tin tài khoản',
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
                                                                                  hintText: 'Số tài khoản',
                                                                                  hintStyle: TextStyle(
                                                                                    fontSize: 16,
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontFamily: 'Roboto',
                                                                                  ),
                                                                                  label: Text(
                                                                                    'Số tài khoản',
                                                                                    style: TextStyle(
                                                                                      fontSize: 16,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontFamily: 'Roboto',
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                validator: (value) {
                                                                                  if (value!.isEmpty) {
                                                                                    return 'Hãy nhập số tài khoản';
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
                                                                                  hintText: 'Tên tài khoản',
                                                                                  hintStyle: TextStyle(
                                                                                    fontSize: 16,
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontFamily: 'Roboto',
                                                                                  ),
                                                                                  label: Text(
                                                                                    'Tên tài khoản',
                                                                                    style: TextStyle(
                                                                                      fontSize: 16,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontFamily: 'Roboto',
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                validator: (value) {
                                                                                  if (value!.isEmpty) {
                                                                                    return 'Hãy nhập tên tài khoản';
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
                                                                                    hintText: 'Chọn ngân hàng',
                                                                                    hintStyle: TextStyle(
                                                                                      fontSize: 16,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontFamily: 'Roboto',
                                                                                    ),
                                                                                    label: Text(
                                                                                      'Ngân hàng',
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
                                                                                    return 'Hãy chọn một ngân hàng';
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
                                                                                  hintText: 'Tên ngân hàng',
                                                                                  hintStyle: TextStyle(
                                                                                    fontSize: 16,
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontFamily: 'Roboto',
                                                                                  ),
                                                                                  label: Text(
                                                                                    'Tên ngân hàng',
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
                                                                                  hintText: 'Ghi chú',
                                                                                  hintStyle: TextStyle(
                                                                                    fontSize: 16,
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontFamily: 'Roboto',
                                                                                  ),
                                                                                  label: Text(
                                                                                    'Ghi chú',
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
                                                                            'Tạo yêu cầu rút',
                                                                        onTap:
                                                                            () {
                                                                          if (informationFormKey
                                                                              .currentState!
                                                                              .validate()) {
                                                                            informationFormKey.currentState!.save();
                                                                            hideKeyboard(context);
                                                                            showConfirmDialogCustom(
                                                                              context,
                                                                              title: 'Bạn có chắc chắn muốn rút' + amountController.text.formatNumberWithComma() + ' điểm thành ' + moneyController.text.formatNumberWithComma() + ' VNĐ?',
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

                                                                                  await userController.getCurrentUser();
                                                                                  await withdrawController.fetchWithdraws();
                                                                                  toast('Tạo yêu cầu rút thành công');
                                                                                } else {
                                                                                  Navigator.pop(context);
                                                                                  showDialog(
                                                                                    context: context,
                                                                                    barrierDismissible: false,
                                                                                    builder: (context) {
                                                                                      return FailDialog(text: 'Tạo yêu cầu rút thất bại');
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
                                'Rút',
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
                  length: 6,
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
                              'Tất cả',
                            )),
                            Tab(
                              child: Text(
                                'Nạp',
                              ),
                            ),
                            Tab(
                                child: Text(
                              'Rút',
                            )),
                            Tab(
                                child: Text(
                              'Nhận',
                            )),
                            Tab(
                                child: Text(
                              'Sử dụng',
                            )),
                            Tab(
                                child: Text(
                              'Hoàn lại',
                            )),
                          ],
                          onTap: (index) async {
                            switch (index) {
                              case 0:
                                await transactionController
                                    .fetchTransactions(null);
                                break;
                              case 1:
                                await transactionController
                                    .fetchTransactions(1);
                                break;
                              case 2:
                                await withdrawController.fetchWithdraws();
                                break;
                              case 3:
                                await transactionController
                                    .fetchTransactions(2);
                                break;
                              case 4:
                                await transactionController
                                    .fetchTransactions(3);
                                break;
                              case 5:
                                await transactionController
                                    .fetchTransactions(4);
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
    if (transactionController.isLoading.value)
      return LoadingWidget().center();
    else if (transactionController.isError.value ||
        transactionController.transactionLogs.isEmpty)
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: NoDataWidget(
          imageWidget: NoDataLottieWidget(),
          title: transactionController.isError.value
              ? language.somethingWentWrong
              : language.noDataFound,
          onRetry: () {
            transactionController.fetchTransactions(null);
          },
          retryText: '   ' + language.clickToRefresh + '   ',
        ).center(),
      );
    else
      return AnimatedListView(
        padding: EdgeInsets.only(bottom: 400),
        itemCount: transactionController.transactionLogs.length,
        physics: BouncingScrollPhysics(),
        slideConfiguration: SlideConfiguration(
            delay: Duration(milliseconds: 80), verticalOffset: 300),
        itemBuilder: (context, index) {
          TransactionLog transaction =
              transactionController.transactionLogs[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    if (transaction.transactionType ==
                            TransactionType.Deposit ||
                        transaction.transactionType ==
                            TransactionType.PointEarned ||
                        transaction.transactionType ==
                            TransactionType.PointRefund)
                      Image.asset(
                        ic_receive_money,
                        width: 80,
                        height: 80,
                      )
                    else
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
                                Flexible(
                                  child: Text(
                                    transaction.note!,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    textAlign: TextAlign.start,
                                    style: boldTextStyle(
                                        fontFamily: 'Roboto', size: 18),
                                  ),
                                ),
                              ],
                            ),
                            10.height,
                            Flexible(
                              child: Text(
                                DateFormat('dd/MM/yyyy hh:mm:ss a').format(
                                    transaction.createdDate!
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
                    if (transaction.transactionType ==
                            TransactionType.Deposit ||
                        transaction.transactionType ==
                            TransactionType.PointEarned ||
                        transaction.transactionType ==
                            TransactionType.PointRefund)
                      Column(
                        children: [
                          Text(
                              '+ ' +
                                  transaction.amount!
                                      .toStringAsFixed(0)
                                      .formatNumberWithComma() +
                                  ' điểm',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                  fontFamily: 'Roboto')),
                          Text(
                              (transaction.amount! * 1000)
                                      .toStringAsFixed(0)
                                      .formatNumberWithComma() +
                                  ' VNĐ',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(120, 0, 0, 0),
                                  fontFamily: 'Roboto')),
                        ],
                      )
                    else
                      Column(
                        children: [
                          Text(
                              '- ' +
                                  transaction.amount!
                                      .toStringAsFixed(0)
                                      .formatNumberWithComma() +
                                  ' điểm',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                  fontFamily: 'Roboto')),
                          Text(
                              (transaction.amount! * 1000)
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
        height: MediaQuery.of(context).size.height * 0.5,
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
              showModalBottomSheet(
                elevation: 0,
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                transitionAnimationController: _animationController,
                builder: (context) {
                  return FractionallySizedBox(
                    heightFactor: 0.9,
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
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: context.cardColor,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)),
                            ),
                            child: WithdrawRequestDetailBottomSheetWidget(
                              requestId: withdraw.id!,
                            )).expand(),
                      ],
                    ),
                  );
                },
              );
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

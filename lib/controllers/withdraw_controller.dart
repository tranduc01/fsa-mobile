import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:socialv/models/withdraw/withdraw.dart';

import '../configs.dart';
import '../models/response_model.dart';

class WithdrawController extends GetxController {
  final storage = new FlutterSecureStorage();
  var withdraws = <Withdraw>[].obs;
  var withdraw = Withdraw().obs;
  var isLoading = false.obs;
  var isCreateSuccess = false.obs;
  var isDeleteSuccess = false.obs;
  var isUpdateSuccess = false.obs;
  var isError = false.obs;

  Future<List<Withdraw>> fetchWithdraws() async {
    isLoading(true);
    var url = '$BASE_URL/withdraw-request/member';

    String? token = await storage.read(key: 'jwt');
    var headers = {
      'Authorization': 'Bearer $token',
    };
    var response = await GetConnect().get(url, headers: headers);

    ResponseModel responseModel =
        ResponseModel.fromJson(jsonDecode(response.bodyString!));
    if (response.statusCode == 200) {
      isLoading(false);
      isError(false);
      return withdraws.value = (responseModel.data['items'] as List)
          .map((e) => Withdraw.fromJson(e))
          .toList();
    } else {
      isLoading(false);
      isError(true);
      print('Request failed with status: ${response.statusCode}');
      print('Request failed with status: ${responseModel.message}');
      throw Exception('Failed to load topics');
    }
  }

  Future<Withdraw> fetchWithdraw(int id) async {
    isLoading(true);
    var url = '$BASE_URL/withdraw-request/$id';

    String? token = await storage.read(key: 'jwt');
    var headers = {
      'Authorization': 'Bearer $token',
    };
    var response = await GetConnect().get(url, headers: headers);

    ResponseModel responseModel =
        ResponseModel.fromJson(jsonDecode(response.bodyString!));

    if (response.statusCode == 200) {
      isLoading(false);
      isError(false);
      return withdraw.value = Withdraw.fromJson(responseModel.data);
    } else {
      isLoading(false);
      isError(true);
      print('Request failed with status: ${response.statusCode}');
      print('Request failed with status: ${responseModel.message}');
      throw Exception('Failed to load topic');
    }
  }

  Future<void> createWithdrawRequest(
      int point,
      String bankNumber,
      String bankAccountName,
      String bankName,
      String bankCode,
      String bankShortName,
      String note) async {
    try {
      var url = '$BASE_URL/withdraw-request';

      String? token = await storage.read(key: 'jwt');
      var headers = {
        'Authorization': 'Bearer $token',
      };
      var response = await GetConnect().post(
          url,
          {
            "point": point,
            "memberNote": note,
            "bankNumber": bankNumber,
            "bankAccountName": bankAccountName,
            "bankName": bankName,
            "bankCode": bankCode,
            "bankShortName": bankShortName,
          },
          headers: headers);
      if (response.statusCode == 200) {
        isCreateSuccess(true);
      } else {
        print('Request failed with status: ${response.statusCode}');
        print('Request failed with status: ${response.body['Message']}');
        isCreateSuccess(false);
      }
    } catch (e) {
      isError(true);
      print(e);
    }
  }

  Future<void> cancelWithdrawRequest(int id, String cancelMessage) async {
    try {
      isLoading(true);
      var url =
          '$BASE_URL/withdraw-request/$id/cancel?cancelMessage=$cancelMessage';
      String? token = await storage.read(key: 'jwt');
      var headers = {
        'Authorization': 'Bearer $token',
      };

      var response = await GetConnect().patch(url, {}, headers: headers);
      if (response.statusCode == 200) {
        isLoading(false);
        isUpdateSuccess(true);
      } else {
        isLoading(false);
        isError(true);
        print('Request failed with status: ${response.statusCode}');
        print('Request failed with status: ${response.body['Message']}');
      }
    } catch (e) {
      isError(true);
      print(e);
    }
  }
}

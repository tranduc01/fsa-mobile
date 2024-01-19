import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import '../configs.dart';
import '../models/response_model.dart';
import '../models/transaction/transaction_log.dart';

class TransactionLogController extends GetxController {
  final storage = new FlutterSecureStorage();
  var transactionLogs = <TransactionLog>[].obs;
  var isLoading = false.obs;
  var isError = false.obs;

  Future<List<TransactionLog>> fetchTransactions(int? type) async {
    isLoading(true);
    var url = '$BASE_URL/transaction-log';
    if (type != null) {
      url = '$BASE_URL/transaction-log?Filters=transactionType==$type';
    }

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
      return transactionLogs.value = (responseModel.data['items'] as List)
          .map((e) => TransactionLog.fromJson(e))
          .toList();
    } else {
      isLoading(false);
      isError(true);
      print('Request failed with status: ${response.statusCode}');
      print('Request failed with status: ${responseModel.message}');
      throw Exception('Failed to load topics');
    }
  }
}

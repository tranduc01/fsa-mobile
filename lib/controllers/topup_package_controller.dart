import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:socialv/models/package/topup_package.dart';

import '../configs.dart';
import '../models/response_model.dart';

class TopupPackageController extends GetxController {
  final storage = new FlutterSecureStorage();
  var topupPackages = <TopupPackage>[].obs;
  var isLoading = true.obs;
  var isError = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<List<TopupPackage>> fetchTopupPackages() async {
    isLoading(true);
    var url = '$BASE_URL/topup-package';

    String? token = await storage.read(key: 'jwt');
    var headers = {
      'Authorization': 'Bearer $token',
    };
    var response = await GetConnect().get(url, headers: headers);

    if (response.bodyString != null) {
      ResponseModel responseModel =
          ResponseModel.fromJson(jsonDecode(response.bodyString!));

      if (response.statusCode == 200) {
        isLoading(false);
        isError(false);
        return topupPackages.value = (responseModel.data as List)
            .map((e) => TopupPackage.fromJson(e))
            .toList();
      } else {
        isLoading(false);
        isError(true);
        print('Request failed with status: ${response.statusCode}');
        print('Request failed with status: ${responseModel.message}');
        throw Exception('Failed to load requests');
      }
    } else {
      isLoading(false);
      isError(true);
      print('Request failed with status: ${response.statusCode}');
      throw Exception('Failed to load requests');
    }
  }

  Future<String> processPayment(int topupPackageId) async {
    isLoading(true);
    var url =
        '$BASE_URL/Payment?topupPackageId=$topupPackageId&paymentMethodId=1';

    String? token = await storage.read(key: 'jwt');
    var headers = {
      'Authorization': 'Bearer $token',
    };
    var response = await GetConnect().get(url, headers: headers);
    if (response.bodyString != null) {
      ResponseModel responseModel =
          ResponseModel.fromJson(jsonDecode(response.bodyString!));

      if (response.statusCode == 200) {
        isLoading(false);
        isError(false);
        return responseModel.data;
      } else {
        isLoading(false);
        isError(true);
        print('Request failed with status: ${response.statusCode}');
        print('Request failed with status: ${responseModel.message}');
        throw Exception('Failed to load requests');
      }
    } else {
      isLoading(false);
      isError(true);
      print('Request failed with status: ${response.statusCode}');
      throw Exception('Failed to load requests');
    }
  }
}

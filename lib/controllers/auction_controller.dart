import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import '../configs.dart';
import '../models/auction/auction.dart';
import '../models/response_model.dart';

class AuctionController extends GetxController {
  final storage = new FlutterSecureStorage();
  var auctions = <Auction>[].obs;
  var auction = Auction().obs;
  var isLoading = true.obs;
  var isError = false.obs;
  var isUpdateSuccess = false.obs;
  var message = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAuctions(null);
  }

  Future<List<Auction>> fetchAuctions(int? status) async {
    isLoading(true);
    var url = '$BASE_URL/Auction?Paging.PageNumber=1&Paging.PageSize=20';
    if (status != null) {
      url += '&Filter=$status';
    }
    var response = await GetConnect().get(url);

    if (response.bodyString != null) {
      ResponseModel responseModel =
          ResponseModel.fromJson(jsonDecode(response.bodyString!));
      if (response.statusCode == 200) {
        isLoading(false);
        isError(false);

        return auctions.value = (responseModel.data['items'] as List)
            .map((e) => Auction.fromJson(e))
            .toList();
      } else {
        isLoading(false);
        isError(true);
        print('Request failed with status: ${response.statusCode}');
        print('Request failed with status: ${responseModel.message}');
        throw Exception('Failed to load auctions');
      }
    } else {
      isLoading(false);
      isError(true);
      print('Request failed with status: ${response.statusCode}');
      throw Exception('Failed to load auctions');
    }
  }

  Future<Auction> fetchAuction(int id) async {
    isLoading(true);
    String? token = await storage.read(key: 'jwt');
    var headers = {
      'Authorization': 'Bearer $token',
    };
    var response =
        await GetConnect().get('$BASE_URL/Auction/$id', headers: headers);

    if (response.bodyString != null) {
      ResponseModel responseModel =
          ResponseModel.fromJson(jsonDecode(response.bodyString!));
      if (response.statusCode == 200) {
        isLoading(false);
        isError(false);

        return auction.value = Auction.fromJson(responseModel.data);
      } else {
        isLoading(false);
        isError(true);
        print('Request failed with status: ${response.statusCode}');
        print('Request failed with status: ${responseModel.message}');
        throw Exception('Failed to load auction');
      }
    } else {
      isLoading(false);
      isError(true);
      print('Request failed with status: ${response.statusCode}');
      throw Exception('Failed to load auction');
    }
  }

  Future<void> joinAuction(int id, int amount) async {
    try {
      isLoading(true);
      isUpdateSuccess(false);
      var url = '$BASE_URL/Auction/registration?id=$id&amount=$amount';
      String? token = await storage.read(key: 'jwt');
      var headers = {
        'Authorization': 'Bearer $token',
      };

      var response = await GetConnect().post(url, {}, headers: headers);
      if (response.statusCode == 200) {
        isLoading(false);
        isUpdateSuccess(true);
      } else {
        isLoading(false);
        //isError(true);
        print('Request failed with status: ${response.statusCode}');
        print('Request failed with status: ${response.body['Message']}');
        message.value = response.body['Message'];
      }
    } catch (e) {
      //isError(true);
      print(e);
    }
  }

  Future<void> placeBid(int id, int amount) async {
    try {
      isLoading(true);
      isUpdateSuccess(false);
      message.value = '';
      var url = '$BASE_URL/Auction/bid/$id?amount=$amount';
      String? token = await storage.read(key: 'jwt');
      var headers = {
        'Authorization': 'Bearer $token',
      };

      var response = await GetConnect().post(url, {}, headers: headers);
      if (response.statusCode == 202) {
        isLoading(false);
        isUpdateSuccess(true);
        message.value = '';
      } else {
        isLoading(false);
        print('Request failed with status: ${response.statusCode}');
        print('Request failed with status: ${response.body['Message']}');
        message.value = response.body['Message'];
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> depositePoints(int id, int amount) async {
    try {
      isLoading(true);
      isUpdateSuccess(false);
      message.value = '';
      var url = '$BASE_URL/Auction/deposit?id=$id&amount=$amount';
      String? token = await storage.read(key: 'jwt');
      var headers = {
        'Authorization': 'Bearer $token',
      };

      var response = await GetConnect().patch(url, {}, headers: headers);
      if (response.statusCode == 200 || response.statusCode == 202) {
        isLoading(false);
        isUpdateSuccess(true);
        message.value = '';
      } else {
        isLoading(false);
        print('Request failed with status: ${response.statusCode}');
        print('Request failed with status: ${response.body['Message']}');
        message.value = response.body['Message'];
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> cancelRegistrationAuction(int id) async {
    try {
      isLoading(true);
      isUpdateSuccess(false);
      var url = '$BASE_URL/Auction/cancel-registration?id=$id';
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
        //isError(true);
        print('Request failed with status: ${response.statusCode}');
        print('Request failed with status: ${response.body['Message']}');
        message.value = response.body['Message'];
      }
    } catch (e) {
      //isError(true);
      print(e);
    }
  }
}

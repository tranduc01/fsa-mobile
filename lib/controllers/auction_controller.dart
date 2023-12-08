import 'dart:convert';

import 'package:get/get.dart';

import '../configs.dart';
import '../models/auction/auction.dart';
import '../models/response_model.dart';

class AuctionController extends GetxController {
  var auctions = <Auction>[].obs;
  var auction = Auction().obs;
  var isLoading = true.obs;
  var isError = false.obs;

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
}

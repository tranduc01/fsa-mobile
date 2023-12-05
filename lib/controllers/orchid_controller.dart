import 'dart:convert';

import 'package:get/get.dart';
import 'package:socialv/models/orchid/orchid.dart';

import '../configs.dart';
import '../models/response_model.dart';

class OrchidController extends GetxController {
  var orchids = <Orchid>[].obs;
  var orchid = Orchid().obs;
  var isLoading = true.obs;
  var isError = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrchids();
  }

  Future<List<Orchid>> fetchOrchids() async {
    isLoading(true);
    var url = '$BASE_URL/Orchid';
    var response = await GetConnect().get(url);

    if (response.bodyString != null) {
      ResponseModel responseModel =
          ResponseModel.fromJson(jsonDecode(response.bodyString!));
      if (response.statusCode == 200) {
        isLoading(false);
        isError(false);

        return orchids.value = (responseModel.data['items'] as List)
            .map((e) => Orchid.fromJson(e))
            .toList();
      } else {
        isLoading(false);
        isError(true);
        print('Request failed with status: ${response.statusCode}');
        print('Request failed with status: ${responseModel.message}');
        throw Exception('Failed to load orchids');
      }
    } else {
      isLoading(false);
      isError(true);
      print('Request failed with status: ${response.statusCode}');
      throw Exception('Failed to load orchids');
    }
  }

  Future<Orchid> fetchOrchid(int orchidId) async {
    isLoading(true);
    var url = '$BASE_URL/Orchid/$orchidId';
    var response = await GetConnect().get(url);

    if (response.bodyString != null) {
      ResponseModel responseModel =
          ResponseModel.fromJson(jsonDecode(response.bodyString!));
      if (response.statusCode == 200) {
        isLoading(false);
        isError(false);

        return orchid.value = Orchid.fromJson(responseModel.data);
      } else {
        isLoading(false);
        isError(true);
        print('Request failed with status: ${response.statusCode}');
        print('Request failed with status: ${responseModel.message}');
        throw Exception('Failed to load orchid');
      }
    } else {
      isLoading(false);
      isError(true);
      print('Request failed with status: ${response.statusCode}');
      throw Exception('Failed to load orchid');
    }
  }
}

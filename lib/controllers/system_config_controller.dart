import 'dart:convert';

import 'package:get/get.dart';

import '../configs.dart';
import '../models/response_model.dart';
import '../models/system_config/system_config.dart';

class SystemConfigController extends GetxController {
  var systemConfigs = <SystemConfig>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchSystemConfigs();
  }

  Future<List<SystemConfig>> fetchSystemConfigs() async {
    var response = await GetConnect().get('$BASE_URL/system-configuration');

    if (response.bodyString != null) {
      ResponseModel responseModel =
          ResponseModel.fromJson(jsonDecode(response.bodyString!));
      if (response.statusCode == 200) {
        return systemConfigs.value = (responseModel.data['items'] as List)
            .map((e) => SystemConfig.fromJson(e))
            .toList();
      } else {
        print('Request failed with status: ${response.statusCode}');
        print('Request failed with status: ${responseModel.message}');
        throw Exception('Failed to load system configs');
      }
    } else {
      print('Request failed with status: ${response.statusCode}');
      throw Exception('Failed to load system configs');
    }
  }
}

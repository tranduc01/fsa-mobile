import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import '../configs.dart';
import '../models/posts/topic.dart';
import '../models/response_model.dart';

class TopicController extends GetxController {
  final storage = new FlutterSecureStorage();
  var topics = <Topic>[].obs;
  var isLoading = false.obs;
  var isError = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTopics();
  }

  Future<List<Topic>> fetchTopics() async {
    isLoading(true);
    var url = '$BASE_URL/Topic';

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
      return topics.value = (responseModel.data['items'] as List)
          .map((e) => Topic.fromJson(e))
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

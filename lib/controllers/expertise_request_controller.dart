import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../configs.dart';
import '../models/common_models.dart';
import 'package:http_parser/http_parser.dart';

import '../models/expertise_request/expertise_request.dart';
import '../models/response_model.dart';

class ExpertiseRequestController extends GetxController {
  final storage = new FlutterSecureStorage();
  var expertiseRequests = <ExpertiseRequest>[].obs;
  var isLoading = false.obs;
  var isCreateSuccess = false.obs;
  var isDeleteSuccess = false.obs;
  var isUpdateSuccess = false.obs;
  var isError = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchExpetiseRequests();
  }

  Future<List<ExpertiseRequest>> fetchExpetiseRequests() async {
    isLoading(true);
    var url = '$BASE_URL/ExpertiseRequest';

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
      return expertiseRequests.value = (responseModel.data['items'] as List)
          .map((e) => ExpertiseRequest.fromJson(e))
          .toList();
    } else {
      isLoading(false);
      isError(true);
      print('Request failed with status: ${response.statusCode}');
      print('Request failed with status: ${responseModel.message}');
      throw Exception('Failed to load requests');
    }
  }

  Future<void> createExpertiseRequest(
      String message, List<PostMedia> medias) async {
    try {
      var url = Uri.parse('$BASE_URL/ExpertiseRequest');
      var request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] =
          'Bearer ${await storage.read(key: 'jwt')}';
      for (var media in medias) {
        var multipartFile = await http.MultipartFile.fromPath(
          'medias',
          media.file!.path,
          filename: media.file!.path.split('/').last,
          contentType: MediaType('image', 'jpeg'),
        );
        request.files.add(multipartFile);
      }

      request.fields['NoteRequestMessage'] = message;

      var response = await request.send();
      if (response.statusCode == 200) {
        isCreateSuccess(true);
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      isError(true);
      print(e);
    }
  }
}

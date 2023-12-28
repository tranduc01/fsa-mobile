import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:socialv/controllers/user_controller.dart';
import '../configs.dart';
import '../models/common_models.dart';
import 'package:http_parser/http_parser.dart';

import '../models/expertise_request/expertise_request.dart';
import '../models/response_model.dart';

class ExpertiseRequestController extends GetxController {
  final storage = new FlutterSecureStorage();
  var expertiseRequests = <ExpertiseRequest>[].obs;
  var expertiseRequest = ExpertiseRequest().obs;
  var isLoading = false.obs;
  var isCreateSuccess = false.obs;
  var isDeleteSuccess = false.obs;
  var isUpdateSuccess = false.obs;
  var isError = false.obs;
  late UserController userController = Get.find();

  @override
  void onInit() {
    super.onInit();
  }

  Future<List<ExpertiseRequest>> fetchExpetiseRequests(int status) async {
    isLoading(true);
    var url = '$BASE_URL/expertise-request?Filters=status==$status';

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
    } else {
      isLoading(false);
      isError(true);
      print('Request failed with status: ${response.statusCode}');
      throw Exception('Failed to load requests');
    }
  }

  Future<List<ExpertiseRequest>> fetchExpetiseRequestsReceive(
      int status) async {
    isLoading(true);
    var url =
        '$BASE_URL/expertise-request/waiting-for-receive?Filters=status==$status';

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
    } else {
      isLoading(false);
      isError(true);
      print('Request failed with status: ${response.statusCode}');
      throw Exception('Failed to load requests');
    }
  }

  Future<ExpertiseRequest> fetchExpetiseRequest(int id) async {
    isLoading(true);
    var url = '$BASE_URL/expertise-request/$id';

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
        return expertiseRequest.value =
            ExpertiseRequest.fromJson(responseModel.data);
      } else {
        isLoading(false);
        isError(true);
        print('Request failed with status: ${response.statusCode}');
        print('Request failed with status: ${responseModel.message}');
        throw Exception('Failed to load request');
      }
    } else {
      isLoading(false);
      isError(true);
      print('Request failed with status: ${response.statusCode}');
      throw Exception('Failed to load request');
    }
  }

  Future<void> createExpertiseRequest(
      String message, List<PostMedia> medias) async {
    try {
      var url = Uri.parse('$BASE_URL/expertise-request');
      var request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] =
          'Bearer ${await storage.read(key: 'jwt')}';
      for (var media in medias) {
        String type =
            path.extension(media.file!.path) == '.mp4' ? 'video' : 'image';
        var multipartFile = await http.MultipartFile.fromPath(
          'medias',
          media.file!.path,
          filename: media.file!.path.split('/').last,
          contentType: MediaType(type, 'jpeg'),
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

  Future<void> receiveExpertiseRequest(int id) async {
    try {
      isLoading(true);
      var url = '$BASE_URL/expertise-request/receive/$id';
      String? token = await storage.read(key: 'jwt');
      var headers = {
        'Authorization': 'Bearer $token',
      };

      var response = await GetConnect().patch(url, '', headers: headers);
      if (response.statusCode == 200) {
        isLoading(false);
        isUpdateSuccess(true);
      } else {
        isLoading(false);
        isError(true);
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      isError(true);
      print(e);
    }
  }

  Future<void> sendFeedback(int id, double rating, String message) async {
    try {
      var url = '$BASE_URL/expertise-request/feedback/$id';
      String? token = await storage.read(key: 'jwt');
      var headers = {
        'Authorization': 'Bearer $token',
      };
      var body = {
        'message': message,
        'rating': rating,
      };
      var response = await GetConnect().post(
        url,
        body,
        headers: headers,
      );
      if (response.statusCode == 200) {
        isLoading(false);
        isUpdateSuccess(true);
      } else {
        isLoading(false);
        isError(true);
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      isError(true);
      print(e);
    }
  }

  Future<void> sendResult(int id, List<Map<String, dynamic>> results) async {
    try {
      var url = '$BASE_URL/result';
      String? token = await storage.read(key: 'jwt');
      var headers = {
        'Authorization': 'Bearer $token',
      };
      var body = {
        'expertiseRequestId': id,
        'evaluationCriteriaResults': results,
      };
      var response = await GetConnect().post(
        url,
        body,
        headers: headers,
      );
      if (response.statusCode == 200) {
        isLoading(false);
        isUpdateSuccess(true);
      } else {
        isLoading(false);
        isError(true);
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      isError(true);
      print(e);
    }
  }

  Future<void> publishExpertiseRequestResult(int id) async {
    try {
      isLoading(true);
      var url = '$BASE_URL/Result/publish/$id';
      String? token = await storage.read(key: 'jwt');
      var headers = {
        'Authorization': 'Bearer $token',
      };

      var response = await GetConnect().patch(url, '', headers: headers);
      if (response.statusCode == 200) {
        isLoading(false);
        isUpdateSuccess(true);
      } else {
        isLoading(false);
        isError(true);
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      isError(true);
      print(e);
    }
  }
}

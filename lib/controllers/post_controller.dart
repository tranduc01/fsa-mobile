import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import '../configs.dart';
import '../models/posts/post.dart';
import '../models/response_model.dart';

class PostController extends GetxController {
  final storage = new FlutterSecureStorage();
  var posts = <Post>[].obs;
  var post = Post(contributeSessions: []).obs;
  var isLoading = false.obs;
  var isError = false.obs;
  var isCreateSuccess = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
  }

  Future<List<Post>> fetchPosts() async {
    isLoading(true);
    var url = '$BASE_URL/Post';

    var response = await GetConnect().get(url);

    if (response.bodyString != null) {
      ResponseModel responseModel =
          ResponseModel.fromJson(jsonDecode(response.bodyString!));

      if (response.statusCode == 200) {
        isLoading(false);
        isError(false);

        return posts.value = (responseModel.data['items'] as List)
            .map((e) => Post.fromJson(e))
            .toList();
      } else {
        isLoading(false);
        isError(true);
        print('Request failed with status: ${response.statusCode}');
        print('Request failed with status: ${responseModel.message}');
        throw Exception('Failed to load post');
      }
    } else {
      isLoading(false);
      isError(true);
      throw Exception('Failed to load post');
    }
  }

  Future<List<Post>> fetchPostsByTopic(int topicId) async {
    isLoading(true);
    var url = '$BASE_URL/Post/topic/$topicId';

    var response = await GetConnect().get(url);

    if (response.bodyString != null) {
      ResponseModel responseModel =
          ResponseModel.fromJson(jsonDecode(response.bodyString!));

      if (response.statusCode == 200) {
        isLoading(false);
        isError(false);

        return posts.value = (responseModel.data['items'] as List)
            .map((e) => Post.fromJson(e))
            .toList();
      } else {
        isLoading(false);
        isError(true);
        print('Request failed with status: ${response.statusCode}');
        print('Request failed with status: ${responseModel.message}');
        throw Exception('Failed to load post');
      }
    } else {
      isLoading(false);
      isError(true);
      throw Exception('Failed to load post');
    }
  }

  Future<Post> fetchPost(int id) async {
    isLoading(true);
    var url = '$BASE_URL/Post/member/$id';
    var response = await GetConnect().get(url);

    if (response.bodyString != null) {
      ResponseModel responseModel =
          ResponseModel.fromJson(jsonDecode(response.bodyString!));

      if (response.statusCode == 200) {
        isLoading(false);
        isError(false);

        return post.value = Post.fromJson(responseModel.data);
      } else {
        isLoading(false);
        isError(true);
        print('Request failed with status: ${response.statusCode}');
        print('Request failed with status: ${responseModel.message}');
        throw Exception('Failed to load post');
      }
    } else {
      isError(true);
      isLoading(false);
      throw Exception('Failed to load post');
    }
  }

  Future<void> addComment(int postId, String content) async {
    try {
      var url = '$BASE_URL/Comment';
      String? token = await storage.read(key: 'jwt');
      var headers = {
        'Authorization': 'Bearer $token',
      };
      var body = jsonEncode({
        'postId': postId,
        'content': content,
      });
      var response = await GetConnect().post(url, body, headers: headers);
      print(response.bodyString);
      if (response.statusCode == 200) {
        isCreateSuccess(true);
      } else {
        print('Request failed with status: ${response.statusCode}');
        isCreateSuccess(false);
      }
    } catch (e) {
      isError(true);
      print(e);
    }
  }
}

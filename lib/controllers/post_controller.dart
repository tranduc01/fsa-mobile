import 'dart:convert';

import 'package:get/get.dart';

import '../configs.dart';
import '../models/posts/post.dart';
import '../models/response_model.dart';

class PostController extends GetxController {
  var posts = <Post>[].obs;
  var isLoading = false.obs;
  var isError = false.obs;

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
        throw Exception('Failed to load album');
      }
    } else {
      isLoading(false);
      isError(true);
      throw Exception('Failed to load album');
    }
  }
}

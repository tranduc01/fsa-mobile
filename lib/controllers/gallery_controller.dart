import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';
import 'package:get/get.dart';
import 'package:socialv/models/common_models.dart';
import 'package:socialv/models/gallery/albums.dart';
import 'package:socialv/models/response_model.dart';

import '../configs.dart';

class GalleryController extends GetxController {
  final storage = new FlutterSecureStorage();
  var albums = <Album>[].obs;
  var album = Album(media: []).obs;
  var isLoading = false.obs;
  var isCreateSuccess = false.obs;
  var isDeleteSuccess = false.obs;
  var isUpdateSuccess = false.obs;
  var isError = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAlbums();
  }

  Future<List<Album>> fetchAlbums() async {
    isLoading(true);
    var url = '$BASE_URL/Collection';

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
      return albums.value = (responseModel.data['items'] as List)
          .map((e) => Album.fromJson(e))
          .toList();
    } else {
      isLoading(false);
      isError(true);
      print('Request failed with status: ${response.statusCode}');
      print('Request failed with status: ${responseModel.message}');
      throw Exception('Failed to load album');
    }
  }

  Future<Album> fetchAlbum(int albumId) async {
    isLoading(true);
    var url = '$BASE_URL/Collection/$albumId';

    String? token = await storage.read(key: 'jwt');
    var headers = {
      'Authorization': 'Bearer $token',
    };
    var response = await GetConnect().get(url, headers: headers);

    ResponseModel responseModel =
        ResponseModel.fromJson(jsonDecode(response.bodyString!));

    if (response.statusCode == 200) {
      isLoading(false);
      return album.value = Album.fromJson(responseModel.data);
    } else {
      print('Request failed with status: ${response.statusCode}');
      throw Exception('Failed to load album');
    }
  }

  Future<void> createAlbum(
      String title, String description, List<PostMedia> medias) async {
    try {
      var url = Uri.parse('$BASE_URL/Collection');
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
          contentType: MediaType(type, 'mp4'),
        );
        request.files.add(multipartFile);
      }

      request.fields['title'] = title;
      request.fields['description'] = description;

      var response = await request.send();
      if (response.statusCode == 200) {
        isCreateSuccess(true);
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateAlbum(
      Album album, List<PostMedia>? medias, List<int>? deleteId) async {
    try {
      var url = Uri.parse('$BASE_URL/Collection/${album.id}');
      var request = http.MultipartRequest('PATCH', url);
      request.headers['Authorization'] =
          'Bearer ${await storage.read(key: 'jwt')}';
      if (medias != null) {
        for (var media in medias) {
          String type =
              path.extension(media.file!.path) == '.mp4' ? 'video' : 'image';
          var multipartFile = await http.MultipartFile.fromPath(
            'mediasAdd',
            media.file!.path,
            filename: media.file!.path.split('/').last,
            contentType: MediaType(type, 'jpeg'),
          );
          request.files.add(multipartFile);
        }
      }

      if (deleteId != null) {
        request.fields['mediaDeleteIds'] = deleteId.join(",");
      }

      request.fields['title'] = album.title!;
      request.fields['description'] = album.description ?? "";

      var response = await request.send();
      if (response.statusCode == 200) {
        isUpdateSuccess(true);
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteAlbum(int id) async {
    try {
      var url = '$BASE_URL/Collection/$id';
      String? token = await storage.read(key: 'jwt');
      var headers = {
        'Authorization': 'Bearer $token',
      };
      var response = await GetConnect().delete(url, headers: headers);
      if (response.statusCode == 200) {
        isDeleteSuccess(true);
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }
}

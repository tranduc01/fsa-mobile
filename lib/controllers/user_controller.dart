import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/models/response_model.dart';

import '../configs.dart';
import '../models/common_models.dart';
import '../models/common_models/user.dart';
import '../screens/dashboard_screen.dart';
import 'package:http_parser/http_parser.dart';

class UserController extends GetxController {
  final storage = new FlutterSecureStorage();
  var isLoggedIn = false.obs;
  var isRegistered = false.obs;
  var user = User(role: []).obs;
  var isVerifySuccess = false.obs;
  var isUpdateSuccess = false.obs;
  var message = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    String? jwt = await getJWT();
    if (jwt != null) {
      isLoggedIn.value = !checkJWTValidity(jwt);
      if (!checkJWTValidity(jwt)) {
        await getCurrentUser();
        print(user.value.name);
      } else {
        logout();
      }
    }
  }

  bool checkJWTValidity(String jwt) {
    return JwtDecoder.isExpired(jwt);
  }

  Future<void> saveJWT(String jwt) async {
    await storage.write(key: 'jwt', value: jwt);
  }

  Future<String?> getJWT() async {
    return storage.read(key: 'jwt');
  }

  Future<void> register(String name, String email, String password,
      String confirmPassword) async {
    var url = Uri.parse('$BASE_URL/Auth/register');

    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
        "confirmPassword": confirmPassword
      }),
    );
    ResponseModel responseModel =
        ResponseModel.fromJson(jsonDecode(response.body));
    if (response.statusCode == 200) {
      isRegistered.value = true;
    } else {
      print('Request failed with status: ${response.statusCode}');
      print('Request failed with message: ${responseModel.message}');
    }
  }

  Future<void> login(String email, String password) async {
    var url = Uri.parse('$BASE_URL/Auth/login');
    isLoggedIn.value = false;
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"email": email, "password": password}),
    );

    ResponseModel responseModel =
        ResponseModel.fromJson(jsonDecode(response.body));

    if (response.statusCode == 200) {
      isLoggedIn.value = true;
      user.value = User.fromJson((responseModel.data)['user']);

      saveJWT((responseModel.data)['accessToken']);
    } else {
      print('Request failed with status: ${response.statusCode}');
      print('Request failed with message: ${responseModel.message}');
    }
  }

  void logout() async {
    storage.delete(key: 'jwt');
    storage.delete(key: 'user');
    isLoggedIn.value = false;
    user.value = User(role: []);
    push(DashboardScreen(),
        isNewTask: true, pageRouteAnimation: PageRouteAnimation.Slide);
  }

  Future<void> verifyIdCard(PostMedia frontId, PostMedia backId) async {
    try {
      isVerifySuccess(false);
      print('verifyIdCard');
      var url = Uri.parse('$BASE_URL/Identify/identity-card');
      var request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] =
          'Bearer ${await storage.read(key: 'jwt')}';

      var frontIdfile = await http.MultipartFile.fromPath(
        'frontIdentityCard',
        frontId.file!.path,
        filename: frontId.file!.path.split('/').last,
        contentType: MediaType('image', 'jpeg'),
      );
      request.files.add(frontIdfile);

      var backIdfile = await http.MultipartFile.fromPath(
        'backIdentityCard',
        backId.file!.path,
        filename: backId.file!.path.split('/').last,
        contentType: MediaType('image', 'jpeg'),
      );
      request.files.add(backIdfile);

      var response = await request.send();
      // ResponseModel responseModel = ResponseModel.fromJson(
      //     jsonDecode(await response.stream.bytesToString()));
      print(await response.stream.bytesToString());
      if (response.statusCode == 200) {
        isVerifySuccess(true);
      } else {
        //message.value = responseModel.data['errorMessage'];
        print('Request failed with status: ${response.statusCode}');
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> verifyFace(PostMedia frontId, PostMedia face) async {
    try {
      isVerifySuccess(false);
      var url = Uri.parse('$BASE_URL/Identify/face-match');
      var request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] =
          'Bearer ${await storage.read(key: 'jwt')}';

      var frontIdfile = await http.MultipartFile.fromPath(
        'frontIdentityCard',
        frontId.file!.path,
        filename: frontId.file!.path.split('/').last,
        contentType: MediaType('image', 'jpeg'),
      );
      request.files.add(frontIdfile);

      var facefile = await http.MultipartFile.fromPath(
        'faceImage',
        face.file!.path,
        filename: face.file!.path.split('/').last,
        contentType: MediaType('image', 'jpeg'),
      );
      request.files.add(facefile);

      var response = await request.send();
      // ResponseModel responseModel = ResponseModel.fromJson(
      //     jsonDecode(await response.stream.bytesToString()));
      print(await response.stream.bytesToString());
      if (response.statusCode == 200) {
        isVerifySuccess(true);
      } else {
        //message.value = responseModel.data['errorMessage'];
        print('Request failed with status: ${response.statusCode}');
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<User> getUserById(String id) async {
    var url = '$BASE_URL/User/$id';
    var response = await GetConnect().get(url);

    if (response.bodyString != null) {
      ResponseModel responseModel =
          ResponseModel.fromJson(jsonDecode(response.bodyString!));

      if (response.statusCode == 200) {
        return user.value = User.fromJson(responseModel.data);
      } else {
        print('Request failed with status: ${response.statusCode}');
        print('Request failed with status: ${responseModel.message}');
        throw Exception('Failed to get User');
      }
    } else {
      throw Exception('Failed to get User');
    }
  }

  Future<User> getCurrentUser() async {
    var url = '$BASE_URL/User/current-info';
    String? token = await storage.read(key: 'jwt');
    var headers = {
      'Authorization': 'Bearer $token',
    };
    var response = await GetConnect().get(url, headers: headers);

    if (response.bodyString != null) {
      ResponseModel responseModel =
          ResponseModel.fromJson(jsonDecode(response.bodyString!));

      if (response.statusCode == 200) {
        return user.value = User.fromJson(responseModel.data);
      } else {
        print('Request failed with status: ${response.statusCode}');
        print('Request failed with status: ${responseModel.message}');
        throw Exception('Failed to get User');
      }
    } else {
      throw Exception('Failed to get User');
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      var url = '$BASE_URL/Auth/forgot-password';
      String? token = await storage.read(key: 'jwt');
      var headers = {
        'Authorization': 'Bearer $token',
      };
      var body = "\"$email\"";
      var response = await GetConnect().post(
        url,
        body,
        headers: headers,
      );

      if (response.statusCode == 200) {
        isUpdateSuccess(true);
      } else {
        isUpdateSuccess(false);
        message.value = response.body['Message'];
        print('Request failed with status: ${response.statusCode}');
        print('Request failed with status: ${response.body['Message']}');
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }
}

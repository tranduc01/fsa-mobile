import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';

import '../models/common_models/user.dart';
import '../screens/dashboard_screen.dart';

class UserController extends GetxController {
  final storage = new FlutterSecureStorage();
  var isLoggedIn = false.obs;
  var isRegistered = false.obs;
  var user = User().obs;

  @override
  void onInit() async {
    super.onInit();
    String? jwt = await getJWT();
    if (jwt != null) {
      isLoggedIn.value = !checkJWTValidity(jwt);
      if (!checkJWTValidity(jwt)) {
        user.value = (await getUser())!;
      } else {
        Logout();
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

  Future<void> saveUser(User user) async {
    String userJson = jsonEncode(user.toJson());
    await storage.write(key: 'user', value: userJson);
  }

  Future<User?> getUser() async {
    String? userJson = await storage.read(key: 'user');
    if (userJson != null) {
      Map<String, dynamic> userMap = jsonDecode(userJson);
      return User.fromJson(userMap);
    }
    return null;
  }

  Future<void> Register(String name, String email, String password,
      String confirmPassword) async {
    var url = Uri.parse('https://orchidsharingapp.somee.com/api/Auth/register');

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

    if (response.statusCode == 200) {
      isRegistered.value = true;
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  Future<void> Login(String email, String password) async {
    var url = Uri.parse('https://orchidsharingapp.somee.com/api/Auth/login');

    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      isLoggedIn.value = true;
      user.value = User.fromJson(jsonDecode(response.body)['user']);
      saveUser(user.value);
      saveJWT(jsonDecode(response.body)['accessToken']);
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  void Logout() async {
    storage.delete(key: 'jwt');
    storage.delete(key: 'user');
    isLoggedIn.value = false;
    user.value = User();
    push(DashboardScreen(),
        isNewTask: true, pageRouteAnimation: PageRouteAnimation.Slide);
  }
}

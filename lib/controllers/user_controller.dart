import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';

import '../models/common_models/user.dart';
import '../screens/dashboard_screen.dart';

class UserController extends GetxController {
  var isLoggedIn = false.obs;
  var isRegistered = false.obs;
  var user = User().obs;

  void Register(String name, String email, String password,
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
      // Request failed, handle the error
      print('Request failed with status: ${response.statusCode}');
    }
  }

  void Login(String email, String password) async {
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
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  void Logout() {
    isLoggedIn.value = false;
    push(DashboardScreen(),
        isNewTask: true, pageRouteAnimation: PageRouteAnimation.Slide);
  }
}

import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';

import '../screens/dashboard_screen.dart';

class UserController extends GetxController {
  var isLoggedIn = false.obs;
  var isRegistered = false.obs;

  void Register(String name, String email, String password,
      String confirmPassword) async {
    var url = Uri.parse('http://orchidsharingapp.somee.com/api/Auth/register');

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
    isLoggedIn.value = true;
    var url = Uri.parse('http://orchidsharingapp.somee.com/api/Auth/login');
    if (email == '123' && password == '123456') {
      isLoggedIn.value = true;
      push(DashboardScreen(),
          isNewTask: true, pageRouteAnimation: PageRouteAnimation.Slide);
    }
  }

  void Logout() {
    isLoggedIn.value = false;
    push(DashboardScreen(),
        isNewTask: true, pageRouteAnimation: PageRouteAnimation.Slide);
  }
}

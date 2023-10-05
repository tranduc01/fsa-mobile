import 'package:get/get.dart';

class UserController extends GetxController {
  var isLoggedIn = false.obs;

  void Login() {
    isLoggedIn.value = true;
  }

  void Logout() {
    isLoggedIn.value = false;
  }
}

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:repo/models/user/index.dart';
import 'package:repo/services/user_service.dart';
import 'package:repo/views/widgets/index.dart';

class SignUpController extends GetxController {
  UserService service = UserService();
  final selectedDivision = ''.obs;

  void setDivision(String division) {
    selectedDivision.value = division;
    update();
  }

  Future<void> signUp(UserRegisterRequest request) async {
    try {
      var response = await service.register(request);
      Get.back();
      snackbarRepoSuccess(response.status, response.message!);
    } catch (e) {
      snackbarRepo('Kesalahan Register', 'Pastikan Data Terisi Dengan Benar.');
    }
  }
}

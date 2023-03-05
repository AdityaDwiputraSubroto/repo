import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/routes/app_routes.dart';
import '../models/user/forgot_password.dart';
import '../services/forgotpass.dart';
import '../views/widgets/snackbar_widget.dart';
import 'package:get/route_manager.dart';

class ForgotPasswordController {
  final emailController = TextEditingController();
  late final BuildContext context;

  Future<void> forgotPassword() async {
    final email = emailController.text.trim();
    final request = ForgotPasswordRequest(email: email);
    bool emailValidation =
        RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
            .hasMatch(email);
    if (email.isEmpty) {
      snackbarRepo('Warning!', 'Email Tidak Boleh Kosong!');
      return;
    } else if (!emailValidation) {
      snackbarRepo('Warning!', 'Email Salah!');
      return;
    }

    try {
      final response = await ForgotPasswordService.forgotPassword(request);
      if (response.status == 'success') {
        Get.offNamed(AppRoutesRepo.forgotVerify);
      } else {
        throw Exception('Gagal melakukan request: ${response.message}');
      }
    } catch (e) {
      snackbarRepo('Error', e.toString());
    }
  }
}

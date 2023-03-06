
import 'package:flutter/material.dart';
import 'package:repo/controllers/forgotpass_controller.dart';
import 'package:repo/core/shared/colors.dart';
import 'package:repo/core/utils/formatting.dart';
import 'package:repo/views/widgets/index.dart';
import 'package:get/get.dart';

import '../../core/routes/app_routes.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final data = Get.arguments;
  final TextEditingController resetPassword = TextEditingController();
  final TextEditingController confirmResetPassword = TextEditingController();
  inputHandler() {
    bool isFilled = true;
    if (resetPassword.text == '' || confirmResetPassword.text == '') {
      snackbarRepo('Warning!', 'Data Tidak Boleh Kosong!');
      isFilled = false;
    } else if (resetPassword.text.length < 8) {
      snackbarRepo('Warning!', 'Password Minimal 8 Karakter !');
      isFilled = false;
    } else if (confirmResetPassword.text.length < 8) {
      snackbarRepo('Warning!', 'Konfirmasi Password Minimal 8 Karakter !');
      isFilled = false;
    } else if (resetPassword.text != confirmResetPassword.text) {
      snackbarRepo('Warning!', 'Data harus sama !');
      isFilled = false;
    }
    return isFilled;
  }

  final controller = ForgotPasswordController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(36, 36, 36, 0),
            child: Column(
              children: [
                const SizedBox(
                  height: 35,
                ),
                const BannerRepo(),
                const SizedBox(
                  height: 24,
                ),
                TextFieldRepo(
                  textController: resetPassword,
                  hintText: 'Password Baru',
                  obscureText: true,
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFieldRepo(
                  textController: confirmResetPassword,
                  hintText: 'Konfirmasi Password Baru',
                  obscureText: true,
                ),
                const SizedBox(
                  height: 12,
                ),
                ButtonRepo(
                  text: 'Reset Password',
                  backgroundColor: ColorsRepo.primaryColor,
                  changeTextColor: false,
                  onPressed: () {
                    if (inputHandler()) {
                      controller.resetPassword(
                          resetPassword.text, confirmResetPassword.text, data);
                    }
                  },
                ),
                TextButton(
                  onPressed: () {
                    Get.offNamed(AppRoutesRepo.login);
                  },
                  child: Text(
                    'Kembali',
                    style: TextStyle(
                      color: hexToColor(ColorsRepo.primaryColor),
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

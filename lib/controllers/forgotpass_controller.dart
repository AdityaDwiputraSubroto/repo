import 'package:get/get.dart';
import '../core/routes/app_routes.dart';
import '../models/user/forgot_password.dart';
import '../services/forgotpass.dart';
import '../views/widgets/snackbar_widget.dart';
import 'package:get/route_manager.dart';

class ForgotPasswordController {
  Future<void> forgotPassword(String email) async {
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
        Get.offNamed(AppRoutesRepo.forgotVerify, arguments: email);
        snackbarRepoSuccess(
            'Succces', 'Kode verifikasi sudah terkirim ke e-mail');
      } else {
        throw Exception('Gagal melakukan request: ${response.message}');
      }
    } catch (e) {
      snackbarRepo('Error', e.toString());
    }
  }

  verifyOTP(String otpCode) async {
    try {
      final response = await ForgotPasswordService.verifyToken(otpCode);
      if (response.status == 'success') {
        Get.offNamed(AppRoutesRepo.resetPasswordScreen,
            arguments: response!.data!);
      }
    } catch (e) {
      snackbarRepo('Error', e.toString());
    }
  }

  resetPassword(
      String password, String confirmPassword, String uniqueToken) async {
    try {
      final response = await ForgotPasswordService.resetPassword(
          password, confirmPassword, uniqueToken);
      if (response.status == 'success') {
        Get.offNamed(AppRoutesRepo.login);
        snackbarRepoSuccess('Success', 'Password anda berhasil direset');
      }
    } catch (e) {
      snackbarRepo('Error', e.toString());
    }
  }
}

import 'package:get/get.dart';
import 'package:repo/core/routes/app_routes.dart';
import 'package:repo/models/user/login.dart';
import 'package:repo/services/user_service.dart';
import 'package:repo/views/widgets/snackbar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  UserService service = UserService();

  Future<void> login(UserLoginRequest userLoginRequest) async {
    final pref = await SharedPreferences.getInstance();

    try {
      var response = await service.login(userLoginRequest);
      if (response.status == 'success') {
        await pref.setBool('logged-in', true);
        await pref.setInt('role', response.data.user.idRole);
        await pref.setString('username', response.data.user.username);
        await pref.setString('refresh-token', response.data.user.refreshToken);
        await pref.setString('access-token', response.data.user.accessToken);
        await pref.setInt('id-user', response.data.user.id);
        Get.offAllNamed(AppRoutesRepo.bottomNavigator);
      }
      if (response.status == 'error') {
        snackbarRepo('Error', response.message);
      }
    } catch (e) {
      snackbarRepo('Kesalahan Login', 'Email/Username/Password Salah');
    }

    update();
  }
}

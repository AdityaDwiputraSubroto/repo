import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:repo/controllers/login_controller.dart';
import 'package:repo/core/shared/colors.dart';
import 'package:repo/core/utils/formatting.dart';
import 'package:repo/core/routes/routes.dart';
import 'package:repo/models/user/login.dart';
import 'package:repo/views/widgets/index.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  nullHandler() {
    bool isFilled = true;
    if (_emailController.text == '' || _passwordController.text == '') {
      snackbarRepo('Warning!', 'Email/Username/Password Tidak Boleh Kosong!');
      isFilled = false;
    }
    return isFilled;
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(
      () => LoginController(),
    );
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(36, 36, 36, 36),
                child: Column(
                  children: [
                    const BannerRepo(),
                    const SizedBox(
                      height: 24,
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Masuk',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextFieldRepo(
                      textController: _emailController,
                      hintText: 'Email/Username',
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFieldRepo(
                      textController: _passwordController,
                      hintText: 'Password',
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.offAllNamed(AppRoutesRepo.forgotPassword);
                      },
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Lupa Kata sandi?',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: hexToColor(ColorsRepo.primaryColor),
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    ButtonRepo(
                      text: 'Masuk',
                      backgroundColor: ColorsRepo.primaryColor,
                      changeTextColor: false,
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        await Future.delayed(const Duration(seconds: 2));
                        if (nullHandler()) {
                          UserLoginRequest request = UserLoginRequest(
                            emailUsername: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                          );
                          Get.find<LoginController>().login(request);
                        }
                        setState(() {
                          isLoading = false;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Belum mempunyai akun? ',
                              style: TextStyle(
                                color: hexToColor(ColorsRepo.darkGray),
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                            ),
                            TextSpan(
                              text: 'Daftar',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.offAllNamed(AppRoutesRepo.signup);
                                },
                              style: TextStyle(
                                color: hexToColor(ColorsRepo.primaryColor),
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isLoading)
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
              child: const Opacity(
                opacity: 0.8,
                child: ModalBarrier(
                  dismissible: false,
                  color: Colors.black,
                ),
              ),
            ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}

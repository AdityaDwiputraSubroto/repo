import 'package:flutter/material.dart';
import 'package:repo/core/shared/colors.dart';
import 'package:repo/core/routes/routes.dart';
import 'package:repo/core/utils/formatting.dart';
import 'package:repo/views/widgets/index.dart';
import 'package:get/get.dart';

import '../../controllers/forgotpass_controller.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  // State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  //
  final controller = ForgotPasswordController();
  final emailController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(36, 36, 36, 0),
            child: Column(
              children: [
                const BannerRepo(),
                const SizedBox(
                  height: 24,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Lupa Kata Sandi',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 20),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFieldRepo(
                  textController: emailController,
                  hintText: 'Masukkan Alamat Email',
                ),
                const SizedBox(
                  height: 12,
                ),
                ButtonRepo(
                  text: 'Kirim',
                  backgroundColor: ColorsRepo.primaryColor,
                  changeTextColor: false,
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    await controller
                        .forgotPassword(emailController.text.trim());
                    setState(() {
                      isLoading = false;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                isLoading
                    ? const CircularProgressIndicator()
                    : const SizedBox.shrink(),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutesRepo.login);
                  },
                  child: Text(
                    'Kembali ke Halaman Masuk',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:repo/controllers/signup_controller.dart';
import 'package:repo/core/constant/assets.dart';
import 'package:repo/core/utils/styles.dart';
import 'package:repo/core/utils/formatting.dart';
import 'package:repo/core/constant/colors.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> _divisi = <String>[
      "Mobile Development",
      "Web Development",
      "Human Resources"
    ];
    SignUpController _signupController = SignUpController();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(35, 35, 35, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      logoITC,
                      height: 88.19999694824219,
                      width: 54.60000228881836,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      "ITC Repository",
                      style: TextStyle(
                        color: convertColor(primaryColor),
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                "Daftar",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: convertColor(secondaryColor),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: convertColor(primaryColor),
                            ),
                          ),
                          hintText: "Nama",
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: convertColor(secondaryColor),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: convertColor(primaryColor),
                            ),
                          ),
                          hintText: "Username",
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: convertColor(secondaryColor),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: convertColor(primaryColor),
                            ),
                          ),
                          hintText: "Email",
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: convertColor(primaryColor),
                                    width: 1))),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(4)),
                            color: convertColor(secondaryColor),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Obx(
                              () => DropdownButton(
                                underline: SizedBox(),
                                isExpanded: true,
                                value: _signupController.selectedDivisi.value ==
                                        ""
                                    ? null
                                    : _signupController.selectedDivisi.value,
                                hint: Text("Divisi"),
                                icon: const Icon(Icons.arrow_drop_down),
                                elevation: 2,
                                dropdownColor: convertColor(secondaryColor),
                                onChanged: (value) {
                                  _signupController.setDivisi(value!);
                                },
                                items: _divisi
                                    .map<DropdownMenuItem<String>>((String e) {
                                  return DropdownMenuItem<String>(
                                    value: e,
                                    child: Text(e),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: convertColor(secondaryColor),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: convertColor(primaryColor),
                            ),
                          ),
                          hintText: "Password",
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 44,
                        width: double.maxFinite,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: raisedButtonStyle(),
                          child: const Text(
                            "Daftar",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Sudah mempunyai akun?"),
                          TextButton(onPressed: () {}, child: Text("Masuk"))
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
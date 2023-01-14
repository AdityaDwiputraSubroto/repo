import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:repo/core/routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  final pref = await SharedPreferences.getInstance();
  var initialRoute = AppRoutesRepo.login;
  final loggedIn = pref.getBool('logged-in') ?? false;
  print(loggedIn);
  if (loggedIn) {
    initialRoute = AppRoutesRepo.bottomNavigator;
    try {
      var resp = await post(
          Uri.parse('${ApiRoutesRepo.baseUrl}/user/refresh-token'),
          body: <String, dynamic>{
            'username': pref.getString('username'),
            'refreshToken': pref.getString('refresh-token')
          });
      var body = jsonDecode(resp.body);
      print(body);
      if (body['status'] == 'success') {
        pref.setString('access-token', body['data']['accessToken']);
      } else {
        initialRoute = AppRoutesRepo.login;
        await pref.setBool('logged-in', false);
        await pref.setInt('role', 0);
        await pref.setString('username', '');
        await pref.setString('refresh-token', '');
        await pref.setString('access-token', '');
      }
    } catch (e) {
      initialRoute = AppRoutesRepo.login;
      await pref.setBool('logged-in', false);
      await pref.setInt('role', 0);
      await pref.setString('username', '');
      await pref.setString('refresh-token', '');
      await pref.setString('access-token', '');
    }
  }
  FlutterNativeSplash.remove();
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      title: 'ITC Repository',
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      getPages: AppRoutesRepo.pages,
    ),
  );
}

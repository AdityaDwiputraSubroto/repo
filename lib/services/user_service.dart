import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/http.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:repo/core/routes/routes.dart';
import 'package:repo/core/utils/base_response.dart';
import 'package:repo/models/user/index.dart';
import 'package:repo/models/user/user.dart';
import 'package:repo/services/course_service.dart';

class UserService extends GetConnect implements GetxService {
  static final client = InterceptedClient.build(
    interceptors: [AuthorizationInterceptor()],
    retryPolicy: ExpiredTokenRetryPolicy(),
  );
  Future login(UserLoginRequest body) async {
    String uri = ApiRoutesRepo.baseUrl + ApiRoutesRepo.login;
    Response response = await post(
      uri,
      body.toJson(),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode != 200) {
      // ignore: avoid_print
      print(response.status);
      return BaseResponseErrorAndMessageOnly.fromJson(response.body);
    }
    return LoginResponse.fromJson(response.body);
  }

  Future<BaseResponseErrorAndMessageOnly> register(
      UserRegisterRequest request) async {
    var response = await http.post(
        Uri.parse(ApiRoutesRepo.baseUrl + ApiRoutesRepo.register),
        body: jsonEncode(request),
        headers: {'Content-Type': 'application/json; charset=UTF-8'});

    var body = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw body['message'] ?? 'Unkown Error';
    }

    return BaseResponseErrorAndMessageOnly.fromJson(body);
  }

  Future<UserOwnProfile> fetchUserById() async {
    // ignore: prefer_typing_uninitialized_variables
    var data;
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var accessToken = sharedPreferences.getString('access-token');
    Uri url = Uri.parse(ApiRoutesRepo.user());
    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 200) {
      data = json.decode(response.body)['data'];
    } else {
      debugPrint('Failed to load user');
    }
    return UserOwnProfile.fromJson(data);
  }

  Future putEditProfileWithImage(String img, String name, String username,
      String email, String division, String generation, String noTelp) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var accessToken = sharedPreferences.getString('access-token');
    String? idDivision;
    if (division == 'Back-end Developer' || division == 'Back-End Developer') {
      idDivision = '1';
    } else if (division == 'Front-end Developer' ||
        division == 'Front-End Developer') {
      idDivision = '2';
    } else if (division == 'Mobile Developer') {
      idDivision = '3';
    } else if (division == 'Public Relations') {
      idDivision = '4';
    } else if (division == 'Project Manager') {
      idDivision = '5';
    }
    var request = http.MultipartRequest(
        'PUT', Uri.parse(ApiRoutesRepo.baseUrl + ApiRoutesRepo.editProfile));

    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer $accessToken',
    });
    request.fields.addAll({
      'fullName': name,
      'phoneNumber': noTelp,
      'id_division': idDivision!,
      'generation': generation
    });
    http.MultipartFile image = await http.MultipartFile.fromPath(
      'image',
      img,
      contentType: MediaType('image', 'jpeg'),
    );
    request.files.add(image);

    http.StreamedResponse response = await request.send();
    var jsonResponse = json.decode(await response.stream.bytesToString());
    return BaseResponseErrorAndMessageOnly.fromJson(jsonResponse);
  }

  Future changePassword(String password) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var accessToken = sharedPreferences.getString('access-token');
    Uri url = Uri.parse(ApiRoutesRepo.baseUrl + ApiRoutesRepo.changePassword);
    final body = jsonEncode({'password': password});
    final response = await http.post(
      url,
      body: body,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
    var data = json.decode(response.body);

    return BaseResponseErrorAndMessageOnly.fromJson(data);
  }
}

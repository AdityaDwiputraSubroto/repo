import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:http_interceptor/http_interceptor.dart';

import 'package:repo/core/routes/api_routes.dart';
import 'package:repo/core/routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/course/course_model.dart';

class CourseService {
  static final client = InterceptedClient.build(
    interceptors: [AuthorizationInterceptor()],
    retryPolicy: ExpiredTokenRetryPolicy(),
  );

  Future<List<CourseResponse>> getAllCourse(int index) async {
    List data = [];
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var accesToken = sharedPreferences.getString('access-token');
    Uri url = Uri.parse(
        ApiRoutesRepo.baseUrl + ApiRoutesRepo.course + index.toString());
    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accesToken',
      },
    );
    if (response.statusCode == 200) {
      data = json.decode(response.body)['data'];
    } else {
      print('Failed to load course');
    }
    return data.map((e) => CourseResponse.fromJson(e)).toList();
  }

  Future<List<CourseResponse>> getCourseByTitle(String title) async {
    List data = [];
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var accesToken = sharedPreferences.getString('access-token');
    Uri url = Uri.parse(ApiRoutesRepo.fetchCourseByTitleUrl(title));
    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accesToken',
      },
    );
    print('getCourseByTitle ${response.statusCode}');
    if (response.statusCode == 200) {
      data = json.decode(response.body)['data'];
    } else {
      Future.delayed(const Duration(seconds: 10), () {
        getCourseByTitle(title);
      });
      print('Failed to load course');
    }
    return data.map((e) => CourseResponse.fromJson(e)).toList();
  }

  Future deleteCourseById(int? idCourse) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var accesToken = sharedPreferences.getString('access-token');
    Uri url = Uri.parse(ApiRoutesRepo.deleteCourse(idCourse!));

    final response = await client.delete(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accesToken',
      },
    );
    var jsonResponse = jsonDecode(response.body);
    return jsonResponse;
  }

  static Future refreshToken() async {
    print('refresh token ni boss');

    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var refreshToken = sharedPreferences.getString('refresh-token');
      var username = sharedPreferences.getString('username');

      var response = await http.post(
        Uri.parse('${ApiRoutesRepo.baseUrl}/user/refresh-token'),
        body: <String, dynamic>{
          'username': username,
          'refreshToken': refreshToken,
        },
      );
      print(response.statusCode);

      var jsonResponse = json.decode(response.body);
      print(jsonResponse['data']);
      sharedPreferences.setString(
          'access-token', jsonResponse['data']['accessToken']);
    } catch (e) {
      throw e;
    }
  }
}

class AuthorizationInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var accesToken = sharedPreferences.getString('access-token');
      data.headers.clear();

      data.headers['authorization'] = 'Bearer ${accesToken!}';
      data.headers['content-type'] = 'application/json';
    } catch (e) {
      throw Exception(e);
    }
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    return data;
  }
}

class ExpiredTokenRetryPolicy extends RetryPolicy {
  @override
  int maxRetryAttempts = 1;

  @override
  Future<bool> shouldAttemptRetryOnResponse(ResponseData response) async {
    if (response.statusCode == 400) {
      CourseService.refreshToken();
      return true;
    }

    return false;
  }
}

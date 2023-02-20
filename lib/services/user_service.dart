import 'package:get/get.dart';
import 'package:http_interceptor/http/http.dart';
import 'package:repo/core/routes/routes.dart';
import 'package:repo/models/user/index.dart';
import 'package:repo/core/utils/base_response.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:repo/models/user/user.dart';
import 'package:repo/services/course_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      print(response.statusCode);
      return BaseResponseErrorAndMessageOnly.fromJson(response.body);
    }

    print(response.statusCode);

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

  Future<UserOwnProfile> fetchUserById(int id) async {
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
      print('Failed to load user');
    }
    return UserOwnProfile.fromJson(data);
  }
}

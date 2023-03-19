import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:repo/core/routes/api_routes.dart';
import 'package:repo/core/utils/base_response.dart';

import '../models/user/forgot_password.dart';

class ForgotPasswordService {
  static const String _baseUrl = ApiRoutesRepo.baseUrl;
  static const String _forgotPasswordEndpoint = ApiRoutesRepo.forgot;

  static Future<ForgotPasswordResponse> forgotPassword(
      ForgotPasswordRequest request) async {
    final url = Uri.parse('$_baseUrl$_forgotPasswordEndpoint');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(request.toJson());

    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      return ForgotPasswordResponse.fromJson(jsonResponse);
    } else {
      throw Exception('Gagal melakukan request: ${response.statusCode}');
    }
  }

  static Future verifyToken(String otpCode) async {
    Uri url = Uri.parse(ApiRoutesRepo.baseUrl + ApiRoutesRepo.verifyToken);

    final response = await http.post(
      url,
      body: {
        'otp': otpCode,
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return VerifyTokenResponse.fromJson(data);
    } else {
      throw Exception('Gagal melakukan request: ${response.statusCode}');
    }
  }

  static Future resetPassword(
      String password, String confirmPassword, String uniqueToken) async {
    Uri url = Uri.parse(ApiRoutesRepo.baseUrl + ApiRoutesRepo.resetPassword);

    final response = await http.post(url, body: {
      'unique_token': uniqueToken,
      'password': password,
      'confirmPassword': confirmPassword,
    });
    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return BaseResponseErrorAndMessageOnly.fromJson(data);
    } else {
      throw Exception('Gagal melakukan request: ${response.statusCode}');
    }
  }
}

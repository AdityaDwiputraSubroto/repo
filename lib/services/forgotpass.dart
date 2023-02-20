import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:repo/core/routes/api_routes.dart';

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
}

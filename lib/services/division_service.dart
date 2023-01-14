import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/routes/api_routes.dart';

class DivisionService {
  Future<Map<String, dynamic>?> getallDivisions() async {
    Uri url = Uri.parse(ApiRoutesRepo.baseUrl + ApiRoutesRepo.division);
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      return jsonResponse;
    } else {
      return null;
    }
  }
}

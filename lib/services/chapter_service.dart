import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:repo/core/routes/api_routes.dart';
import 'package:repo/core/routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/chapter/chapter_model.dart';

class ChapterService {
  Future<List<ChapterResponse>> getAllChapter(int idCourse) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var accesToken = sharedPreferences.getString('access-token');
    Uri url = Uri.parse(ApiRoutesRepo.chapter(idCourse));
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accesToken',
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      List data = json.decode(response.body)['data'];
      return data.map((e) => ChapterResponse.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load chapter');
    }
  }

    Future<String>deleteChapter(int idCourse, int idChapter) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var accesToken = sharedPreferences.getString('access-token');
    Uri url = Uri.parse(ApiRoutesRepo.deleteChapter(idCourse,idChapter));
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accesToken',
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      return "success";
    } else {
      //throw Exception('Failed to load chapter');
      return "failed";
    }
  }
}

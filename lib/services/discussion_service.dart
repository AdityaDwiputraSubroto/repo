import 'dart:convert';

// import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:repo/core/routes/api_routes.dart';
import 'package:repo/core/routes/routes.dart';
import 'package:repo/services/course_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/discussion/DiscussionByCourseId_model.dart';

class DiscussionService {
  static final client = InterceptedClient.build(
    interceptors: [AuthorizationInterceptor()],
    retryPolicy: ExpiredTokenRetryPolicy(),
  );
  Future<List<Datum>> getAllDiscussion(int idCourse) async {
    List data = [];
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var accesToken = sharedPreferences.getString('access-token');
    Uri url = Uri.parse(ApiRoutesRepo.alldiscussionbyid(idCourse));
    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accesToken',
      },
    );
    if (response.statusCode == 200) {
      // print(response.body);
      data = json.decode(response.body)['data'];
    } else {
      Future.delayed(const Duration(seconds: 2), () {
        getAllDiscussion(idCourse);
      });
      throw Exception('Failed to load discussion');
    }
    return data.map((e) => Datum.fromJson(e)).toList();
  }

  // Future<String> deleteChapter(int idCourse, int idChapter) async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   var accesToken = sharedPreferences.getString('access-token');
  //   Uri url = Uri.parse(ApiRoutesRepo.deleteChapter(idCourse, idChapter));
  //   final response = await client.delete(
  //     url,
  //     headers: {
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       'Authorization': 'Bearer $accesToken',
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     print(response.body);
  //     return "success";
  //   } else {
  //     //throw Exception('Failed to load chapter');
  //     return "failed";
  //   }
  // }
}

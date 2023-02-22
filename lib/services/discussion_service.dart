import 'dart:convert';

// import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:repo/core/routes/api_routes.dart';
import 'package:repo/core/routes/routes.dart';
import 'package:repo/core/utils/base_response.dart';
import 'package:repo/models/discussion/discussionByDiscussion_model.dart';
import 'package:repo/services/course_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/discussion/discussion_by_course_id_model.dart';
import '../models/discussion/store_discussion_model.dart';
import 'package:http/http.dart' as http;

class DiscussionService {
  static final client = InterceptedClient.build(
    interceptors: [AuthorizationInterceptor()],
    retryPolicy: ExpiredTokenRetryPolicy(),
  );
  Future<List<DiscussionResponse>> getAllDiscussion(int idCourse) async {
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
    // print('getAllDiscussion ${response.statusCode}');
    if (response.statusCode == 200) {
      data = json.decode(response.body)['data'];
    } else {
      Future.delayed(const Duration(seconds: 2), () {
        getAllDiscussion(idCourse);
      });
      throw Exception('Failed to load discussion');
    }
    return data.map((e) => DiscussionResponse.fromJson(e)).toList();
  }

  Future<List<DiscussionResponse>> searchDiscussion(
      int idCourse, String title) async {
    List data = [];
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var accesToken = sharedPreferences.getString('access-token');
    Uri url = Uri.parse(ApiRoutesRepo.searchDiscussion(idCourse, title));

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
      Future.delayed(const Duration(seconds: 2), () {
        searchDiscussion(idCourse, title);
      });
      throw Exception('Failed to load search discussion');
    }
    return data.map((e) => DiscussionResponse.fromJson(e)).toList();
  }

  Future storeDiscussion(StoreDiscussionRequest request, int idCourse) async {
    Uri uri = Uri.parse(ApiRoutesRepo.storeDiscussion(idCourse));
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var accesToken = sharedPreferences.getString('access-token');
    final response = await http.post(
      uri,
      body: jsonEncode(request),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accesToken',
      },
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      // ignore: avoid_print
      print(response.statusCode);
      //throw Exception('Failed to store discussion');
      throw Exception('Failed to store discussion');
    } else {
      var body = json.decode(response.body);
      return BaseResponseErrorAndMessageOnly.fromJson(body);
    }
  }

  Future deleteDiscussion(int idCourse, int idDiscussion) async {
    Uri uri = Uri.parse(ApiRoutesRepo.deleteDiscussion(idCourse, idDiscussion));
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var accesToken = sharedPreferences.getString('access-token');
    final response = await http.delete(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accesToken',
      },
    );
    var body = jsonDecode(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      print(response.statusCode);
      return BaseResponseErrorAndMessageOnly.fromJson(body);
    } else {
      print(response.statusCode);
      return BaseResponseErrorAndMessageOnly.fromJson(body);
    }
  }
  Future getDiscussionByDiscussionId(int idCourse, int idDiscussion) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Uri url = Uri.parse(ApiRoutesRepo.discussionByDiscussId(idCourse, idDiscussion));
    final response = await client.get(url,headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${sharedPreferences.getString('access-token')}'
    },);
    var data = jsonDecode(response.body);
    var discussionResponse = DiscussionByDiscussionIdResponse.fromJson(data);
    print("from discussionService\n${discussionResponse.data!.title}");
    return discussionResponse;
  
  }
}

import 'dart:convert';

import 'package:http_interceptor/http_interceptor.dart';
import 'package:repo/core/routes/api_routes.dart';
import 'package:repo/core/routes/routes.dart';
import 'package:repo/core/utils/base_response.dart';
import 'package:repo/models/comment/comment_list_response_model.dart';
import 'package:repo/services/course_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/comment/comment_request_model.dart';
import '../models/discussion/discussion_by_course_id_model.dart';
import '../models/discussion/discussion_by_discussion_model.dart';
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

  Future putDiscussion(
      StoreDiscussionRequest request, int idCourse, int idDiscussion) async {
    Uri uri = Uri.parse(ApiRoutesRepo.putDiscussion(idCourse, idDiscussion));
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var accesToken = sharedPreferences.getString('access-token');
    final response = await http.put(
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
      return BaseResponseErrorAndMessageOnly.fromJson(body);
    } else {
      return BaseResponseErrorAndMessageOnly.fromJson(body);
    }
  }

  Future getDiscussionByDiscussionId(int idCourse, int idDiscussion) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Uri url =
        Uri.parse(ApiRoutesRepo.discussionByDiscussId(idCourse, idDiscussion));
    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${sharedPreferences.getString('access-token')}'
      },
    );
    var data = jsonDecode(response.body);
    var discussionResponse = DiscussionByDiscussionIdResponse.fromJson(data);
    return discussionResponse;
  }

  Future getCommentDiscussions(int idCourse, int idDiscussion) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Uri url = Uri.parse(ApiRoutesRepo.getComment(idCourse, idDiscussion));

    final response = await client.get(
      url,
      headers: {
        'Authorization': 'Bearer ${sharedPreferences.getString('access-token')}'
      },
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'];
      return data.map((e) => CommentListResponse.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  Future postCommentDiscussions(
      int idCourse, int idDiscussion, CommentRequest comment) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var accesToken = sharedPreferences.getString('access-token');
    Uri url = Uri.parse(ApiRoutesRepo.postComment(idCourse, idDiscussion));
    await client.post(
      url,
      body: jsonEncode(comment),
      headers: {
        'Authorization': 'Bearer $accesToken',
      },
    );
  }

  Future deleteCommentDiscussions(
      int idCourse, int idDiscussion, int idComment) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var accessToken = sharedPreferences.getString('access-token');

    Uri url = Uri.parse(
        ApiRoutesRepo.deleteComment(idCourse, idDiscussion, idComment));

    await client.delete(url, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessToken',
    });
  }

  Future editCommentDiscussions(int idCourse, int idDiscussion, int idComment,
      CommentRequest editCommentRequest) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var accessToken = sharedPreferences.getString('access-token');

    Uri url =
        Uri.parse(ApiRoutesRepo.editComment(idCourse, idDiscussion, idComment));
    await client.put(
      url,
      body: jsonEncode(editCommentRequest),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken',
      },
    );
  }
}

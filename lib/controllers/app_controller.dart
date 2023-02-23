import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:repo/models/course/course_model.dart';
import 'package:repo/models/discussion/discussion_by_course_id_model.dart';
import 'package:repo/models/division/division_model.dart';
import 'package:repo/models/chapter/chapter_model.dart';
import 'package:repo/models/user/user.dart';
import 'package:repo/services/course_service.dart';
import 'package:repo/services/division_service.dart';
import 'package:repo/services/user_service.dart';
import 'package:repo/services/chapter_service.dart';
import 'package:repo/core/routes/app_routes.dart';
import 'package:repo/views/widgets/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:repo/services/discussion_service.dart';
import 'package:repo/models/discussion/store_discussion_model.dart';

import '../models/user/forgot_password.dart';

class AppController extends GetxController {
  CourseService courseService = CourseService();
  UserService userService = UserService();
  DivisionService divisionService = DivisionService();
  ChapterService chapterService = ChapterService();
  DiscussionService discussionService = DiscussionService();
  DivisionWrapper? allDivisionList;
  UserOwnProfile? userOwnProfile;
  final allCourseList = <CourseResponse>[].obs;
  final allChapterList = <ChapterResponse>[].obs;
  final allChaptersAndTitleArticlesById = <ChapterAndArticleResponse>[].obs;
  final discussionByID = <DiscussionResponse>[].obs;
  List<CourseResponse> allCourse = [];
  var isLoading = false.obs;
  var page = 1.obs;

  @override
  void onInit() {
    fetchUserOwnProfile();
    fetchAllDivisions();
    super.onInit();
  }

  Future<void> fetchAllCourse() async {
    try {
      print('page sebelum $page');
      print('sebelum ${allCourseList.value.length}');
      allCourse = await courseService.getAllCourse(page.value);
      if (allCourse.isNotEmpty) {
        allCourseList.addAll(allCourse);
        allCourseList.refresh();
        allCourseList.toSet().toList();
        page++;
      } else {
        page = page;
      }
      print('sesudah ${allCourseList.value.length}');
      print('page sesudah $page');
    } catch (e) {
      throw Exception(e);
    }
    update();
  }

  fetchAllDivisions() async {
    try {
      var allDivions = await divisionService.getallDivisions();
      if (allDivions != null) {
        allDivisionList = DivisionWrapper.fromJson(allDivions);
      }
    } catch (e) {
      throw Exception(e);
    }
    update();
  }

  Future<List<ChapterResponse>> fetchAllChapter(int idCourse) async {
    try {
      final allChapter = await chapterService.getAllChapter(idCourse);
      if (allChapter.isNotEmpty) {
        allChapterList.assignAll(allChapter);
      }
      return allChapterList;
    } catch (e) {
      throw Exception(e);
    }
  }

  fetchAllChaptersAndTitleArticles(int idCourse) async {
    try {
      isLoading.value = true;
      final allChaptersAndTitleArticles =
          await chapterService.getAllChapterAndTitle(idCourse);
      allChaptersAndTitleArticlesById.assignAll(allChaptersAndTitleArticles);
      isLoading.value = false;
    } catch (e) {
      Future.delayed(
        const Duration(seconds: 4),
        () => fetchAllChaptersAndTitleArticles(idCourse),
      );
      throw Exception(e);
    }
  }

  Future fetchArticleByIdChapterAndIdArticle(
      int idCourse, int idChapter, int idArticle) async {
    try {
      final response = await chapterService.getArticleByIdChapterAndIdArticle(
          idCourse, idChapter, idArticle);
      return response;
    } catch (e) {
      Future.delayed(
        const Duration(seconds: 2),
        () =>
            fetchArticleByIdChapterAndIdArticle(idCourse, idChapter, idArticle),
      );
      throw Exception(e);
    }
  }

  Future fetchAllDiscussionByidCourse(int idCourse) async {
    try {
      final response = await discussionService.getAllDiscussion(idCourse);
      if (response.isEmpty) {
        return null;
      } else {
        return response;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future fetchDiscusionByDiscussionId(int idCourse, int idDiscussion) async {
    try {
      final res = await discussionService.getDiscussionByDiscussionId(
          idCourse, idDiscussion);
      print("fetchdiscussionbyiddisuccion\n\n" + res.toString());
      if (res.status == 'success') {
        return res;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<CourseResponse>> searchCourseByTitle(String title) async {
    try {
      final resultCourse = await courseService.getCourseByTitle(title);
      return resultCourse;
    } catch (e) {
      throw Exception(e);
    }
  }

  void logout() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.remove('logged-in');
    sharedPreferences.remove('role');
    sharedPreferences.remove('username');
    sharedPreferences.remove('refresh-token');
    sharedPreferences.remove('access-token');
    sharedPreferences.remove('id-user');
    sharedPreferences.remove('division-name');
    sharedPreferences.remove('password');
    Get.offAllNamed(AppRoutesRepo.login);
  }

  Future<void> storeDiscussionController(
      StoreDiscussionRequest request, int idCourse) async {
    try {
      var response = await discussionService.storeDiscussion(request, idCourse);
      if (response.status == 'success') {
        snackbarRepoSuccess(response.status, response.message);
      } else {
        snackbarRepo(response.status, response.message);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  fetchUserOwnProfile() async {
    try {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var accessToken = sharedPreferences.getString('access-token');
      Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken!);
      sharedPreferences.setInt('id-user', decodedToken['id']);
      userOwnProfile = await userService.fetchUserById();
      sharedPreferences.setInt('role', userOwnProfile!.idRole!);
      sharedPreferences.setString('username', userOwnProfile!.username!);
      sharedPreferences.setString(
          'division-name', userOwnProfile!.divisionName!);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<DiscussionResponse>> searchDiscussionTitle(
      int idCourse, String title) async {
    try {
      final response =
          await discussionService.searchDiscussion(idCourse, title);
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> deleteDiscussion(
      BuildContext context, int idCourse, int idDiscussion) async {
    try {
      var response =
          await discussionService.deleteDiscussion(idCourse, idDiscussion);
      if (response.status == 'success') {
        snackbarRepoSuccess(response.status, response.message);
      } else {
        snackbarRepo(response.status, response.message);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future editProfileWithImage(
      BuildContext context,
      String img,
      String name,
      String username,
      String email,
      String division,
      String generation,
      String noTelp) async {
    try {
      final response = await userService.putEditProfileWithImage(
          img, name, username, email, division, generation, noTelp);
      if (response.status == 'success') {
        isLoading.value = true;
        snackbarRepoSuccess(response.status, response.message);
        fetchUserOwnProfile();
        Navigator.of(context).pushReplacementNamed(
          '/ubahProfil',
        );
        isLoading.value = false;
      } else {
        snackbarRepo(response.status, response.message);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future changePasswordUser(String password) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final response = await userService.changePassword(password);

    if (response.status == 'success') {
      sharedPreferences.setString('password', password);
      snackbarRepoSuccess(response.status, response.message);
    } else {
      snackbarRepo(response.status, response.message);
    }
  }
}

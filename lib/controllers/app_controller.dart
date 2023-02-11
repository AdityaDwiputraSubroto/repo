import 'package:get/get.dart';
import 'package:repo/models/course/course_model.dart';
import 'package:repo/models/discussion/DiscussionByCourseId_model.dart';
import 'package:repo/models/division/division_model.dart';
import 'package:repo/models/chapter/chapter_model.dart';
import 'package:repo/services/course_service.dart';
import 'package:repo/services/division_service.dart';
import 'package:repo/services/user_service.dart';
import 'package:repo/services/chapter_service.dart';
import 'package:repo/core/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:repo/services/discussion_service.dart';
import 'package:flutter/foundation.dart';
import '../models/user/index.dart';
import 'package:repo/models/discussion/store_discussion_model.dart';

class AppController extends GetxController {
  CourseService courseService = CourseService();
  UserService userService = UserService();
  DivisionService divisionService = DivisionService();
  ChapterService chapterService = ChapterService();

  DiscussionService discussionService = DiscussionService();

  DivisionWrapper? allDivisionList;
  User? userById;
  final allCourseList = <CourseResponse>[].obs;
  final allChapterList = <ChapterResponse>[].obs;
  final allChaptersAndTitleArticlesById = <ChapterAndArticleResponse>[].obs;

  final discussionByID = <Datum>[].obs;

  List<CourseResponse> allCourse = [];
  var isLoading = false.obs;
  int page = 1;

  @override
  void onInit() {
    fetchAllDivisions();
    fetchUserById();
    super.onInit();
  }

  Future<void> fetchAllCourse() async {
    try {
      allCourse = await courseService.getAllCourse(page);
      if (allCourse.isNotEmpty) {
        allCourseList.addAll(allCourse);
        allCourseList.refresh();
        page++;
      } else {
        page = page;
      }
    } catch (e) {
      throw Exception(e);
    }
    update();
  }

  Future<void> fetchAllCourseAfterDelete() async {
    try {
      page = 1;
      allCourse = await courseService.getAllCourse(page);
      if (allCourse.isNotEmpty) {
        allCourseList.value = [];
        allCourseList.assignAll(allCourse);
        allCourseList.refresh();
      }
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

  fetchUserFullNameById(int idUser) async {
    try {
      var fetchUserById = await userService.fetchUserById(idUser);
      return fetchUserById.fullName;
    } catch (e) {
      throw Exception(e);
    }
  }

  fetchUserById() async {
    try {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var idUser = sharedPreferences.getInt('id-user');
      userById = await userService.fetchUserById(idUser!);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<ChapterResponse>> fetchAllChapter(int idCourse) async {
    try {
      final allChapter = await chapterService.getAllChapter(idCourse);
      if (allChapter.isNotEmpty) {
        allChapterList.assignAll(allChapter);
      }
      print(allChapterList);
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

  Future<List<Datum>> TestAlldiscussionById(int idCourse) async {
    try {
      final allDiscussion = await discussionService.getAllDiscussion(idCourse);
      if (allDiscussion.isNotEmpty) {
        discussionByID.assignAll(allDiscussion);
      }
      print(discussionByID);
      return discussionByID;
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

  deleteChapter(int idCourse, int idChapter) async {
    try {
      final response = await chapterService.deleteChapter(idCourse, idChapter);
      Get.offAndToNamed(AppRoutesRepo.bab);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> deleteCourse(int? idCourse) async {
    try {
      final response = await courseService.deleteCourseById(idCourse);
      if (response['status'] == 'success') {
        fetchAllCourseAfterDelete();
      } else {
        print('gagal');
      }
    } catch (e) {
      throw Exception(e);
    }
    update();
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
    Get.offAllNamed(AppRoutesRepo.login);
  }

  Future<void> StoreDiscussionController(
      StoreDiscussionRequest request, int idCourse) async {
    try {
      var response = await discussionService.storeDiscussion(request, idCourse);
      print(response);
    } catch (e) {
      throw Exception(e);
    }
  }
}

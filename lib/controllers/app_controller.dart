import 'package:get/get.dart';
import 'package:repo/models/course/course_model.dart';
import 'package:repo/models/division/division_model.dart';
import 'package:repo/models/chapter/chapter_model.dart';
import 'package:repo/services/course_service.dart';
import 'package:repo/services/division_service.dart';
import 'package:repo/services/user_service.dart';
import 'package:repo/services/chapter_service.dart';
import 'package:repo/core/routes/app_routes.dart';

class AppController extends GetxController {
  CourseService courseService = CourseService();
  UserService userService = UserService();
  DivisionService divisionService = DivisionService();
  ChapterService chapterService = ChapterService();
  DivisionWrapper? allDivisionList;
  String? fullnameById;
  final allCourseList = <CourseResponse>[].obs;
  final allChapterList = <ChapterResponse>[].obs;
  List<CourseResponse> allCourse = [];
  var isLoading = true.obs;
  int page = 1;

  @override
  void onInit() {
    fetchAllDivisions();
    super.onInit();
  }

  Future<void> fetchAllCourse() async {
    try {
      allCourse = await courseService.getAllCourse(page);
      if (allCourse.isNotEmpty) {
        allCourseList.addAll(allCourse);
        allCourseList.refresh();
        page++;
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

  fetchUserById(int idUser) async {
    try {
      var userById = await userService.fetchUserById(idUser);
      fullnameById = userById.data.fullName;
      return fullnameById;
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
        print('berhasil hapus');
      } else {
        print('gagal');
      }
    } catch (e) {
      throw Exception(e);
    }
    update();
  }
}

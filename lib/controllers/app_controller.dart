import 'package:get/get.dart';
import 'package:repo/models/course/course_model.dart';
import 'package:repo/models/division/division_model.dart';
import 'package:repo/services/course_service.dart';
import 'package:repo/services/division_service.dart';
import 'package:repo/services/user_service.dart';

class AppController extends GetxController {
  CourseService courseService = CourseService();
  UserService userService = UserService();
  DivisionService divisionService = DivisionService();
  DivisionWrapper? allDivisionList;
  String? fullnameById;
  final allCourseList = <CourseResponse>[].obs;

  @override
  void onInit() {
    fetchAllDivisions();
    super.onInit();
  }

  Future<List<CourseResponse>> fetchAllCourse() async {
    try {
      final allCourse = await courseService.getAllCourse();
      if (allCourse.isNotEmpty) {
        allCourseList.assignAll(allCourse);
      }
      return allCourseList;
    } catch (e) {
      throw Exception(e);
    }
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
    } catch (e) {
      throw Exception(e);
    }
  }
}

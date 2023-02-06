abstract class ApiRoutesRepo {
  // static const String baseUrl = 'http://34.101.216.127:3000';
  static const String baseUrl = 'http://192.168.56.1:3000';
  static const String login = '/user/login';
  static const String forgot = '/password-reset';
  static const String register = '/user/register';
  static const String division = '/division';
  static const String course = '/course/page/';
  static String user(int id) {
    return '$baseUrl/user/$id';
  }

  static String chapter(int id) {
    return '$baseUrl/course/$id/chapter';
  }

  static String deleteChapter(int idCourse, int idChapter) {
    return '$baseUrl/course/$idCourse/chapter/$idChapter';
  }

  static String deleteCourse(int idCourse) {
    return '$baseUrl/course/$idCourse';
  }
}

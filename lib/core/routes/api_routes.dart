abstract class ApiRoutesRepo {
  static const String baseUrl = 'http://10.0.2.2:3000';
  static const String login = '/users/login';
  static const String forgot = '/password-reset';
  static const String register = '/users/register';
  static const String division = '/divisions';
  static const String course = '/courses/mobile?page=';
  static const String discussion = 'discussions/';
  static const String editProfile = '/users/update';
  static const String changePassword = '/users/changepassword';
  static String user() {
    return '$baseUrl/users/profile';
  }

  static String chapter(int id) {
    return '$baseUrl/courses/$id/chapters';
  }

  static String alldiscussionbyid(int id) {
    return '$baseUrl/courses/$id/discussions';
  }

  static String deleteChapter(int idCourse, int idChapter) {
    return '$baseUrl/courses/$idCourse/chapters/$idChapter';
  }

  static String deleteCourse(int idCourse) {
    return '$baseUrl/courses/$idCourse';
  }

  static String fetchAllChapterAndTitleById(int idCourse) {
    return '$baseUrl/courses/$idCourse/chapters/articles';
  }

  static String fetchCourseByTitleUrl(String title) {
    return '$baseUrl/courses/search?title=$title';
  }

  static String fetchArticleByIdChapterAndIdArticle(
      int idCourse, int idChapter, int idArticle) {
    return '$baseUrl/courses/$idCourse/chapters/$idChapter/articles/$idArticle';
  }

  static String storeDiscussion(int idCourse) {
    return '$baseUrl/courses/$idCourse/discussions';
  }

  static String searchDiscussion(int idCourse, String title) {
    return '$baseUrl/courses/$idCourse/discussions/search?keyword=$title';
  }

  static String deleteDiscussion(int idCourse, int idDiscussion) {
    return '$baseUrl/courses/$idCourse/discussions/$idDiscussion';
  }
}

abstract class ApiRoutesRepo {
  // static const String baseUrl = 'http://34.101.216.127:3000';
  //static const String baseUrl = 'http://192.168.56.1:3000';
  static const String baseUrl = 'http://192.168.56.1:3000';
  static const String login = '/users/login';
  static const String forgot = '/password-reset';
  static const String register = '/users/register';
  static const String division = '/divisions';
  static const String course = '/courses/page/';
  static const String discussion = 'discussions/';
  static String user(int id) {
    return '$baseUrl/users/${id.toString()}';
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
    return '$baseUrl/courses/search/$title';
  }

  static String fetchArticleByIdChapterAndIdArticle(
      int idCourse, int idChapter, int idArticle) {
    return '$baseUrl/courses/$idCourse/chapters/$idChapter/articles/$idArticle';
  }

  static String StoreDiscussion(int idCourse) {
    return '$baseUrl/courses/$idCourse/discussions';
  }
}

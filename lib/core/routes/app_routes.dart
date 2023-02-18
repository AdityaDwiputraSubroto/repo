import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:repo/views/screens/article_nav_screen.dart';
import 'package:repo/views/screens/detail_course_screen.dart';
import 'package:repo/views/screens/forgot_pass_msg.dart';
import 'package:repo/views/screens/index.dart';
import 'package:repo/views/widgets/bottom_navigation_widget.dart';
import 'package:repo/views/screens/discussion_list_screen.dart';

abstract class AppRoutesRepo {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgotpass';
  static const String pertanyaan = '/pertanyaan';
  static const String bottomNavigator = '/bottomNavigator';
  static const String forgotPasswordMassage = '/forgotpassmsg';
  static const String detailMateri = '/detailMateri';
  static const String articleNav = '/articleNav';
  static const String diskusimateri = '/diskusimateri';

  static List<GetPage<Widget>> pages = [
    GetPage(
      name: login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: signup,
      page: () => const SignUpScreen(),
    ),
    GetPage(
      name: forgotPassword,
      page: () => const ForgotPasswordScreen(),
    ),
    GetPage(
      name: forgotPasswordMassage,
      page: () => const ForgotPasswordMsg(),
    ),
    GetPage(
      name: pertanyaan,
      page: () => const PertanyaanScreen(),
    ),
    GetPage(
      name: bottomNavigator,
      page: () => const BottomNavRepo(),
    ),
    GetPage(
      name: detailMateri,
      page: () => const DetailCourseScreen(),
    ),
    GetPage(
      name: articleNav,
      page: () => const ArticleNavScreen(),
    ),
    GetPage(
      name: diskusimateri,
      page: () => const DiscussionListScreen(),
    )
  ];
}

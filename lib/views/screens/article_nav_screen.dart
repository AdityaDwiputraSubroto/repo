import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:repo/core/shared/assets.dart';
import 'package:repo/core/shared/colors.dart';
import 'package:repo/core/utils/formatting.dart';
import 'package:repo/views/screens/article_screen.dart';
import 'package:repo/views/screens/discussion_list_screen.dart';

import '../../core/routes/app_routes.dart';
import '../widgets/accordion_widget.dart';

class ArticleNavScreen extends StatefulWidget {
  const ArticleNavScreen({super.key});

  @override
  State<ArticleNavScreen> createState() => _ArticleNavScreenState();
}

class _ArticleNavScreenState extends State<ArticleNavScreen> {
  final courseArticle = Get.arguments['courseArticle'];
  final courseId = Get.arguments['courseId'];
  final courseTitle = Get.arguments['courseTitle'];
  final listIdChapter = Get.arguments['listIdChapter'];
  final listIdArticle = Get.arguments['listIdArticle'];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              padding: const EdgeInsets.only(right: 20),
              onPressed: () {
                Get.toNamed(
                  AppRoutesRepo.diskusimateri,
                  arguments: {
                    'courseId': courseId,
                    'judul': courseTitle,
                  },
                );
              },
              icon: SvgPicture.asset(
                AssetsRepo.commentIcon,
                height: 20,
              ),
            )
          ],
          title: Text(courseTitle),
          backgroundColor: hexToColor(ColorsRepo.primaryColor),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                text: 'Materi',
              ),
              Tab(
                text: 'Daftar',
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ArticleScreen(
              listIdArticle: listIdArticle,
              listIdChapter: listIdChapter,
              idCourse: courseId,
            ),
            DaftarMateri(
              courseArticle: courseArticle,
              listIdChapter: listIdChapter,
              listIdArticle: listIdArticle,
              idCourse: courseId,
            ),
          ],
        ),
      ),
    );
  }
}

class DaftarMateri extends StatelessWidget {
  List? listIdChapter;
  List? listIdArticle;

  int? idCourse;

  DaftarMateri({
    super.key,
    this.courseArticle,
    this.listIdChapter,
    this.listIdArticle,
    this.idCourse,
  });
  final courseArticle;
  bool isOnTap = true;
  @override
  Widget build(BuildContext context) {
    List<String> articleTitle = [];
    for (var i = 0; i < courseArticle.length; i++) {
      for (var j = 0; j < courseArticle.elementAt(i).articles.length; j++) {
        articleTitle
            .add(courseArticle.elementAt(i).articles.elementAt(j).title);
      }
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Daftar Materi',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: courseArticle.length,
                primary: false,
                itemBuilder: (context, index) {
                  return AccordionJudulBab(
                    isOnTap: true,
                    artikel: courseArticle.elementAt(index).articles.length,
                    articleTitle: articleTitle,
                    chapterTitle: courseArticle.elementAt(index).title,
                    idCourse: idCourse,
                    idChapter: listIdChapter!.isNotEmpty
                        ? listIdChapter!.elementAt(index)
                        : -1,
                    idArticle:
                        listIdArticle!.isNotEmpty ? listIdArticle! : null,
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

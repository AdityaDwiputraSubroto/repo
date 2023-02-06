import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:repo/core/shared/assets.dart';
import 'package:repo/core/shared/colors.dart';
import 'package:repo/core/utils/formatting.dart';
import 'package:repo/views/screens/article_screen.dart';
import 'package:repo/views/screens/discussion_list_screen.dart';

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
                Get.to(() => const DiscussionListScreen());
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
            DaftarMateri(courseArticle: courseArticle),
          ],
        ),
      ),
    );
  }
}

class DaftarMateri extends StatelessWidget {
  const DaftarMateri({super.key, this.courseArticle});
  final courseArticle;
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
                  return accordionJudulBab(
                    context,
                    courseArticle.elementAt(index).articles.length,
                    courseArticle.elementAt(index).title,
                    articleTitle,
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

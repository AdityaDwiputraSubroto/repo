import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:repo/controllers/app_controller.dart';
import 'package:repo/core/utils/formatting.dart';
import 'package:repo/views/widgets/button_widget.dart';

import '../../core/shared/colors.dart';

class ArticleScreen extends StatefulWidget {
  List? listIdChapter;
  List? listIdArticle;
  int? idCourse;
  ArticleScreen({
    super.key,
    this.idCourse,
    this.listIdChapter,
    this.listIdArticle,
  });

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  final appController = Get.put(AppController());
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: appController.fetchArticleByIdChapterAndIdArticle(
            widget.idCourse!,
            widget.listIdChapter![pageIndex],
            widget.listIdArticle![pageIndex]),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Html(
              data: '''${snapshot.data['body']} ${snapshot.data['id']}''',
              style: {
                'body': Style(
                  fontSize: FontSize(18.0),
                  fontWeight: FontWeight.bold,
                ),
              },
            );
          }
        },
      ),
      bottomNavigationBar: navbar(context),
    );
  }

  Widget navbar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                  side: BorderSide(color: Colors.grey.shade100),
                ),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
            onPressed: pageIndex == 0
                ? null
                : () {
                    setState(() {
                      pageIndex--;
                    });
                  },
            child: Container(
              alignment: Alignment.center,
              height: 60,
              width: MediaQuery.of(context).size.width / 2.39,
              child: Text(
                'Kembali',
                style: TextStyle(
                  color: hexToColor(ColorsRepo.primaryColor),
                ),
              ),
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                  side: BorderSide(color: Colors.grey.shade100),
                ),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
            onPressed: pageIndex == widget.listIdArticle!.length - 1
                ? null
                : () {
                    setState(() {
                      pageIndex++;
                    });
                  },
            child: Container(
              alignment: Alignment.center,
              height: 60,
              width: MediaQuery.of(context).size.width / 2.39,
              child: Text(
                'Selanjutnya',
                style: TextStyle(
                  color: hexToColor(ColorsRepo.primaryColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

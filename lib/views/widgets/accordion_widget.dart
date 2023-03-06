// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:repo/views/screens/article_screen.dart';

import '../../core/shared/colors.dart';
import '../../core/utils/formatting.dart';

// ignore: must_be_immutable
class AccordionJudulBab extends StatelessWidget {
  int? artikel;
  String? chapterTitle;
  List<String>? articleTitle;
  bool isOnTap;
  int? idCourse;
  int? idChapter;
  List? dataArticle;
  AccordionJudulBab({
    Key? key,
    this.artikel,
    this.chapterTitle,
    this.articleTitle,
    required this.isOnTap,
    this.idCourse,
    this.idChapter,
    this.dataArticle,
  }) : super(key: key);
  void scrollToSelectedContent({GlobalKey? expansionTileKey}) {
    final keyContext = expansionTileKey!.currentContext;
    if (keyContext != null) {
      Future.delayed(const Duration(milliseconds: 210)).then((value) {
        Scrollable.ensureVisible(keyContext,
            duration: const Duration(milliseconds: 200));
      });
    }
  }

  final GlobalKey expansionTileKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor: Colors.white,
      ),
      child: Column(
        children: [
          Container(
            color: hexToColor(ColorsRepo.primaryColor),
            child: ExpansionTile(
              key: expansionTileKey,
              title: Text(
                chapterTitle!,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              iconColor: Colors.white,
              backgroundColor: hexToColor(ColorsRepo.primaryColor),
              children: [
                Container(
                  color: Colors.white,
                  child: ListView.separated(
                    shrinkWrap: true,
                    primary: false,
                    separatorBuilder: (context, index) {
                      return const Divider(
                        indent: 18,
                        thickness: 2,
                        height: 0.5,
                      );
                    },
                    itemCount: artikel!,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          'Artikel # ${index + 1}',
                          style: const TextStyle(
                            fontSize: 10,
                          ),
                        ),
                        subtitle: Text(
                          dataArticle![index].title,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                          maxLines: 1,
                        ),
                        onTap: isOnTap
                            ? () {
                                Get.to(
                                  () => ArticleScreenOnTap(
                                    idArticle: dataArticle!.elementAt(index).id,
                                    idChapter:
                                        dataArticle!.elementAt(index).idChapter,
                                    idCourse: idCourse,
                                    articleTitle:
                                        dataArticle!.elementAt(index).title,
                                    chapterTitle: chapterTitle,
                                  ),
                                );
                              }
                            : null,
                      );
                    },
                  ),
                ),
              ],
              onExpansionChanged: (value) {
                if (value) {
                  scrollToSelectedContent(expansionTileKey: expansionTileKey);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

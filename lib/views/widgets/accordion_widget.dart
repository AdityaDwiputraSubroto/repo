import 'package:flutter/material.dart';

import '../../core/shared/colors.dart';
import '../../core/utils/formatting.dart';

Widget accordionJudulBab(BuildContext context, int? artikel,
    String chapterTitle, List<String> articleTitle) {
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
              chapterTitle,
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
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          'Artikel # ${index + 1}',
                          style: const TextStyle(
                            fontSize: 10,
                          ),
                        ),
                        subtitle: Text(
                          articleTitle[index],
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        onTap: () {},
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider(
                        indent: 18,
                        thickness: 2,
                        height: 0.5,
                      );
                    },
                    itemCount: artikel!),
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

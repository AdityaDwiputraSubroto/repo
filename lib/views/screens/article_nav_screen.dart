import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:repo/core/shared/colors.dart';
import 'package:repo/core/utils/formatting.dart';
import 'package:repo/views/screens/article_screen.dart';

class ArticleNavScreen extends StatefulWidget {
  const ArticleNavScreen({super.key});

  @override
  State<ArticleNavScreen> createState() => _ArticleNavScreenState();
}

class _ArticleNavScreenState extends State<ArticleNavScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('[Judul Materi]'),
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
        body: const TabBarView(
          children: [
            ArticleScreen(),
            Center(
              child: Text('Accordion Materi'),
            )
          ],
        ),
      ),
    );
  }
}

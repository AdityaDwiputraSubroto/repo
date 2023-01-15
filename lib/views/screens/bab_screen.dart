import 'package:flutter/material.dart';
import 'package:repo/core/shared/colors.dart';
import 'package:repo/core/utils/formatting.dart';
import 'package:repo/views/widgets/index.dart';
import 'package:repo/controllers/app_controller.dart';
import 'package:repo/models/chapter/chapter_model.dart';
import 'package:get/get.dart';
import 'dart:core';

class BabScreen extends StatefulWidget {
  const BabScreen({super.key});

  @override
  State<BabScreen> createState() => _BabScreenState();
}

class _BabScreenState extends State<BabScreen> {
  final appController = Get.put(AppController());
  int idCourse = 1;
  String title = "Python Dasar";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hexToColor(ColorsRepo.lightGray),
      appBar: AppBar(
        title: Text(title),
        backgroundColor: hexToColor(ColorsRepo.primaryColor),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
        ],
      ),
      body: SafeArea(
            child: FutureBuilder(
                future: appController.fetchAllChapter(idCourse),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      snapshot.data == null) {
                    return const Center(
                      heightFactor: 10,
                      child: CircularProgressIndicator(),
                    );
                  } else {

                    List<ChapterResponse>? chapter = snapshot.data;
                     return Padding(
          padding: EdgeInsets.all(18),
            child : Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                      children : [
                        SizedBox(height:8),
                        Text('Daftar Bab',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
                        Padding(padding: EdgeInsets.only(top: 10),
                          child: Text('${chapter!.length} Bab | 0 Artikel', style: TextStyle(color: hexToColor(ColorsRepo.darkGray),fontSize: 18),
                 ),),
                      ListView.builder(
                      shrinkWrap: true,
                        itemCount: chapter!.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {print('${chapter[index].title}');},
                      child: Padding(
                              padding: EdgeInsets.only(top:10, bottom: 10),
                              child: BabItemWidget(
                                idCourse : chapter[index].idCourse,
                                idChapter: chapter[index].id,
                                title: chapter[index].title
                                ),
                            ),
                );}
                )
                ]
                ));}
                }
                )
      ),
    );
  }
}

import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:repo/core/shared/colors.dart';
import 'package:repo/core/utils/formatting.dart';
import 'package:repo/controllers/app_controller.dart';
import 'package:get/get.dart';

class BabItemWidget extends StatelessWidget {
  final String? title;
  final int? idCourse;
  final int? idChapter;
  
  const BabItemWidget(
  {Key? key, 
   required this.title,
   required this.idCourse,
   required this.idChapter,
   }) : 
   super(key: key);
  
 

  @override
  
  Widget build(BuildContext context) {
    final appController = Get.put(AppController());
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: hexToColor(ColorsRepo.secondaryColor),
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset(1, 1),
            ),
          ]),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text("$title",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),)),
                PopupMenuButton<String>(
                  onSelected: popmenuClicked,
                  itemBuilder: (BuildContext context) {
                    return {0}.map((int choice) {
                      return PopupMenuItem<String>(
                        value: choice.toString(),
                        child: Text('Hapus'),
                      );
                    }).toList();
                  },
                ),
              ],
            ),
            Text(
              "0 Artikel",
              style: TextStyle(color: hexToColor(ColorsRepo.darkGray),fontWeight: FontWeight.w500,fontSize: 16,),
            ),
           
          ],
        ),
      ),
    );
  }

  popmenuClicked(dynamic param) {
    param = int.parse(param);
    if (param ==0) {
       Get.find<AppController>().deleteChapter(idCourse!,idChapter!);
      print('Hapus');
    }
  
  }
}

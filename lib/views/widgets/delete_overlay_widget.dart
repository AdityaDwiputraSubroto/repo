import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:repo/controllers/app_controller.dart';

import '../../core/routes/app_routes.dart';
import '../../core/shared/colors.dart';
import '../../core/utils/formatting.dart';

showAlertDialog(
    BuildContext context, int idCourse, int idDiscussion, String title) {
  print(idCourse);
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text(
      'Kembali',
      style: TextStyle(
        color: hexToColor(ColorsRepo.primaryColor),
      ),
    ),
    onPressed: () {
      Get.back();
    },
  );
  Widget deleteButton = TextButton(
    child: Text(
      'Hapus',
      style: TextStyle(
        color: hexToColor(ColorsRepo.primaryColor),
      ),
    ),
    onPressed: () {
      Get.find<AppController>().deleteDiscussion(idCourse, idDiscussion);
      Get.back();
      Get.back();
      Get.toNamed(AppRoutesRepo.diskusimateri, arguments: {
        'courseId': idCourse,
        'judul': title,
      });
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    content: const Text('Hapus Komentar? '),
    actions: [
      cancelButton,
      deleteButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

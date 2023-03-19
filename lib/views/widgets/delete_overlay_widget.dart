import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:repo/controllers/app_controller.dart';

import '../../core/routes/app_routes.dart';
import '../../core/shared/colors.dart';
import '../../core/utils/formatting.dart';

deleteOverlayDiskusi(
    BuildContext context, int idCourse, int idDiscussion, String title) {
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
    onPressed: () async {
      Get.find<AppController>()
          .deleteDiscussion(context, idCourse, idDiscussion);
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pop(context);
      Navigator.of(context).pushReplacementNamed(
        AppRoutesRepo.diskusimateri,
        arguments: {
          'courseId': idCourse,
          'judul': title,
        },
      );
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    content: const Text('Hapus Diskusi ? '),
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

deleteOverlayKomentarBox(
    BuildContext context, int idCourse, int idDiscussion, String title) {
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
    onPressed: () async {
      Get.find<AppController>()
          .deleteDiscussion(context, idCourse, idDiscussion);
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.of(context).pushReplacementNamed(
        AppRoutesRepo.diskusimateri,
        arguments: {
          'courseId': idCourse,
          'judul': title,
        },
      );
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    content: const Text('Hapus Diskusi ? '),
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

deleteOverlayComment(BuildContext context, int idCourse, int idDiscussion,
    String title, int idComment) {
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
      Get.find<AppController>()
          .deleteComment(idCourse, idDiscussion, idComment);
      Navigator.pop(context);
      Navigator.of(context).pushReplacementNamed(
        AppRoutesRepo.pertanyaan,
        arguments: {
          'courseId': idCourse,
          'discussionId': idDiscussion,
          'titleCourse': title,
        },
      );
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    content: const Text('Hapus Komentar ? '),
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

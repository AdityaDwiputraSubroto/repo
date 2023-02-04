import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/shared/colors.dart';
import '../../core/utils/formatting.dart';

showAlertDialog(BuildContext context) {
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
    onPressed: () {},
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

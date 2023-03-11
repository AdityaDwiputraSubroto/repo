import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:repo/views/widgets/text_field_widget.dart';

import '../../controllers/app_controller.dart';
import '../../core/routes/app_routes.dart';
import '../../core/shared/colors.dart';
import '../../core/utils/formatting.dart';
import '../../models/comment/comment_request_model.dart';

editOverlayComment(BuildContext context, int idCourse, int idDiscussion,
    String title, int idComment, String komentar) {
  late TextEditingController editCommentController =
      TextEditingController(text: komentar);
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
  Widget sendButton = TextButton(
    child: Text(
      'Kirim',
      style: TextStyle(
        color: hexToColor(ColorsRepo.primaryColor),
      ),
    ),
    onPressed: () {
      CommentRequest editCommentRequest =
          CommentRequest(body: editCommentController.text);
      Get.find<AppController>()
          .editComment(idCourse, idDiscussion, idComment, editCommentRequest);
      Get.back();
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
    content: TextFieldRepo(
      textController: editCommentController,
      hintText: 'Komentar',
      multiLine: true,
    ),
    actions: [
      cancelButton,
      sendButton,
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

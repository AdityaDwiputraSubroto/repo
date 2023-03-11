import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:repo/core/routes/app_routes.dart';
import 'package:repo/core/shared/colors.dart';
import 'package:repo/core/utils/formatting.dart';
import 'package:repo/views/widgets/index.dart';
import 'package:repo/models/discussion/store_discussion_model.dart';
import 'package:repo/controllers/app_controller.dart';

class EditQuestionScreen extends StatefulWidget {
  const EditQuestionScreen({super.key});

  @override
  State<EditQuestionScreen> createState() => _EditQuestionScreenState();
}

class _EditQuestionScreenState extends State<EditQuestionScreen> {
  final appController = Get.put(AppController());
  final idCourse = Get.arguments['idCourse'];
  final title = Get.arguments['title'];
  final titleDiscussion = Get.arguments['titleDiscussion'];
  final bodyDiscussion = Get.arguments['bodyDiscussion'];
  final idDiscussion = Get.arguments['idDiscussion'];
  late final TextEditingController judulController =
      TextEditingController(text: titleDiscussion);
  late final TextEditingController deskripsiController =
      TextEditingController(text: bodyDiscussion);

  nullHandler() {
    bool isFilled = true;
    if (judulController.text == '' || deskripsiController.text == '') {
      snackbarRepo('Warning!', 'Judul dan Deskripsi Wajib Terisi');
      isFilled = false;
    } else if (judulController.text.length < 4 ||
        deskripsiController.text.length < 4) {
      snackbarRepo('Warning!', 'Isi Judul dan Deskripsi Minimal 4 Karakter');
      isFilled = false;
    }
    return isFilled;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            Navigator.of(context).pushReplacementNamed(
              AppRoutesRepo.diskusimateri,
              arguments: {
                'courseId': idCourse,
                'judul': title,
              },
            );
          },
        ),
        backgroundColor: hexToColor(ColorsRepo.primaryColor),
        title: const Text('Tambah Pertanyaan'),
        actions: [
          IconButton(
            onPressed: () {
              if (nullHandler()) {
                StoreDiscussionRequest request = StoreDiscussionRequest(
                  title: judulController.text.trim(),
                  body: deskripsiController.text.trim(),
                );
                Get.find<AppController>().putDiscussionController(
                  request,
                  idCourse,
                  idDiscussion,
                );
              }
            },
            icon: const Icon(Icons.send),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          children: [
            TextFieldRepo(
              textController: judulController,
              hintText: 'Judul',
            ),
            const SizedBox(
              height: 12,
            ),
            TextFieldRepo(
              textController: deskripsiController,
              hintText: 'Deskripsi',
              multiLine: true,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:repo/core/shared/colors.dart';
import 'package:repo/core/utils/formatting.dart';
import 'package:repo/views/screens/discussion_list_screen.dart';
import 'package:repo/views/widgets/index.dart';
import 'package:repo/models/discussion/store_discussion_model.dart';
import 'package:repo/controllers/app_controller.dart';

class AddQuestionScreen extends StatefulWidget {
  const AddQuestionScreen({super.key});

  @override
  State<AddQuestionScreen> createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final TextEditingController judulController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();
  final appController = Get.put(AppController());
  final idCourse = Get.arguments['idCourse'];
  final title = Get.arguments['title'];

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
        backgroundColor: hexToColor(ColorsRepo.primaryColor),
        title: const Text('Tambah Pertanyaan'),
        actions: [
          IconButton(
            onPressed: () {
              print('send message');
              if (nullHandler()) {
                StoreDiscussionRequest request = StoreDiscussionRequest(
                  title: judulController.text.trim(),
                  body: deskripsiController.text.trim(),
                );
                Get.find<AppController>()
                    .StoreDiscussionController(request, idCourse);
                Get.to(
                  DiscussionListScreen(),
                  arguments: {'courseId': idCourse, 'judul': title},
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

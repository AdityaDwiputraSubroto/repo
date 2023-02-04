import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:repo/core/shared/colors.dart';
import 'package:repo/core/utils/formatting.dart';
import 'package:repo/views/screens/discussion_list_screen.dart';
import 'package:repo/views/widgets/index.dart';

class AddQuestionScreen extends StatefulWidget {
  const AddQuestionScreen({super.key});

  @override
  State<AddQuestionScreen> createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final TextEditingController judulController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();
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
              Get.to(() => const DiscussionListScreen());
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

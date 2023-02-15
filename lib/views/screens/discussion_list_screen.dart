import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:repo/core/routes/app_routes.dart';
import 'package:repo/core/shared/assets.dart';
import 'package:repo/core/shared/colors.dart';
import 'package:repo/core/utils/formatting.dart';
import 'package:repo/views/screens/index.dart';

import '../widgets/delete_overlay_widget.dart';
import 'add_question_screen.dart';

import 'package:repo/controllers/app_controller.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class DiscussionListScreen extends StatefulWidget {
  const DiscussionListScreen({super.key});

  @override
  State<DiscussionListScreen> createState() => _DiscussionListScreenState();
}

class _DiscussionListScreenState extends State<DiscussionListScreen> {
  final appController = Get.put(AppController());
  final courseid = Get.arguments['courseId'];
  final title = Get.arguments['judul'];
  var role;

  @override
  void initState() {
    SharedPreferences.getInstance().then((value) {
      setState(() {
        role = value.getInt('role');
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('courseid : $courseid');
    debugPrint('title : $title');
    return Scaffold(
      backgroundColor: hexToColor(ColorsRepo.lightGray),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: hexToColor(ColorsRepo.primaryColor),
        title: Text('$title'),
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 20),
            onPressed: () {},
            icon: const Icon(
              Icons.search_outlined,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: appController.fetchAllDiscussionByidCourse(courseid),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.data == 'Tidak ada data') {
                return const Center(
                  heightFactor: 10,
                  child: CircularProgressIndicator(),
                );
              } else {
                return Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Diskusi',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 1.21,
                        child: ListView.separated(
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 12,
                            );
                          },
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Get.toNamed(AppRoutesRepo.pertanyaan);
                              },
                              child: Container(
                                height: 178,
                                width: MediaQuery.of(context).size.width,
                                padding:
                                    const EdgeInsets.fromLTRB(12, 6, 8, 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: const Offset(0, 3),
                                      blurStyle: BlurStyle.outer,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        // ClipRRect(
                                        //   borderRadius: BorderRadius.circular(2),
                                        //   child: CachedNetworkImage(
                                        //     imageUrl: '',
                                        //     imageBuilder: (context, imageProvider) =>
                                        //         Container(
                                        //       height: 32,
                                        //       width: 32,
                                        //       decoration: BoxDecoration(
                                        //         image: DecorationImage(
                                        //           image: imageProvider,
                                        //           fit: BoxFit.fill,
                                        //         ),
                                        //       ),
                                        //     ),
                                        //     placeholder: (context, url) => Container(
                                        //       alignment: Alignment.center,
                                        //       color: Colors.grey.shade200,
                                        //       height: 32,
                                        //       width: 32,
                                        //       child: Icon(
                                        //         Icons.person,
                                        //         color: Colors.grey.shade400,
                                        //       ),
                                        //     ),
                                        //     errorWidget: (context, url, error) =>
                                        //         Container(
                                        //       color: Colors.grey.shade200,
                                        //       child: Icon(
                                        //         Icons.person,
                                        //         color: Colors.grey.shade400,
                                        //         size: 32,
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              snapshot
                                                  .data![index].user.fullName,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              DateFormat('dd/MM/yyyy').format(
                                                  DateTime.parse(snapshot
                                                      .data![index].createdAt)),
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: hexToColor(
                                                    ColorsRepo.darkGray),
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 99,
                                        ),
                                        PopupMenuButton(
                                          padding: EdgeInsets.all(0),
                                          itemBuilder: (BuildContext context) =>
                                              [
                                            PopupMenuItem(
                                              value: '',
                                              child: const Text(
                                                  'Laporkan Pertanyaan'),
                                              onTap: () {
                                                print('Laporkan Pertanyaan');
                                              },
                                            ),
                                            PopupMenuItem(
                                              value: '',
                                              child: const Text('Hapus'),
                                              onTap: () {
                                                Future.delayed(
                                                  const Duration(seconds: 0),
                                                  () =>
                                                      showAlertDialog(context),
                                                );
                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      snapshot.data![index].title,
                                      maxLines: 1,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      snapshot.data![index].body,
                                      maxLines: 3,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                );
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //Get.to(() => const AddQuestionScreen());
          Get.to(
            AddQuestionScreen(),
            arguments: {'idCourse': courseid, 'title': title},
          );
        },
        backgroundColor: hexToColor(ColorsRepo.primaryColor),
        child: const Icon(Icons.add),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:repo/controllers/app_controller.dart';
import 'package:repo/core/shared/colors.dart';
import 'package:repo/core/utils/formatting.dart';
import 'package:repo/models/comment/comment_request_model.dart';
import 'package:repo/views/widgets/index.dart';
import 'package:get/get.dart';
import 'package:repo/views/widgets/komentar_box_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PertanyaanScreen extends StatefulWidget {
  const PertanyaanScreen({super.key});
  static bool isLoading = false;

  @override
  State<PertanyaanScreen> createState() => _PertanyaanScreenState();
}

class _PertanyaanScreenState extends State<PertanyaanScreen> {
  final _appController = Get.put(AppController());
  final courseId = Get.arguments['courseId'];
  final discussionId = Get.arguments['discussionId'];
  final courseTitle = Get.arguments['titleCourse'];
  TextEditingController commentController = TextEditingController();

  // ignore: prefer_typing_uninitialized_variables
  var idUser;
  @override
  void initState() {
    SharedPreferences.getInstance().then((value) {
      setState(() {
        idUser = value.getInt('id-user');
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pertanyaan'),
        backgroundColor: hexToColor(ColorsRepo.primaryColor),
      ),
      body: SafeArea(
        child: Container(
          color: hexToColor(ColorsRepo.lightGray),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 55),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: FutureBuilder(
                    future: _appController.fetchDiscusionByDiscussionId(
                        courseId, discussionId),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting ||
                          PertanyaanScreen.isLoading == true ||
                          snapshot.data == null) {
                        return const Center(
                          heightFactor: 20,
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return Column(
                          children: [
                            KomentarBoxParent(
                              username: snapshot.data.data.user.fullName,
                              text: snapshot.data.data.body,
                              title: snapshot.data.data.title,
                              date: snapshot.data.data.createdAt,
                              avatar:
                                  snapshot.data.data.user.photoProfile ?? '',
                              idUserMaker: snapshot.data.data.idUser,
                              idUserLoggedIn: idUser,
                              idCourse: courseId,
                              idDiscussion: discussionId,
                              courseTitle: courseTitle,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              color: hexToColor(ColorsRepo.lightGray),
                              padding: const EdgeInsets.all(20),
                              child: const Text(
                                'Komentar',
                                style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            FutureBuilder(
                              future: _appController.getComment(
                                  courseId, discussionId),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.waiting ||
                                    snapshot.data == null) {
                                  return Container();
                                } else {
                                  return ListView.separated(
                                    shrinkWrap: true,
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(
                                      height: 10,
                                    ),
                                    primary: false,
                                    itemBuilder: (context, index) {
                                      return KomentarBoxChild(
                                        avatar: snapshot.data[index].user
                                                .photoProfile ??
                                            '',
                                        username:
                                            snapshot.data[index].user.fullName,
                                        komentar: snapshot.data[index].body,
                                        idUserMaker:
                                            snapshot.data[index].user.id,
                                        idUserLoggedIn: idUser,
                                        idCourse: courseId,
                                        idDiscussion: discussionId,
                                        courseTitle: courseTitle,
                                        idComment: snapshot.data[index].id,
                                        date: snapshot.data[index].createdAt,
                                      );
                                    },
                                    itemCount: snapshot.data.length,
                                  );
                                }
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Material(
                  elevation: 10,
                  child: Container(
                    color: Colors.white,
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 40,
                          child: TextField(
                            controller: commentController,
                            maxLines: 5,
                            minLines: 1,
                            decoration: const InputDecoration(
                              hintText: 'Comment',
                              contentPadding: EdgeInsets.all(20),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                        InkWell(
                          child: Icon(
                            Icons.send,
                            color: hexToColor(ColorsRepo.primaryColor),
                            size: 24.0,
                          ),
                          onTap: () async {
                            setState(() {
                              PertanyaanScreen.isLoading = true;
                            });
                            CommentRequest commentRequest =
                                CommentRequest(body: commentController.text);
                            await _appController.postComment(
                                courseId, discussionId, commentRequest);
                            commentController.text = '';
                            setState(() {
                              PertanyaanScreen.isLoading = false;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

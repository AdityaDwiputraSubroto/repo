import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:repo/controllers/app_controller.dart';
import 'package:repo/controllers/login_controller.dart';
import 'package:repo/core/shared/colors.dart';
import 'package:repo/core/utils/formatting.dart';
import 'package:repo/core/routes/routes.dart';
import 'package:repo/models/user/login.dart';
import 'package:repo/views/widgets/index.dart';
import 'package:get/get.dart';
import 'package:repo/views/widgets/komentar_box_widget.dart';

class PertanyaanScreen extends StatefulWidget {
  const PertanyaanScreen({super.key});

  @override
  State<PertanyaanScreen> createState() => _PertanyaanScreenState();
}

class _PertanyaanScreenState extends State<PertanyaanScreen> {
  final _appController = Get.put(AppController());
  final courseId = Get.arguments['courseId'];
  final discussionId = Get.arguments['discussionId'];

  void tunggu() async{
    var tes = await _appController.fetchDiscusionByDiscussionId(courseId, discussionId);
  }
  @override
  Widget build(BuildContext context) {
  print(courseId.toString());
  print(discussionId.toString());
  tunggu();
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
                  child: FutureBuilder(
                    future: _appController.fetchDiscusionByDiscussionId(courseId, discussionId),
                    builder: (context,AsyncSnapshot s){
                      if(s.connectionState==ConnectionState.waiting||s.data=="Tidak ada data"|| s.data==null){
                        return Container(
                          child: Text("Tidak Ada Data"),
                        );
                      }
                      else{
                        print("\n\nFromView\n"+s.data.data.title.toString());
                        return Container(
                          //Text(s.data.data.user.fullName)
                          child: KomentarBoxParent(username: s.data.data.user.fullName, text: s.data.data.body, title: s.data.data.title, date: s.data.data.createdAt, avatar:s.data.data.user.photoProfile == null ? '' : s.data.data.user.photoProfile),

                        );
                      }
                    },
                  ),
                ),
                // child: ListView(
                //   children: [
                //     const KomentarBoxParent(
                //         avatar: '',
                //         title: 'Lorem ipsum dolor sit amet',
                //         username: 'Muhammad Rafli',
                //         text:
                //             'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                //         date: '12/03/2022'),
                //     const SizedBox(
                //       height: 10,
                //     ),
                //     Container(
                //       color: hexToColor(ColorsRepo.lightGray),
                //       padding: const EdgeInsets.all(20),
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: const [
                //           Text(
                //             'Komentar',
                //             style: TextStyle(
                //               fontSize: 23,
                //               fontWeight: FontWeight.w700,
                //             ),
                //           ),
                //           SizedBox(height: 10),
                //           KomentarBoxChild(
                //             avatar: '',
                //             username: 'Muhammad Rafli',
                //             text:
                //                 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                //           )
                //         ],
                //       ),
                //     )
                //   ],
                // ),
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
                          child: const TextField(
                            maxLines: 5,
                            minLines: 1,
                            decoration: InputDecoration(
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
                          onTap: () {},
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

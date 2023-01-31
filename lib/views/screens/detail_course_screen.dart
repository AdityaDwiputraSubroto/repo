import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:repo/controllers/app_controller.dart';
import 'package:repo/core/shared/assets.dart';
import 'package:repo/models/course/course_model.dart';
import 'package:repo/views/screens/article_nav_screen.dart';
import 'package:repo/views/widgets/button_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/shared/colors.dart';
import '../../core/utils/formatting.dart';
import '../widgets/accordion_widget.dart';

class DetailCourseScreen extends StatefulWidget {
  const DetailCourseScreen({super.key});

  @override
  State<DetailCourseScreen> createState() => _DetailCourseScreenState();
}

class _DetailCourseScreenState extends State<DetailCourseScreen> {
  final appController = Get.put(AppController());
  final ScrollController _scrollController = ScrollController();
  final courseDetail = Get.arguments['courseDetail'];
  var role;

  @override
  void initState() {
    SharedPreferences.getInstance().then((value) {
      setState(() {
        role = value.getInt('role');
      });
    });
    appController.fetchAllChaptersAndTitleArticles(courseDetail.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: hexToColor(ColorsRepo.primaryColor),
        title: Container(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '${courseDetail.title}',
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 20),
            onPressed: () {},
            icon: SvgPicture.asset(
              AssetsRepo.iconDiskusiButton,
              height: 20,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          padding: const EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: courseDetail.imageThumbnail,
                    imageBuilder: (context, imageProvider) => Container(
                      height: 212,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Container(
                      alignment: Alignment.center,
                      height: 212,
                      child: Image.asset(AssetsRepo.noPhoto),
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      AssetsRepo.noPhoto,
                      height: 212,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                '${courseDetail.title}',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  height: 1.4,
                ),
                maxLines: 2,
              ),
              const SizedBox(
                height: 5,
              ),
              Obx(() {
                if (appController.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  List<String> articleTitle = [];
                  int artikel = 0;
                  for (var i = 0;
                      i < appController.allChaptersAndTitleArticlesById.length;
                      i++) {
                    artikel = artikel +
                        appController.allChaptersAndTitleArticlesById
                            .elementAt(i)
                            .articles
                            .length;
                    for (var j = 0;
                        j <
                            appController.allChaptersAndTitleArticlesById
                                .elementAt(i)
                                .articles
                                .length;
                        j++) {
                      articleTitle.add(appController
                          .allChaptersAndTitleArticlesById
                          .elementAt(i)
                          .articles
                          .elementAt(j)
                          .title);
                    }
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            appController.allChaptersAndTitleArticlesById != []
                                ? Text(
                                    '${appController.allChaptersAndTitleArticlesById.length} Bab',
                                    style: TextStyle(
                                      color: hexToColor(ColorsRepo.darkGray),
                                      fontSize: 16,
                                    ),
                                  )
                                : Text(
                                    '0 Bab',
                                    style: TextStyle(
                                      color: hexToColor(ColorsRepo.darkGray),
                                      fontSize: 16,
                                    ),
                                  ),
                            const VerticalDivider(
                              color: Colors.grey,
                              thickness: 2,
                            ),
                            appController.allChaptersAndTitleArticlesById != []
                                ? Text(
                                    '$artikel Artikel',
                                    style: TextStyle(
                                      color: hexToColor(ColorsRepo.darkGray),
                                      fontSize: 16,
                                    ),
                                  )
                                : Text(
                                    '0 Artikel',
                                    style: TextStyle(
                                      color: hexToColor(ColorsRepo.darkGray),
                                      fontSize: 16,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          top: 5.5,
                        ),
                        width: 138,
                        height: 22,
                        decoration: BoxDecoration(
                          color: courseDetail.idDivision == 1
                              ? hexToColor(ColorsRepo.grayColorBE)
                              : courseDetail.idDivision == 2
                                  ? hexToColor(ColorsRepo.greenColorFE)
                                  : courseDetail.idDivision == 3
                                      ? hexToColor(ColorsRepo.blueColorMobile)
                                      : courseDetail.idDivision == 4
                                          ? hexToColor(ColorsRepo.redColorPR)
                                          : hexToColor(ColorsRepo.brownColorPM),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          textAlign: TextAlign.center,
                          '${appController.allDivisionList!.data!.elementAt(courseDetail.idDivision! - 1).divisionName}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          top: 7,
                        ),
                        width: double.infinity,
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              AssetsRepo.iconProfilLabel,
                              color: hexToColor(ColorsRepo.darkGray),
                              height: 16,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            FutureBuilder(
                              future: appController
                                  .fetchUserFullNameById(courseDetail.idUser!),
                              builder: (context, snapshot) {
                                if (snapshot.data == null) {
                                  return Text(
                                    '-',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: hexToColor(ColorsRepo.darkGray),
                                    ),
                                  );
                                } else {
                                  return Text(
                                    '${snapshot.data}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: hexToColor(ColorsRepo.darkGray),
                                    ),
                                  );
                                }
                              },
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.date_range,
                              size: 18,
                              color: hexToColor(ColorsRepo.darkGray),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                top: 2,
                              ),
                              child: Text(
                                DateFormat('dd/MM/yyyy').format(DateTime.parse(
                                    '${courseDetail.createdAt}')),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: hexToColor(ColorsRepo.darkGray),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const Text(
                        'Deskripsi',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        '${courseDetail.description}',
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const Text(
                        'Daftar Materi',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      appController.allChaptersAndTitleArticlesById.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: appController
                                  .allChaptersAndTitleArticlesById.length,
                              primary: false,
                              itemBuilder: (context, index) {
                                return accordionJudulBab(
                                  context,
                                  appController.allChaptersAndTitleArticlesById
                                      .elementAt(index)
                                      .articles
                                      .length,
                                  appController.allChaptersAndTitleArticlesById
                                      .elementAt(index)
                                      .title,
                                  articleTitle,
                                );
                              },
                            )
                          : Center(
                              heightFactor: 5,
                              child: Text(
                                'Materi Belum Tersedia',
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        hexToColor(ColorsRepo.redColorDanger)),
                              ),
                            ),
                    ],
                  );
                }
              })
            ],
          ),
        ),
      ),
      bottomNavigationBar: role != courseDetail.idDivision
          ? null
          : Container(
              padding: const EdgeInsets.all(5),
              color: Colors.white,
              child: ButtonRepo(
                onPressed: () {
                  Get.to(() => const ArticleNavScreen());
                },
                backgroundColor: ColorsRepo.primaryColor,
                text: 'Belajar Sekarang',
              ),
            ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:repo/controllers/app_controller.dart';
import 'package:repo/core/shared/assets.dart';
import 'package:repo/models/course/course_model.dart';
import 'package:repo/views/widgets/button_widget.dart';

import '../../core/shared/colors.dart';
import '../../core/utils/formatting.dart';

class DetailCourseScreen extends StatefulWidget {
  const DetailCourseScreen({super.key});

  @override
  State<DetailCourseScreen> createState() => _DetailCourseScreenState();
}

class _DetailCourseScreenState extends State<DetailCourseScreen> {
  final appController = Get.put(AppController());
  final ScrollController _scrollController = ScrollController();
  final courseDetail = Get.arguments['courseDetail'];
  bool isRole = true;
  void _scrollToSelectedContent({GlobalKey? expansionTileKey}) {
    final keyContext = expansionTileKey!.currentContext;
    if (keyContext != null) {
      Future.delayed(const Duration(milliseconds: 220)).then((value) {
        Scrollable.ensureVisible(keyContext,
            duration: const Duration(milliseconds: 200));
      });
    }
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
              IntrinsicHeight(
                child: Row(
                  children: [
                    Text(
                      '4 Bab',
                      style: TextStyle(
                        color: hexToColor(ColorsRepo.darkGray),
                        fontSize: 16,
                      ),
                    ),
                    const VerticalDivider(
                      color: Colors.grey,
                      thickness: 2,
                    ),
                    Text(
                      '34 Artikel',
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
                        DateFormat('dd/MM/yyyy').format(
                            DateTime.parse('${courseDetail.createdAt}')),
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
              accordionJudulBab(),
              accordionJudulBab(),
              accordionJudulBab(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: isRole
          ? Container(
              padding: const EdgeInsets.all(5),
              color: Colors.white,
              child: ButtonRepo(
                onPressed: () {},
                backgroundColor: ColorsRepo.primaryColor,
                text: 'Belajar Sekarang',
              ),
            )
          : null,
    );
  }

  Widget accordionJudulBab() {
    final GlobalKey expansionTileKey = GlobalKey();
    return Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor: Colors.white,
      ),
      child: Column(
        children: [
          Container(
            color: hexToColor(ColorsRepo.primaryColor),
            child: ExpansionTile(
              key: expansionTileKey,
              title: const Text(
                'Judul [Bab]',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              iconColor: Colors.white,
              backgroundColor: hexToColor(ColorsRepo.primaryColor),
              children: [
                Container(
                  color: Colors.white,
                  child: Column(
                    children: const [
                      ListTile(
                        title: Text(
                          'Artikel #1',
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        ),
                        subtitle: Text(
                          'Lorem ipsum dolor sit amet',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Divider(
                        indent: 18,
                        thickness: 2,
                        height: 0.5,
                      ),
                      ListTile(
                        title: Text(
                          'Artikel #2',
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        ),
                        subtitle: Text(
                          'Lorem ipsum dolor sit amet',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Divider(
                        indent: 18,
                        thickness: 2,
                        height: 0.5,
                      ),
                      ListTile(
                        title: Text(
                          'Artikel #3',
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        ),
                        subtitle: Text(
                          'Lorem ipsum dolor sit amet',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              onExpansionChanged: (value) {
                if (value) {
                  _scrollToSelectedContent(expansionTileKey: expansionTileKey);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

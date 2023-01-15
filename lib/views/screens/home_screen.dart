import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:repo/controllers/app_controller.dart';
import 'package:repo/core/shared/assets.dart';
import 'package:repo/core/shared/colors.dart';
import 'package:repo/core/utils/formatting.dart';
import 'package:repo/models/course/course_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final appController = Get.put(AppController());
  bool isChanged = true;
  bool isDescending = true;
  List<String> divisi = <String>[
    'Semua',
    'Web',
    'Mobile',
    'PM',
  ];
  String selectedDivision = 'Divisi';
  List<CourseResponse>? courseItems;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: hexToColor(ColorsRepo.lightGray),
      appBar: AppBar(
        backgroundColor: hexToColor(ColorsRepo.primaryColor),
        title: Text(
          'ITC Repository',
          style: TextStyle(
            color: hexToColor(ColorsRepo.accentColor),
            fontWeight: FontWeight.bold,
          ),
        ),
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
      body: Container(
        padding: const EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Materi',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 40,
                  width: MediaQuery.of(context).size.width / 2.3,
                  child: DropdownSearch<String>(
                    popupProps: const PopupProps.menu(
                      fit: FlexFit.loose,
                    ),
                    dropdownButtonProps: const DropdownButtonProps(
                      color: Colors.white,
                      icon: Icon(Icons.keyboard_arrow_down),
                    ),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        filled: true,
                        fillColor: hexToColor(ColorsRepo.primaryColor),
                        contentPadding:
                            const EdgeInsets.fromLTRB(12, 10, 10, 10),
                      ),
                    ),
                    items: divisi,
                    dropdownBuilder: (context, selectedItem) {
                      return Text(
                        selectedItem ?? 'Divisi',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                    onChanged: (selectedItem) {
                      setState(() {
                        selectedDivision = selectedItem!;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                SizedBox(
                  height: 40,
                  width: MediaQuery.of(context).size.width / 2.3,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: hexToColor(ColorsRepo.primaryColor),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isDescending ? 'A-Z' : 'Z-A',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Icon(
                          isDescending
                              ? Icons.keyboard_arrow_down
                              : Icons.keyboard_arrow_up,
                          size: 24.0,
                        )
                      ],
                    ),
                    onPressed: () => setState(() {
                      isDescending = !isDescending;
                    }),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 1.45,
              child: FutureBuilder(
                future: appController.fetchAllCourse(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      snapshot.data == null) {
                    return const Center(
                      heightFactor: 10,
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    courseItems = snapshot.data;
                    final course = courseItems!
                      ..sort(
                        (a, b) => isDescending
                            ? a.title!.compareTo(b.title!)
                            : b.title!.compareTo(a.title!),
                      );
                    final coursePerDivision = course
                        .where(
                          (element) => selectedDivision == 'Web'
                              ? element.idDivision == 1 ||
                                  element.idDivision == 2
                              : selectedDivision == 'Mobile'
                                  ? element.idDivision == 3
                                  : selectedDivision == 'PM'
                                      ? element.idDivision == 4 ||
                                          element.idDivision == 5
                                      : element.idDivision != null,
                        )
                        .toList();
                    if (course.isEmpty) {
                      return _emptyCourse();
                    } else {
                      return ListView.builder(
                        itemCount: coursePerDivision.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {},
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 310,
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 3,
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  _thumbnailCourse(context,
                                      coursePerDivision[index].imageThumbnail),
                                  _labelDivision(
                                      coursePerDivision[index].idDivision),
                                  _courseTitle(coursePerDivision[index].title),
                                  Container(
                                    margin: const EdgeInsets.only(
                                      left: 12,
                                      bottom: 12,
                                      right: 12,
                                    ),
                                    width: double.infinity,
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          AssetsRepo.iconProfilSelected,
                                          color:
                                              hexToColor(ColorsRepo.darkGray),
                                          height: 16,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        _courseMakerLabel(
                                            coursePerDivision[index].idUser),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                      left: 12,
                                      bottom: 12,
                                      right: 12,
                                    ),
                                    width: double.infinity,
                                    child: _courseCreateAndUpdate(
                                        coursePerDivision[index].createdAt,
                                        coursePerDivision[index].updatedAt),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

_emptyCourse() {
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.only(
          top: 30,
          bottom: 20,
        ),
        alignment: Alignment.topCenter,
        child: SvgPicture.asset(AssetsRepo.noCourse),
      ),
      const Text(
        'Course Tidak Ditemukan',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      Container(
        padding: const EdgeInsets.only(top: 10),
        child: const Text(
          '''Kami tidak dapat menemukan materi
yang anda cari.
Silakan mencoba kembali.''',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ],
  );
}

_thumbnailCourse(BuildContext context, String? imageThumbnail) {
  return Hero(
    tag: 1,
    child: Container(
      margin: const EdgeInsets.all(12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: double.infinity,
          color: Colors.white,
          child: imageThumbnail != null
              ? Image.network(
                  imageThumbnail,
                  height: 144,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                )
              : Image.asset(
                  AssetsRepo.noPhoto,
                  height: 144,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
        ),
      ),
    ),
  );
}

_labelDivision(int? idDivision) {
  final appController = Get.put(AppController());
  return Container(
    margin: const EdgeInsets.only(
      left: 12,
      bottom: 12,
    ),
    padding: const EdgeInsets.only(
      top: 4,
      left: 8,
      right: 4,
    ),
    width: 138,
    height: 18,
    decoration: BoxDecoration(
      color: idDivision == 1
          ? hexToColor(ColorsRepo.grayColorBE)
          : idDivision == 2
              ? hexToColor(ColorsRepo.greenColorFE)
              : idDivision == 3
                  ? hexToColor(ColorsRepo.blueColorMobile)
                  : idDivision == 4
                      ? hexToColor(ColorsRepo.redColorPR)
                      : hexToColor(ColorsRepo.brownColorPM),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      '${appController.allDivisionList!.data!.elementAt(idDivision! - 1).divisionName}',
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
    ),
  );
}

_courseMakerLabel(int? idUser) {
  final appController = Get.put(AppController());
  return FutureBuilder(
    future: appController.fetchUserById(idUser!),
    builder: (context, snapshot) {
      if (appController.fullnameById == null) {
        return Text(
          '-',
          style: TextStyle(
            fontSize: 14,
            color: hexToColor(ColorsRepo.darkGray),
          ),
        );
      } else {
        return Text(
          '${appController.fullnameById}',
          style: TextStyle(
            fontSize: 14,
            color: hexToColor(ColorsRepo.darkGray),
          ),
        );
      }
    },
  );
}

_courseTitle(String? courseTitle) {
  return Container(
    margin: const EdgeInsets.only(
      left: 12,
      right: 12,
      bottom: 12,
    ),
    width: double.infinity,
    child: Text(
      '$courseTitle',
      style: const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 16,
      ),
      maxLines: 2,
    ),
  );
}

_courseCreateAndUpdate(DateTime? createAt, DateTime? updateAt) {
  return Row(
    children: [
      Icon(
        Icons.date_range,
        size: 16,
        color: hexToColor(ColorsRepo.darkGray),
      ),
      const SizedBox(
        width: 5,
      ),
      Text(
        DateFormat('dd/MM/yyyy').format(DateTime.parse('$createAt')),
        // '${course[index].createdAt}',
        style: TextStyle(
          fontSize: 14,
          color: hexToColor(ColorsRepo.darkGray),
        ),
      ),
      const SizedBox(
        width: 5,
      ),
      Text(
        '|',
        style: TextStyle(
          fontSize: 14,
          color: hexToColor(ColorsRepo.darkGray),
        ),
      ),
      const SizedBox(
        width: 5,
      ),
      SvgPicture.asset(
        AssetsRepo.iconUpdateDate,
        color: hexToColor(ColorsRepo.darkGray),
        height: 18,
      ),
      const SizedBox(
        width: 5,
      ),
      Text(
        DateFormat('dd/MM/yyyy').format(DateTime.parse('$updateAt')),
        style: TextStyle(
          fontSize: 14,
          color: hexToColor(ColorsRepo.darkGray),
        ),
      )
    ],
  );
}

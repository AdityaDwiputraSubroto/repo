import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:repo/controllers/app_controller.dart';
import 'package:repo/core/routes/app_routes.dart';
import 'package:repo/core/shared/assets.dart';
import 'package:repo/core/shared/colors.dart';
import 'package:repo/core/utils/formatting.dart';
import 'package:repo/models/course/course_model.dart';
import 'package:repo/views/screens/detail_course_screen.dart';
import 'package:repo/views/screens/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final appController = Get.put(AppController());
  ScrollController scrollController = ScrollController();

  bool isLoading = false;
  bool isDescending = true;
  List<String> divisi = <String>[
    'Semua',
    'Web',
    'Mobile',
    'PM',
  ];
  String selectedDivision = 'Divisi';
  var courseItems = <CourseResponse>[].obs;
  var coursePerDivision = <CourseResponse>[].obs;
  var role;

  @override
  void initState() {
    SharedPreferences.getInstance().then((value) {
      setState(() {
        role = value.getInt('role');
      });
    });
    appController.fetchAllCourse();
    scrollController.addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() async {
    if (isLoading) {
      return;
    }
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      setState(() {
        isLoading = true;
      });
      await appController.fetchAllCourse();
      setState(() {
        isLoading = false;
      });
    }
  }

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
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchScreen(),
              );
            },
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
                      courseItems.sort(
                        (a, b) => isDescending
                            ? a.title!.compareTo(b.title!)
                            : b.title!.compareTo(a.title!),
                      );
                    }),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height -
                  kToolbarHeight -
                  MediaQuery.of(context).padding.top -
                  kBottomNavigationBarHeight -
                  104,
              child: Obx(
                () {
                  courseItems = appController.allCourseList;
                  final coursePerDivision = courseItems
                      .where(
                        (element) => selectedDivision == 'Web'
                            ? element.idDivision == 1 || element.idDivision == 2
                            : selectedDivision == 'Mobile'
                                ? element.idDivision == 3
                                : selectedDivision == 'PM'
                                    ? element.idDivision == 4 ||
                                        element.idDivision == 5
                                    : element.idDivision != null,
                      )
                      .toList();
                  if (courseItems.isEmpty) {
                    return _emptyCourse();
                  } else {
                    return ListView.separated(
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemCount: isLoading
                          ? coursePerDivision.length + 1
                          : coursePerDivision.length,
                      controller: scrollController,
                      itemBuilder: (context, index) {
                        if (index < coursePerDivision.length) {
                          return InkWell(
                            onTap: () {
                              Get.toNamed(
                                AppRoutesRepo.detailMateri,
                                arguments: {
                                  'courseDetail': coursePerDivision[index],
                                },
                              );
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 310,
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
                                      coursePerDivision[index].idDivision,
                                      role,
                                      coursePerDivision[index].id),
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
                                          AssetsRepo.iconProfilLabel,
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
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _labelDivision(int? idDivision, int? role, int? idCourse) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: const EdgeInsets.only(
            left: 12,
          ),
          padding: const EdgeInsets.only(
            top: 4.5,
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
            textAlign: TextAlign.center,
            '${appController.allDivisionList!.data!.elementAt(idDivision! - 1).divisionName}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
        role == 2
            ? PopupMenuButton(
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    value: idCourse,
                    child: const Text('Hapus'),
                    onTap: () {
                      appController.deleteCourse(idCourse);
                    },
                  ),
                ],
              )
            : Container(
                height: 18,
                margin: const EdgeInsets.only(top: 30),
              )
      ],
    );
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
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: double.infinity,
          color: Colors.white,
          child: CachedNetworkImage(
            imageUrl: imageThumbnail!,
            imageBuilder: (context, imageProvider) => Container(
              height: 144,
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
              height: 144,
              child: Image.asset(AssetsRepo.noPhoto),
            ),
            errorWidget: (context, url, error) => Image.asset(
              AssetsRepo.noPhoto,
              height: 144,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  _courseMakerLabel(int? idUser) {
    return FutureBuilder(
      future: appController.fetchUserFullNameById(idUser!),
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
        overflow: TextOverflow.clip,
      ),
    );
  }

  _courseCreateAndUpdate(DateTime? createAt, DateTime? updateAt) {
    return IntrinsicHeight(
      child: Row(
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
            style: TextStyle(
              fontSize: 14,
              color: hexToColor(ColorsRepo.darkGray),
            ),
          ),
          const VerticalDivider(
            color: Colors.grey,
            thickness: 2,
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
      ),
    );
  }
}

class SearchScreen extends SearchDelegate {
  final appController = Get.put(AppController());
  var allData = <CourseResponse>[];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: appController.searchCourseByTitle(query),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data![index].title!),
                onTap: () {
                  Get.toNamed(
                    AppRoutesRepo.detailMateri,
                    arguments: {
                      'courseDetail': snapshot.data![index],
                    },
                  );
                },
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    allData = appController.allCourseList;
    var matchQuery = <CourseResponse>[].obs;
    for (var i = 0; i < allData.length; i++) {
      if (allData[i].title!.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(allData[i]);
      }
    }
    return ListView.builder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index].title;
        return ListTile(
          title: Text(result!),
          onTap: () {
            Get.toNamed(
              AppRoutesRepo.detailMateri,
              arguments: {
                'courseDetail': matchQuery[index],
              },
            );
          },
        );
      },
    );
  }
}

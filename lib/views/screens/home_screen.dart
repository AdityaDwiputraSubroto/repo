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
  bool isDescending = true;
  List<String> divisi = <String>[
    'Semua',
    'Web',
    'Mobile',
    'PM',
  ];
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
                    onPressed: () =>
                        setState(() => isDescending = !isDescending),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
                height: MediaQuery.of(context).size.height / 1.45,
                child: FutureBuilder(
                  future: appController.fetchAllCourse(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        snapshot.data == null) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      List<CourseResponse>? course = snapshot.data;
                      return ListView.builder(
                        itemCount: course!.length,
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
                                  Hero(
                                    tag: 1,
                                    child: Container(
                                      margin: const EdgeInsets.all(12),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Container(
                                          width: double.infinity,
                                          color: Colors.white,
                                          child: course[index].imageThumbnail !=
                                                  null
                                              ? Image.network(
                                                  '${course[index].imageThumbnail}',
                                                  height: 144,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.asset(
                                                  AssetsRepo.noPhoto,
                                                  height: 144,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                      left: 12,
                                      bottom: 12,
                                    ),
                                    padding: const EdgeInsets.only(
                                      top: 4,
                                      left: 8,
                                    ),
                                    width: 135,
                                    height: 18,
                                    decoration: BoxDecoration(
                                      color: hexToColor(ColorsRepo.redColorPR),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      '${course[index].idDivision}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                      left: 12,
                                      right: 12,
                                      bottom: 12,
                                    ),
                                    width: double.infinity,
                                    child: Text(
                                      '${course[index].title}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                      ),
                                      maxLines: 2,
                                    ),
                                  ),
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
                                        Text(
                                          '${course[index].idUser}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                hexToColor(ColorsRepo.darkGray),
                                          ),
                                        )
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
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.date_range,
                                          size: 16,
                                          color:
                                              hexToColor(ColorsRepo.darkGray),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          DateFormat('dd/MM/yyyy').format(
                                              DateTime.parse(
                                                  '${course[index].createdAt}')),
                                          // '${course[index].createdAt}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                hexToColor(ColorsRepo.darkGray),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          '|',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                hexToColor(ColorsRepo.darkGray),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        SvgPicture.asset(
                                          AssetsRepo.iconUpdateDate,
                                          color:
                                              hexToColor(ColorsRepo.darkGray),
                                          height: 18,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          DateFormat('dd/MM/yyyy').format(
                                              DateTime.parse(
                                                  '${course[index].updatedAt}')),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                hexToColor(ColorsRepo.darkGray),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ))
          ],
        ),
      ),
    );
  }
}

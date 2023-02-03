import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:repo/core/shared/assets.dart';
import 'package:repo/core/shared/colors.dart';
import 'package:repo/core/utils/formatting.dart';

class DiscussionScreen extends StatefulWidget {
  const DiscussionScreen({super.key});

  @override
  State<DiscussionScreen> createState() => _DiscussionScreenState();
}

class _DiscussionScreenState extends State<DiscussionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hexToColor(ColorsRepo.lightGray),
      appBar: AppBar(
        backgroundColor: hexToColor(ColorsRepo.primaryColor),
        title: const Text('[Judul Materi]'),
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
                itemCount: 10,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {},
                    child: Container(
                      height: 178,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.fromLTRB(12, 6, 8, 12),
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
                              ClipRRect(
                                borderRadius: BorderRadius.circular(2),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      'https://1.bp.blogspot.com/-j8vxXp6cack/XlByzHkK1ZI/AAAAAAAAFJM/kbwdlu3xuYk_cNpuKTj5FIuRzSP8QModwCNcBGAsYHQ/w640/images%2B%252854%2529.jpg',
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    height: 32,
                                    width: 32,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) => Container(
                                    alignment: Alignment.center,
                                    height: 32,
                                    width: 32,
                                    child: Image.asset(AssetsRepo.avatarIcon),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    AssetsRepo.avatarIcon,
                                    height: 32,
                                    width: 32,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Muhammad Rafli',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '12/10/2022',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: hexToColor(ColorsRepo.darkGray),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                width: 99,
                              ),
                              PopupMenuButton(
                                padding: EdgeInsets.all(0),
                                itemBuilder: (BuildContext context) => [
                                  PopupMenuItem(
                                    value: '',
                                    child: const Text('Laporkan Pertanyaan'),
                                    onTap: () {},
                                  ),
                                  PopupMenuItem(
                                    value: '',
                                    child: Text('Hapus'),
                                    onTap: () {
                                      Future.delayed(
                                        const Duration(seconds: 0),
                                        () => showAlertDialog(context),
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
                          const Text(
                            'Lorem ipsum dolor sit amet',
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
                          Container(
                            padding: const EdgeInsets.only(
                              right: 25,
                            ),
                            child: const Text(
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vitae tellus nisl. Aliquam erat volutpat. In hac habitasse platea dictumst. Duis sit amet orci maximus, iaculis justo sollicitudin, congue turpis. Aliquam dictum tortor lacus, eu tempor metus blandit at. Fusce laoreet volutpat dolor in egestas. Sed accumsan tempus risus, ac hendrerit massa sodales non. Etiam a scelerisque lacus.',
                              maxLines: 3,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                height: 1.4,
                              ),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: hexToColor(ColorsRepo.primaryColor),
        child: const Icon(Icons.add),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        'Kembali',
        style: TextStyle(
          color: hexToColor(ColorsRepo.primaryColor),
        ),
      ),
      onPressed: () {
        Get.back();
      },
    );
    Widget deleteButton = TextButton(
      child: Text(
        'Hapus',
        style: TextStyle(
          color: hexToColor(ColorsRepo.primaryColor),
        ),
      ),
      onPressed: () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: const Text('Hapus Komentar? '),
      actions: [
        cancelButton,
        deleteButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

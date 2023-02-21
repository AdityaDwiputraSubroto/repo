import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:repo/controllers/app_controller.dart';

import 'package:repo/core/shared/assets.dart';

import '../../core/shared/colors.dart';
import '../../core/utils/formatting.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final appController = Get.find<AppController>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: hexToColor(ColorsRepo.primaryColor),
        title: Text(
          'ITC Repository',
          style: TextStyle(
            color: hexToColor(ColorsRepo.accentColor),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                dense: true,
                leading: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: appController.userOwnProfile!.photoProfile!,
                    imageBuilder: (context, imageProvider) => Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Container(
                      alignment: Alignment.center,
                      height: 50,
                      width: 50,
                      child: Image.asset(AssetsRepo.avatarIcon),
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      AssetsRepo.avatarIcon,
                      height: 50,
                      width: 50,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                title: Text(
                  appController.userOwnProfile!.fullName!,
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                subtitle: Text(
                  appController.userOwnProfile!.divisionName ?? '',
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              const Divider(
                thickness: 2,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Akun',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Column(
                      children: [
                        ListTile(
                          leading: Padding(
                            padding: const EdgeInsets.fromLTRB(5, 12, 8, 8),
                            child: SvgPicture.asset(
                              AssetsRepo.editPenIcon,
                              height: 20,
                            ),
                          ),
                          title: const Text(
                            'Ubah Profil',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          subtitle: const Text('Mengubah profil akun anda'),
                          onTap: () {
                            Navigator.pushNamed(context, '/ubahProfil');
                          },
                        ),
                        ListTile(
                          leading: Padding(
                            padding: const EdgeInsets.fromLTRB(5, 8, 8, 8),
                            child: Icon(
                              Icons.logout,
                              color: hexToColor(ColorsRepo.redColorDanger),
                              size: 25,
                            ),
                          ),
                          title: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Keluar',
                              style: TextStyle(
                                color: hexToColor(ColorsRepo.redColorDanger),
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          onTap: () {
                            appController.logout();
                          },
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

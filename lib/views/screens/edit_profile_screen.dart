import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:repo/core/shared/colors.dart';
import 'package:repo/core/utils/formatting.dart';
import 'package:repo/views/widgets/button_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/app_controller.dart';
import '../widgets/snackbar_widget.dart';
import '../widgets/text_field_widget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final appController = Get.put(AppController());
  String? photoProfile;
  String? name;
  String? username;
  String? email;
  String? noTelp;
  String? division;
  String? generation;
  File? _image;
  String? image;
  var password;
  late TextEditingController nameController = TextEditingController(text: name);
  late TextEditingController usernameController =
      TextEditingController(text: username);
  late TextEditingController emailController =
      TextEditingController(text: email);
  late TextEditingController noTelpController =
      TextEditingController(text: noTelp);

  @override
  void initState() {
    SharedPreferences.getInstance().then((value) {
      setState(() {
        password = value.getString('password')!;
      });
    });
    appController.fetchUserOwnProfile();
    name = appController.userOwnProfile!.fullName!;
    username = appController.userOwnProfile!.username!;
    email = appController.userOwnProfile!.email!;
    photoProfile = appController.userOwnProfile!.photoProfile ?? '';
    noTelp = appController.userOwnProfile!.phoneNumber ?? '';
    generation = appController.userOwnProfile!.generation;
    division = appController.userOwnProfile!.divisionName ?? '';

    super.initState();
  }

  late String? divisionController = division;
  List<String> divisi = <String>[
    'Back-End Developer',
    'Front-End Developer',
    'Mobile Developer',
    'Public Relations',
    'Project Manager'
  ];

  late String? generationController = generation;
  List<String> generasi = <String>[
    '2020',
    '2021',
    '2022',
    '2023',
    '2024',
  ];

  inputHandler() {
    bool isFilled = true;
    if (emailController.text == '' ||
        usernameController.text == '' ||
        nameController.text == '') {
      snackbarRepo('Warning!', 'Data Tidak Boleh Kosong!');
      isFilled = false;
    } else if (_image == null) {
      snackbarRepo('Warning!', 'Foto Profil Masih Foto Yang Lama !!');
      isFilled = false;
    } else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(emailController.text)) {
      snackbarRepo('Warning!', 'Isi Email Dengan Benar!');
      isFilled = false;
    } else if (nameController.text.length < 6) {
      snackbarRepo('Warning!', 'Nama Minimal 6 Karakter!');
      isFilled = false;
    } else if (usernameController.text.length < 4) {
      snackbarRepo('Warning!', 'Username Minimal 4 Karakter !');
      isFilled = false;
    } else if (divisionController == null) {
      snackbarRepo('Warning!', 'Divisi Harus Diisi !');
      isFilled = false;
    } else if (noTelpController.text == '') {
      isFilled = false;
    } else if (noTelpController.text != '') {
      if (!RegExp('[0-9]').hasMatch(noTelpController.text)) {
        snackbarRepo('Warning!', 'Nomor Telepon Hanya Boleh Angka !');
        isFilled = false;
      }
    }
    return isFilled;
  }

  Future _pickImage(ImageSource source) async {
    try {
      final image2 = await ImagePicker().pickImage(source: source);
      if (image2 == null) return;
      File? img = File(image2.path);
      setState(() {
        _image = img;
        image = _image!.path;
        Navigator.of(context).pop();
      });
    } on PlatformException catch (e) {
      Navigator.of(context).pop();
    }
  }

  void _showSelectPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(5.0),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.28,
        maxChildSize: 0.4,
        minChildSize: 0.28,
        expand: false,
        builder: (context, scrollController) {
          return Stack(
            alignment: AlignmentDirectional.topCenter,
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: -15,
                child: Container(
                  width: 50,
                  height: 6,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2.5),
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                child: Column(
                  children: [
                    ButtonRepo(
                      text: 'Ambil dari galeri',
                      backgroundColor: ColorsRepo.primaryColor,
                      onPressed: () {
                        _pickImage(ImageSource.gallery);
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    ButtonRepo(
                      text: 'Ambil dari kamera',
                      backgroundColor: ColorsRepo.primaryColor,
                      onPressed: () {
                        _pickImage(ImageSource.camera);
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/',
              (route) => false,
            );
          },
        ),
        title: const Padding(
          padding: EdgeInsets.only(top: 4),
          child: Text('Ubah Profil'),
        ),
        backgroundColor: hexToColor(ColorsRepo.primaryColor),
        actions: [
          IconButton(
            padding: const EdgeInsets.only(
              right: 20,
            ),
            onPressed: () {
              if (inputHandler()) {
                Get.find<AppController>().editProfileWithImage(
                  context,
                  image!,
                  nameController.text,
                  usernameController.text,
                  emailController.text,
                  divisionController!,
                  generationController!,
                  noTelpController.text,
                );
              }
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: appController.isLoading.value
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                margin: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          _showSelectPhotoOptions(context);
                        },
                        child: Center(
                          child: Container(
                            height: 100.0,
                            width: 100.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.withOpacity(0.2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                ),
                              ],
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Center(
                                  child: _image == null
                                      ? CachedNetworkImage(
                                          imageUrl: photoProfile!,
                                          imageBuilder:
                                              (context, imageProvider) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(200),
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            );
                                          },
                                          placeholder: (context, url) => Icon(
                                            Icons.person,
                                            size: 70,
                                            color:
                                                Colors.black.withOpacity(0.2),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Icon(
                                            Icons.person,
                                            size: 70,
                                            color:
                                                Colors.black.withOpacity(0.2),
                                          ),
                                        )
                                      : CircleAvatar(
                                          backgroundImage: FileImage(_image!),
                                          radius: 200.0,
                                        ),
                                ),
                                const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Nama Lengkap',
                      style: TextStyle(
                        color: hexToColor(ColorsRepo.primaryColor),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    TextFieldRepo(
                      textController: nameController,
                      hintText: 'Nama',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Username',
                      style: TextStyle(
                        color: hexToColor(ColorsRepo.primaryColor),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    TextFieldRepo(
                      textController: usernameController,
                      hintText: 'Username',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Email',
                      style: TextStyle(
                        color: hexToColor(ColorsRepo.primaryColor),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    TextFieldRepo(
                      textController: emailController,
                      hintText: 'Email',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Divisi',
                      style: TextStyle(
                        color: hexToColor(ColorsRepo.primaryColor),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: DropdownSearch<String>(
                        popupProps: const PopupProps.menu(
                          fit: FlexFit.loose,
                        ),
                        dropdownButtonProps: DropdownButtonProps(
                          color: hexToColor(ColorsRepo.primaryColor),
                          icon: const Icon(Icons.keyboard_arrow_down),
                        ),
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            filled: true,
                            fillColor: hexToColor(ColorsRepo.secondaryColor),
                            contentPadding:
                                const EdgeInsets.fromLTRB(12, 10, 10, 10),
                          ),
                        ),
                        items: divisi,
                        dropdownBuilder: (context, selectedItem) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              selectedItem ?? '$divisionController',
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                            ),
                          );
                        },
                        onChanged: (selectedItem) {
                          setState(() {
                            divisionController = selectedItem ?? division;
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Angkatan',
                      style: TextStyle(
                        color: hexToColor(ColorsRepo.primaryColor),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: DropdownSearch<String>(
                        popupProps: const PopupProps.menu(
                          fit: FlexFit.loose,
                        ),
                        dropdownButtonProps: DropdownButtonProps(
                          color: hexToColor(ColorsRepo.primaryColor),
                          icon: const Icon(Icons.keyboard_arrow_down),
                        ),
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            filled: true,
                            fillColor: hexToColor(ColorsRepo.secondaryColor),
                            contentPadding:
                                const EdgeInsets.fromLTRB(12, 10, 10, 10),
                          ),
                        ),
                        items: generasi,
                        dropdownBuilder: (context, selectedItem) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              selectedItem ?? '$generationController',
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                            ),
                          );
                        },
                        onChanged: (selectedItem) {
                          setState(() {
                            generationController = selectedItem ?? generation;
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Nomor Telepon',
                      style: TextStyle(
                        color: hexToColor(ColorsRepo.primaryColor),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    TextFieldRepo(
                      textController: noTelpController,
                      hintText: 'Nomor Telepon',
                      isNumber: true,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    ButtonRepo(
                      text: 'Ubah Password',
                      backgroundColor: ColorsRepo.lightGray,
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/ubahPassword',
                          arguments: Password(
                            password,
                          ),
                        );
                      },
                      changeTextColor: true,
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

class Password {
  String password;
  Password(this.password);
}

// ignore: must_be_immutable
class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Password;
    String password = args.password;
    late TextEditingController changePasswordController =
        TextEditingController(text: password);
    handler() {
      bool isGood = true;
      if (changePasswordController.text == password) {
        snackbarRepo('Warning !!',
            'Password baru tidak boleh sama dengan password lama !!');
        isGood = false;
      }
      return isGood;
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/ubahProfil',
              (route) => false,
            );
          },
        ),
        title: const Text('Ganti Password'),
        backgroundColor: hexToColor(ColorsRepo.primaryColor),
        actions: [
          IconButton(
            padding: const EdgeInsets.only(
              right: 20,
            ),
            onPressed: () {
              if (handler()) {
                Get.find<AppController>()
                    .changePasswordUser(changePasswordController.text);
                Get.find<AppController>().fetchUserOwnProfile();
              }
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        margin: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Masukkan Password Baru',
              style: TextStyle(
                color: hexToColor(ColorsRepo.primaryColor),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            TextFieldRepo(
              textController: changePasswordController,
              hintText: 'Password',
              obscureText: true,
            ),
          ],
        ),
      ),
    );
  }
}

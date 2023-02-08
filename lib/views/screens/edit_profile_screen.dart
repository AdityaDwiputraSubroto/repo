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

import '../widgets/snackbar_widget.dart';
import '../widgets/text_field_widget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController noTelpController = TextEditingController();
  String? divisionController;
  String selectedDivision = 'Divisi';
  List<String> divisi = <String>[
    'Back-End Developer',
    'Front-End Developer',
    'Mobile Developer',
    'Public Relations',
    'Project Manager'
  ];

  inputHandler() {
    bool isFilled = true;
    if (emailController.text == '' ||
        passwordController.text == '' ||
        usernameController.text == '' ||
        nameController.text == '' ||
        noTelpController.text == '') {
      snackbarRepo('Warning!', 'Data Tidak Boleh Kosong!');
      isFilled = false;
    } else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(emailController.text)) {
      snackbarRepo('Warning!', 'Isi Email Dengan Benar!');
      isFilled = false;
    } else if (nameController.text.length < 6) {
      snackbarRepo('Warning!', 'Nama Minimal 6 Karakter!');
      isFilled = false;
    } else if (passwordController.text.length < 8) {
      snackbarRepo('Warning!', 'Password Minimal 8 Karakter !');
      isFilled = false;
    } else if (usernameController.text.length < 4) {
      snackbarRepo('Warning!', 'Username Minimal 4 Karakter !');
      isFilled = false;
    } else if (divisionController == null) {
      snackbarRepo('Warning!', 'Divisi Harus Diisi !');
      isFilled = false;
    } else if (!RegExp('[0-9]').hasMatch(noTelpController.text)) {
      snackbarRepo('Warning!', 'Hanya Boleh Angka !');
      isFilled = false;
    }
    return isFilled;
  }

  File? _image;

  Future _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      File? img = File(image.path);
      setState(() {
        _image = img;
        Navigator.of(context).pop();
      });
    } on PlatformException catch (e) {
      print(e);
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
                      const SizedBox(
                        height: 12,
                      ),
                      ButtonRepo(
                        text: 'Hapus Gambar',
                        backgroundColor: ColorsRepo.primaryColor,
                        onPressed: () {
                          setState(() {
                            _image = null;
                            Navigator.of(context).pop();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                print('oke');
              }
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                                    imageUrl: '',
                                    imageBuilder: (context, imageProvider) {
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
                                      color: Colors.black.withOpacity(0.2),
                                    ),
                                    errorWidget: (context, url, error) => Icon(
                                      Icons.person,
                                      size: 70,
                                      color: Colors.black.withOpacity(0.2),
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
                'Password',
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
                textController: passwordController,
                hintText: 'Password',
                obscureText: true,
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
                      contentPadding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
                    ),
                  ),
                  items: divisi,
                  dropdownBuilder: (context, selectedItem) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        selectedItem ?? 'Divisi',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                      ),
                    );
                  },
                  onChanged: (selectedItem) {
                    setState(() {
                      divisionController = selectedItem!;
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
            ],
          ),
        ),
      ),
    );
  }
}

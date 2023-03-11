import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:repo/core/shared/colors.dart';
import 'package:repo/core/utils/formatting.dart';
import 'delete_overlay_widget.dart';
import 'edit_overlay_widget.dart';

class KomentarBoxParent extends StatelessWidget {
  final String avatar;
  final String username;
  final String text;
  final String title;
  final String date;
  final int idUserMaker;
  final int idUserLoggedIn;
  final int idCourse;
  final int idDiscussion;
  final String courseTitle;

  const KomentarBoxParent({
    super.key,
    required this.username,
    required this.text,
    required this.title,
    required this.date,
    required this.avatar,
    required this.idUserMaker,
    required this.idUserLoggedIn,
    required this.idCourse,
    required this.idDiscussion,
    required this.courseTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: CachedNetworkImage(
                      imageUrl: avatar,
                      imageBuilder: (context, imageProvider) => Container(
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
                        color: Colors.grey.shade200,
                        height: 32,
                        width: 32,
                        child: Icon(
                          Icons.person,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey.shade200,
                        child: Icon(
                          Icons.person,
                          color: Colors.grey.shade400,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        DateFormat('dd/MM/yyyy')
                            .format(DateTime.parse(date))
                            .toString(),
                        style: TextStyle(
                          fontSize: 14,
                          color: hexToColor(ColorsRepo.darkGray),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              idUserLoggedIn == idUserMaker
                  ? PopupMenuButton(
                      padding: const EdgeInsets.all(0),
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                          value: '',
                          child: const Text('Hapus'),
                          onTap: () {
                            Future.delayed(
                              const Duration(seconds: 0),
                              () => deleteOverlayKomentarBox(
                                context,
                                idCourse,
                                idDiscussion,
                                courseTitle,
                              ),
                            );
                          },
                        ),
                      ],
                    )
                  : const SizedBox(
                      height: 45,
                    ),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 23,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              height: 1.5,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

class KomentarBoxChild extends StatelessWidget {
  final String username;
  final String komentar;
  final String avatar;
  final int idUserLoggedIn;
  final int idUserMaker;
  final int idCourse;
  final int idDiscussion;
  final String courseTitle;
  final int idComment;
  final String date;

  const KomentarBoxChild({
    super.key,
    required this.avatar,
    required this.username,
    required this.komentar,
    required this.idUserLoggedIn,
    required this.idUserMaker,
    required this.idCourse,
    required this.idDiscussion,
    required this.courseTitle,
    required this.idComment,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Colors.white,
      ),
      margin: const EdgeInsets.only(
        right: 20,
        left: 20,
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: CachedNetworkImage(
                      imageUrl: avatar,
                      imageBuilder: (context, imageProvider) => Container(
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
                        color: Colors.grey.shade200,
                        height: 32,
                        width: 32,
                        child: Icon(
                          Icons.person,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey.shade200,
                        child: Icon(
                          Icons.person,
                          color: Colors.grey.shade400,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        DateFormat('dd/MM/yyyy')
                            .add_jm()
                            .format(DateTime.parse(date).toLocal())
                            .toString(),
                        style: TextStyle(
                          fontSize: 14,
                          color: hexToColor(ColorsRepo.darkGray),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              idUserLoggedIn == idUserMaker
                  ? PopupMenuButton(
                      padding: const EdgeInsets.all(0),
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                          value: '',
                          child: const Text('Edit'),
                          onTap: () {
                            Future.delayed(
                              const Duration(seconds: 0),
                              () => editOverlayComment(
                                context,
                                idCourse,
                                idDiscussion,
                                courseTitle,
                                idComment,
                                komentar,
                              ),
                            );
                          },
                        ),
                        PopupMenuItem(
                          value: '',
                          child: const Text('Hapus'),
                          onTap: () {
                            Future.delayed(
                              const Duration(seconds: 0),
                              () => deleteOverlayComment(
                                context,
                                idCourse,
                                idDiscussion,
                                courseTitle,
                                idComment,
                              ),
                            );
                          },
                        ),
                      ],
                    )
                  : const SizedBox(
                      height: 45,
                    ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(left: 40.0),
            child: Text(
              komentar,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                height: 1.5,
              ),
            ),
          )
        ],
      ),
    );
  }
}

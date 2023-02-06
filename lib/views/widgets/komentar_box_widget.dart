import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:repo/core/shared/colors.dart';
import 'package:repo/core/utils/formatting.dart';
import 'package:repo/views/widgets/index.dart';

class KomentarBoxParent extends StatelessWidget {
  final String avatar;
  final String username;
  final String text;
  final String title;
  final String date;

  void handleClick(String value) {
    switch (value) {
      case 'Laporkan Pertanyaan':
        break;
      case 'Hapus':
        break;
    }
  }

  const KomentarBoxParent({
    super.key,
    required this.username,
    required this.text,
    required this.title,
    required this.date,
    required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
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
                  date,
                  style: TextStyle(
                    fontSize: 14,
                    color: hexToColor(ColorsRepo.darkGray),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 120),
            PopupMenuButton<String>(
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                return {'Laporkan Pertanyaan', 'Hapus'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ]),
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
          const SizedBox(height: 16),
          ButtonBalas(
            onPressed: () {},
          )
        ],
      ),
    );
  }
}

class KomentarBoxChild extends StatelessWidget {
  final String username;
  final String text;
  final String avatar;

  const KomentarBoxChild({
    super.key,
    required this.avatar,
    required this.username,
    required this.text,
  });

  void handleClick(String value) {
    switch (value) {
      case 'Laporkan Pertanyaan':
        break;
      case 'Hapus':
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
              Text(
                username,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 80),
              PopupMenuButton<String>(
                onSelected: handleClick,
                itemBuilder: (BuildContext context) {
                  return {'Laporkan Pertanyaan', 'Hapus'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(left: 40.0),
            child: Text(
              text,
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

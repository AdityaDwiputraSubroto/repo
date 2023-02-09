// To parse this JSON data, do
//
//     final discussionResponse = discussionResponseFromJson(jsonString);

import 'dart:convert';

DiscussionResponse discussionResponseFromJson(String str) =>
    DiscussionResponse.fromJson(json.decode(str));

String discussionResponseToJson(DiscussionResponse data) =>
    json.encode(data.toJson());

class DiscussionResponse {
  DiscussionResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  String status;
  String message;
  List<Datum> data;

  factory DiscussionResponse.fromJson(Map<String, dynamic> json) =>
      DiscussionResponse(
        status: json["status"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.id,
    required this.title,
    required this.body,
    required this.isEdited,
    required this.createdAt,
    required this.updatedAt,
    required this.idUser,
    required this.idCourse,
    required this.user,
  });

  int id;
  String title;
  String body;
  bool isEdited;
  String createdAt;
  String updatedAt;
  int idUser;
  int idCourse;
  UserDiscussion user;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        title: json["title"],
        body: json["body"],
        isEdited: json["isEdited"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        idUser: json["id_user"],
        idCourse: json["id_course"],
        user: UserDiscussion.fromJson(json["User"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "body": body,
        "isEdited": isEdited,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "id_user": idUser,
        "id_course": idCourse,
        "User": user.toJson(),
      };
}

class UserDiscussion {
  UserDiscussion({
    required this.fullName,
    required this.idDivision,
    required this.username,
  });

  String fullName;
  int idDivision;
  String username;

  factory UserDiscussion.fromJson(Map<String, dynamic> json) => UserDiscussion(
        fullName: json["fullName"],
        idDivision: json["id_division"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "fullName": fullName,
        "id_division": idDivision,
        "username": username,
      };
}

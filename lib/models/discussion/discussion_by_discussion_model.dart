class DiscussionByDiscussionIdResponse {
  String? status;
  String? message;
  Data? data;

  DiscussionByDiscussionIdResponse({this.status, this.message, this.data});

  DiscussionByDiscussionIdResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? title;
  String? body;
  bool? isEdited;
  String? createdAt;
  String? updatedAt;
  int? idUser;
  int? idCourse;
  User? user;

  Data(
      {this.id,
      this.title,
      this.body,
      this.isEdited,
      this.createdAt,
      this.updatedAt,
      this.idUser,
      this.idCourse,
      this.user});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    isEdited = json['isEdited'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    idUser = json['id_user'];
    idCourse = json['id_course'];
    user = json['User'] != null ? User.fromJson(json['User']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['body'] = body;
    data['isEdited'] = isEdited;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['id_user'] = idUser;
    data['id_course'] = idCourse;
    if (user != null) {
      data['User'] = user!.toJson();
    }
    return data;
  }
}

class User {
  String? fullName;
  String? photoProfile;

  User({this.fullName, this.photoProfile});

  User.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    photoProfile = json['photoProfile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fullName'] = fullName;
    data['photoProfile'] = photoProfile;
    return data;
  }
}

class CommentListResponse {
  int? id;
  String? body;
  bool? isEdited;
  String? createdAt;
  String? updatedAt;
  int? idUser;
  int? idDiscussion;
  User? user;

  CommentListResponse(
      {this.id,
      this.body,
      this.isEdited,
      this.createdAt,
      this.updatedAt,
      this.idUser,
      this.idDiscussion,
      this.user});

  CommentListResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    body = json['body'];
    isEdited = json['isEdited'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    idUser = json['id_user'];
    idDiscussion = json['id_discussion'];
    user = json['User'] != null ? User.fromJson(json['User']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['body'] = body;
    data['isEdited'] = isEdited;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['id_user'] = idUser;
    data['id_discussion'] = idDiscussion;
    if (user != null) {
      data['User'] = user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? fullName;
  String? photoProfile;

  User({this.id, this.fullName, this.photoProfile});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    photoProfile = json['photoProfile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['fullName'] = fullName;
    data['photoProfile'] = photoProfile;
    return data;
  }
}

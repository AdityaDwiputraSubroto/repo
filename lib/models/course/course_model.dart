class CourseResponse {
  int? id;
  String? title;
  String? description;
  String? imageThumbnail;
  String? cloudinaryId;
  DateTime? createdAt;
  DateTime? updatedAt;
  User? user;
  Division? division;

  CourseResponse(
      {this.id,
      this.title,
      this.description,
      this.imageThumbnail,
      this.cloudinaryId,
      this.createdAt,
      this.updatedAt,
      this.user,
      this.division});

  CourseResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    imageThumbnail = json['image_thumbnail'];
    cloudinaryId = json['cloudinary_id'];
    createdAt = DateTime.parse(json['createdAt']);
    updatedAt = DateTime.parse(json['updatedAt']);
    user = json['User'] != null ? User.fromJson(json['User']) : null;
    division =
        json['Division'] != null ? Division.fromJson(json['Division']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['image_thumbnail'] = imageThumbnail;
    data['cloudinary_id'] = cloudinaryId;
    data['createdAt'] = createdAt?.toIso8601String();
    data['updatedAt'] = updatedAt?.toIso8601String();
    if (user != null) {
      data['User'] = user!.toJson();
    }
    if (division != null) {
      data['Division'] = division!.toJson();
    }
    return data;
  }
}

class User {
  String? fullName;

  User({this.fullName});

  User.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fullName'] = fullName;
    return data;
  }
}

class Division {
  String? divisionName;

  Division({this.divisionName});

  Division.fromJson(Map<String, dynamic> json) {
    divisionName = json['divisionName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['divisionName'] = divisionName;
    return data;
  }
}

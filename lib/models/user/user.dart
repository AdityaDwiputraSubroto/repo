class UserOwnProfile {
  int? id;
  String? username;
  String? fullName;
  String? email;
  String? generation;
  String? phoneNumber;
  String? photoProfile;
  int? idDivision;
  int? idRole;
  bool? verify;
  Role? role;
  Division? division;

  UserOwnProfile(
      {this.id,
      this.username,
      this.fullName,
      this.email,
      this.generation,
      this.phoneNumber,
      this.photoProfile,
      this.idDivision,
      this.idRole,
      this.verify,
      this.role,
      this.division});

  UserOwnProfile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    fullName = json['fullName'];
    email = json['email'];
    generation = json['generation'];
    phoneNumber = json['phoneNumber'];
    photoProfile = json['photoProfile'];
    idDivision = json['id_division'];
    idRole = json['id_role'];
    verify = json['verify'];
    role = json['Role'] != null ? Role.fromJson(json['Role']) : null;
    division =
        json['Division'] != null ? Division.fromJson(json['Division']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['fullName'] = fullName;
    data['email'] = email;
    data['generation'] = generation;
    data['phoneNumber'] = phoneNumber;
    data['photoProfile'] = photoProfile;
    data['id_division'] = idDivision;
    data['id_role'] = idRole;
    data['verify'] = verify;
    if (role != null) {
      data['Role'] = role!.toJson();
    }
    if (division != null) {
      data['Division'] = division!.toJson();
    }
    return data;
  }
}

class Role {
  String? roleName;

  Role({this.roleName});

  Role.fromJson(Map<String, dynamic> json) {
    roleName = json['roleName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['roleName'] = roleName;
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

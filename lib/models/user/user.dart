class UserOwnProfile {
  int? id;
  String? username;
  String? fullName;
  String? email;
  String? generation;
  String? phoneNumber;
  String? photoProfile;
  String? createdAt;
  bool? verify;
  int? idRole;
  String? divisionName;

  UserOwnProfile(
      {this.id,
      this.username,
      this.fullName,
      this.email,
      this.generation,
      this.phoneNumber,
      this.photoProfile,
      this.createdAt,
      this.verify,
      this.idRole,
      this.divisionName});

  UserOwnProfile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    fullName = json['fullName'];
    email = json['email'];
    generation = json['generation'];
    phoneNumber = json['phoneNumber'];
    photoProfile = json['photoProfile'];
    createdAt = json['createdAt'];
    verify = json['verify'];
    idRole = json['id_role'];
    divisionName = json['divisionName'];
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
    data['createdAt'] = createdAt;
    data['verify'] = verify;
    data['id_role'] = idRole;
    data['divisionName'] = divisionName;
    return data;
  }
}

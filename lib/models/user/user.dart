class User {
  User({
    required this.id,
    required this.username,
    required this.fullName,
    required this.email,
    this.generation,
    this.phoneNumber,
    this.photoProfile,
    required this.idDivision,
    required this.idRole,
    required this.verify,
  });

  int id;
  String username;
  String fullName;
  String email;
  String? generation;
  String? phoneNumber;
  String? photoProfile;
  int idDivision;
  int idRole;
  bool verify;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        username: json['username'],
        fullName: json['fullName'],
        email: json['email'],
        generation: json['generation'],
        phoneNumber: json['phoneNumber'],
        photoProfile: json['photoProfile'],
        idDivision: json['id_division'],
        idRole: json['id_role'],
        verify: json['verify'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'fullName': fullName,
        'email': email,
        'generation': generation,
        'phoneNumber': phoneNumber,
        'photoProfile': photoProfile,
        'id_division': idDivision,
        'id_role': idRole,
        'verify': verify,
      };
}

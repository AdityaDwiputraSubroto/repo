class UserLoginRequest {
  UserLoginRequest({
    required this.emailUsername,
    required this.password,
  });
  late final String emailUsername;
  late final String password;

  UserLoginRequest.fromJson(Map<String, dynamic> json) {
    emailUsername = json['emailUsername'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['emailUsername'] = emailUsername;
    data['password'] = password;
    return data;
  }
}

class LoginResponse {
  LoginResponse({
    required this.status,
    required this.data,
  });

  String status;
  Data data;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        status: json['status'],
        data: Data.fromJson(json['data']),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'data': data.toJson(),
      };
}

class Data {
  Data({
    required this.user,
  });

  User user;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        user: User.fromJson(json['user']),
      );

  Map<String, dynamic> toJson() => {
        'user': user.toJson(),
      };
}

class User {
  User({
    required this.accessToken,
    required this.refreshToken,
  });

  String accessToken;
  String refreshToken;

  factory User.fromJson(Map<String, dynamic> json) => User(
        accessToken: json['accessToken'],
        refreshToken: json['refreshToken'],
      );

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      };
}

class ForgotPasswordResponse {
  ForgotPasswordResponse({
    required this.status,
    required this.message,
  });

  String status;
  String message;

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) =>
      ForgotPasswordResponse(
        status: json['status'],
        message: json['message'],
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
      };
}

class ForgotPasswordRequest {
  ForgotPasswordRequest({
    required this.email,
  });
  late final String email;

  ForgotPasswordRequest.fromJson(Map<String, dynamic> json) {
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['email'] = email;
    return data;
  }
}

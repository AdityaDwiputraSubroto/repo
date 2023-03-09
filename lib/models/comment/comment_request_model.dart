class CommentRequest {
  CommentRequest({
    required this.body,
  });

  String body;

  factory CommentRequest.fromJson(Map<String, dynamic> json) => CommentRequest(
        body: json['body'],
      );

  Map<String, dynamic> toJson() => {
        'body': body,
      };
}

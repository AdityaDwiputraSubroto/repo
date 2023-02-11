class StoreDiscussionRequest {
  StoreDiscussionRequest({
    required this.title,
    required this.body,
  });
  late final String title;
  late final String body;

  StoreDiscussionRequest.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['title'] = title;
    data['body'] = body;
    return data;
  }
}

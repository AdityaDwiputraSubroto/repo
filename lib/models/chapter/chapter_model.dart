class ChapterResponse {
  int? id;
  String? title;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? idCourse;

  ChapterResponse({
    this.id,
    this.title,
    this.createdAt,
    this.updatedAt,
    this.idCourse,
  });

  factory ChapterResponse.fromJson(Map<String, dynamic> json) =>
      ChapterResponse(
        id: json["id"],
        title: json["title"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        idCourse: json["id_course"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "id_course": idCourse,
      };
}

class ChapterAndArticleResponse {
  ChapterAndArticleResponse({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.idCourse,
    required this.articles,
  });

  int id;
  String title;
  DateTime createdAt;
  DateTime updatedAt;
  int idCourse;
  List<Article> articles;

  factory ChapterAndArticleResponse.fromJson(Map<String, dynamic> json) =>
      ChapterAndArticleResponse(
        id: json['id'],
        title: json['title'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        idCourse: json['id_course'],
        articles: List<Article>.from(
            json['Articles'].map((x) => Article.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'id_course': idCourse,
        'Articles': List<dynamic>.from(articles.map((x) => x.toJson())),
      };
}

class Article {
  Article({
    required this.id,
    required this.title,
    required this.idChapter,
  });

  int id;
  String title;
  int idChapter;

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        id: json["id"],
        title: json["title"],
        idChapter: json["id_chapter"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "id_chapter": idChapter,
      };
}

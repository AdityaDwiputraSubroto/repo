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

    factory ChapterResponse.fromJson(Map<String, dynamic> json) => ChapterResponse(
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
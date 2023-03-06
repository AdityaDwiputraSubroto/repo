class FetchArticleByIdChapterAndIdArticle {
  int? id;
  String? title;
  String? content;
  String? createdAt;
  String? updatedAt;
  int? idChapter;

  FetchArticleByIdChapterAndIdArticle(
      {this.id,
      this.title,
      this.content,
      this.createdAt,
      this.updatedAt,
      this.idChapter});

  FetchArticleByIdChapterAndIdArticle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    idChapter = json['id_chapter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['content'] = content;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['id_chapter'] = idChapter;
    return data;
  }
}

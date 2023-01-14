class DivisionWrapper {
  String? status;
  String? message;
  List<DivisionResponse>? data;

  DivisionWrapper({this.status, this.message, this.data});

  DivisionWrapper.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DivisionResponse>[];
      json['data'].forEach((v) {
        data!.add(DivisionResponse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DivisionResponse {
  int? id;
  String? divisionName;

  DivisionResponse({this.id, this.divisionName});

  DivisionResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    divisionName = json['divisionName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['divisionName'] = divisionName;
    return data;
  }
}

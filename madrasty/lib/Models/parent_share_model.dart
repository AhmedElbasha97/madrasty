// To parse this JSON data, do
//
//     final parentShareModel = parentShareModelFromJson(jsonString);

import 'dart:convert';

List<ParentShareModel> parentShareModelFromJson(String str) => List<ParentShareModel>.from(json.decode(str).map((x) => ParentShareModel.fromJson(x)));

String parentShareModelToJson(List<ParentShareModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ParentShareModel {
  int? id;
  String? name;
  String? type;
  String? student;

  ParentShareModel({
    this.id,
    this.name,
    this.type,
    this.student,
  });

  factory ParentShareModel.fromJson(Map<String, dynamic> json) => ParentShareModel(
    id: json["id"],
    name: json["name"],
    type: json["type"],
    student: json["student"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "type": type,
    "student": student,
  };
}

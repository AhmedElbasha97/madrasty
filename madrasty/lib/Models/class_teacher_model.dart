// To parse this JSON data, do
//
//     final classTeacherModel = classTeacherModelFromJson(jsonString);

import 'dart:convert';

List<ClassTeacherModel> classTeacherModelFromJson(String str) => List<ClassTeacherModel>.from(json.decode(str).map((x) => ClassTeacherModel.fromJson(x)));

String classTeacherModelToJson(List<ClassTeacherModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ClassTeacherModel {
  int? id;
  String? title;
  String? titleEn;

  ClassTeacherModel({
    this.id,
    this.title,
    this.titleEn,
  });

  factory ClassTeacherModel.fromJson(Map<String, dynamic> json) => ClassTeacherModel(
    id: json["id"],
    title: json["title"],
    titleEn: json["title_en"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "title_en": titleEn,
  };
}

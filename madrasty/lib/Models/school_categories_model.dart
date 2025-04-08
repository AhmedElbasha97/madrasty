// To parse this JSON data, do
//
//     final schoolCategoriesModel = schoolCategoriesModelFromJson(jsonString);

import 'dart:convert';

List<SchoolCategoriesModel> schoolCategoriesModelFromJson(String str) => List<SchoolCategoriesModel>.from(json.decode(str).map((x) => SchoolCategoriesModel.fromJson(x)));

String schoolCategoriesModelToJson(List<SchoolCategoriesModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SchoolCategoriesModel {
  int? id;
  String? title;
  String? titleEn;
  String? type;

  SchoolCategoriesModel({
    this.id,
    this.title,
    this.titleEn,
    this.type,
  });

  factory SchoolCategoriesModel.fromJson(Map<String, dynamic> json) => SchoolCategoriesModel(
    id: json["id"],
    title: json["title"],
    titleEn: json["title_en"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "title_en": titleEn,
    "type": type,
  };
}

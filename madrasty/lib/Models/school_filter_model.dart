// To parse this JSON data, do
//
//     final schoolFilterModel = schoolFilterModelFromJson(jsonString);

import 'dart:convert';

List<SchoolFilterModel> schoolFilterModelFromJson(String str) => List<SchoolFilterModel>.from(json.decode(str).map((x) => SchoolFilterModel.fromJson(x)));

String schoolFilterModelToJson(List<SchoolFilterModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SchoolFilterModel {
  int? id;
  String? title;
  String? titleEn;

  SchoolFilterModel({
    this.id,
    this.title,
    this.titleEn,
  });

  factory SchoolFilterModel.fromJson(Map<String, dynamic> json) => SchoolFilterModel(
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

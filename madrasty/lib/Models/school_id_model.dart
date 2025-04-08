// To parse this JSON data, do
//
//     final schoolIdModel = schoolIdModelFromJson(jsonString);

import 'dart:convert';

SchoolIdModel schoolIdModelFromJson(String str) => SchoolIdModel.fromJson(json.decode(str));

String schoolIdModelToJson(SchoolIdModel data) => json.encode(data.toJson());

class SchoolIdModel {
  int? id;
  String? name;
  int? school;
  int? schoolIdModelClass;

  SchoolIdModel({
    this.id,
    this.name,
    this.school,
    this.schoolIdModelClass,
  });

  factory SchoolIdModel.fromJson(Map<String, dynamic> json) => SchoolIdModel(
    id: json["id"],
    name: json["name"],
    school: json["school"],
    schoolIdModelClass: json["class"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "school": school,
    "class": schoolIdModelClass,
  };
}

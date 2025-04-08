// To parse this JSON data, do
//
//     final teacherInfoModel = teacherInfoModelFromJson(jsonString);

import 'dart:convert';

TeacherInfoModel teacherInfoModelFromJson(String str) => TeacherInfoModel.fromJson(json.decode(str));

String teacherInfoModelToJson(TeacherInfoModel data) => json.encode(data.toJson());

class TeacherInfoModel {
  int? id;
  String? name;
  int? school;
  List<Class>? teacherInfoModelClass;

  TeacherInfoModel({
    this.id,
    this.name,
    this.school,
    this.teacherInfoModelClass,
  });

  factory TeacherInfoModel.fromJson(Map<String, dynamic> json) => TeacherInfoModel(
    id: json["id"],
    name: json["name"],
    school: json["school"],
    teacherInfoModelClass: json["class"] == null ? [] : List<Class>.from(json["class"]!.map((x) => Class.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "school": school,
    "class": teacherInfoModelClass == null ? [] : List<dynamic>.from(teacherInfoModelClass!.map((x) => x.toJson())),
  };
}

class Class {
  int? id;
  String? name;
  String? nameEn;

  Class({
    this.id,
    this.name,
    this.nameEn,
  });

  factory Class.fromJson(Map<String, dynamic> json) => Class(
    id: json["id"],
    name: json["name"],
    nameEn: json["name_en"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "name_en": nameEn,
  };
}

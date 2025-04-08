// To parse this JSON data, do
//
//     final studentShareModel = studentShareModelFromJson(jsonString);

import 'dart:convert';

List<StudentShareModel> studentShareModelFromJson(String str) => List<StudentShareModel>.from(json.decode(str).map((x) => StudentShareModel.fromJson(x)));

String studentShareModelToJson(List<StudentShareModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StudentShareModel {
  int? id;
  String? name;

  StudentShareModel({
    this.id,
    this.name,
  });

  factory StudentShareModel.fromJson(Map<String, dynamic> json) => StudentShareModel(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

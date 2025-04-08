// To parse this JSON data, do
//
//     final schoolModel = schoolModelFromJson(jsonString);

import 'dart:convert';

List<SchoolModel> schoolModelFromJson(String str) => List<SchoolModel>.from(json.decode(str).map((x) => SchoolModel.fromJson(x)));

String schoolModelToJson(List<SchoolModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SchoolModel {
  int? id;
  String? name;
  String? brief;
  String? logo;

  SchoolModel({
    this.id,
    this.name,
    this.brief,
    this.logo,
  });

  factory SchoolModel.fromJson(Map<String, dynamic> json) => SchoolModel(
    id: json["id"],
    name: json["name"],
    brief: json["brief"],
    logo: json["logo"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "brief": brief,
    "logo": logo,
  };
}

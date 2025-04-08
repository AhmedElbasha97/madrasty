// To parse this JSON data, do
//
//     final studentModel = studentModelFromJson(jsonString);

import 'dart:convert';

List<PersonModel> studentModelFromJson(String str) => List<PersonModel>.from(json.decode(str).map((x) => PersonModel.fromJson(x)));

String studentModelToJson(List<PersonModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PersonModel {
  int? id;
  String? name;

  PersonModel({
    this.id,
    this.name,
  });

  factory PersonModel.fromJson(Map<String, dynamic> json) => PersonModel(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

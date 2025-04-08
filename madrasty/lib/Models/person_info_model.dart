// To parse this JSON data, do
//
//     final personInfoModel = personInfoModelFromJson(jsonString);

import 'dart:convert';

PersonInfoModel personInfoModelFromJson(String str) => PersonInfoModel.fromJson(json.decode(str));

String personInfoModelToJson(PersonInfoModel data) => json.encode(data.toJson());

class PersonInfoModel {
  int? id;
  String? name;
  int? school;
  int? personInfoModelClass;

  PersonInfoModel({
    this.id,
    this.name,
    this.school,
    this.personInfoModelClass,
  });

  factory PersonInfoModel.fromJson(Map<String, dynamic> json) => PersonInfoModel(
    id: json["id"],
    name: json["name"],
    school: json["school"],
    personInfoModelClass: json["class"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "school": school,
    "class": personInfoModelClass,
  };
}

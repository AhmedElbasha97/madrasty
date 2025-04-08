// To parse this JSON data, do
//
//     final kidsModel = kidsModelFromJson(jsonString);

import 'dart:convert';

List<KidsModel> kidsModelFromJson(String str) => List<KidsModel>.from(json.decode(str).map((x) => KidsModel.fromJson(x)));

String kidsModelToJson(List<KidsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class KidsModel {
  int? id;
  String? name;
  School? school;

  KidsModel({
    this.id,
    this.name,
    this.school,
  });

  factory KidsModel.fromJson(Map<String, dynamic> json) => KidsModel(
    id: json["id"],
    name: json["name"],
    school: json["school"] == null ? null : School.fromJson(json["school"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "school": school?.toJson(),
  };
}

class School {
  int? id;
  String? name;
  String? logo;
  String? locationLon;
  String? locationLat;

  School({
    this.id,
    this.name,
    this.logo,
    this.locationLon,
    this.locationLat,
  });

  factory School.fromJson(Map<String, dynamic> json) => School(
    id: json["id"],
    name: json["name"],
    logo: json["logo"],
    locationLon: json["location_lon"],
    locationLat: json["location_lat"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "logo": logo,
    "location_lon": locationLon,
    "location_lat": locationLat,
  };
}

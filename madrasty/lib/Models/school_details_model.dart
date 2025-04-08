// To parse this JSON data, do
//
//     final schooldetailModel = schooldetailModelFromJson(jsonString);

import 'dart:convert';


List<SchoolDetailModel> schoolDetailModelFromJson(String str) => List<SchoolDetailModel>.from(json.decode(str).map((x) => SchoolDetailModel.fromJson(x)));

String schoolDetailModelToJson(List<SchoolDetailModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SchoolDetailModel {
  int? id;
  String? name;
  String? brief;
  String? logo;
  String? email;
  String? phone;
  String? whatsapp;
  String? website;
  String? locationLon;
  String? locationLat;

  SchoolDetailModel({
    this.id,
    this.name,
    this.brief,
    this.logo,
    this.email,
    this.phone,
    this.whatsapp,
    this.website,
    this.locationLon,
    this.locationLat,
  });

  factory SchoolDetailModel.fromJson(Map<String, dynamic> json) => SchoolDetailModel(
    id: json["id"],
    name: json["name"],
    brief: json["brief"],
    logo: json["logo"],
    email: json["email"],
    phone: json["phone"],
    whatsapp: json["whatsapp"],
    website: json["website"],
    locationLon: json["location_lon"],
    locationLat: json["location_lat"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "brief": brief,
    "logo": logo,
    "email": email,
    "phone": phone,
    "whatsapp": whatsapp,
    "website": website,
    "location_lon": locationLon,
    "location_lat": locationLat,
  };
}
// To parse this JSON data, do
//
//     final authModel = authModelFromJson(jsonString);

import 'dart:convert';

AuthModel authModelFromJson(String str) => AuthModel.fromJson(json.decode(str));

String authModelToJson(AuthModel data) => json.encode(data.toJson());

class AuthModel {
  String? status;
  String? msg;
  Info? info;

  AuthModel({
    this.status,
    this.msg,
    this.info,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
    status: json["status"],
    msg: json["msg"],
    info: json["info"] == null ? null : Info.fromJson(json["info"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "info": info?.toJson(),
  };
}

class Info {
  int? id;
  String? name;
  String? phone;
  String? school;
  String? type;
  int? otp;

  Info({
    this.id,
    this.name,
    this.phone,
    this.school,
    this.type,
    this.otp,
  });

  factory Info.fromJson(Map<String, dynamic> json) => Info(
    id: json["id"],
    name: json["name"],
    phone: json["phone"],
    school: json["school"],
    type: json["type"],
    otp: json["otp"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone": phone,
    "school": school,
    "type": type,
    "otp": otp,
  };
}

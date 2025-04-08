import 'dart:convert';

List<SocialMediaLinksModel> socialMediaLinksModelFromJson(String str) => List<SocialMediaLinksModel>.from(json.decode(str).map((x) => SocialMediaLinksModel.fromJson(x)));

String socialMediaLinksModelToJson(List<SocialMediaLinksModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SocialMediaLinksModel {
  String? facebook;
  String? tiktok;
  String? whatsApp;
  String? instagram;
  String? snapchat;

  SocialMediaLinksModel({
    this.facebook,
    this.tiktok,
    this.whatsApp,
    this.instagram,
    this.snapchat,
  });

  factory SocialMediaLinksModel.fromJson(Map<String, dynamic> json) => SocialMediaLinksModel(
    facebook: json["facebook"],
    tiktok: json["tiktok"],
    whatsApp: json["whatsApp"],
    instagram: json["instagram"],
    snapchat: json["snapchat"],
  );

  Map<String, dynamic> toJson() => {
    "facebook": facebook,
    "tiktok": tiktok,
    "whatsApp": whatsApp,
    "instagram": instagram,
    "snapchat": snapchat,
  };
}
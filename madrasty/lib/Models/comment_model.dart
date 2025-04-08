// To parse this JSON data, do
//
//     final commentModel = commentModelFromJson(jsonString);

import 'dart:convert';

List<CommentModel> commentModelFromJson(String str) => List<CommentModel>.from(json.decode(str).map((x) => CommentModel.fromJson(x)));

String commentModelToJson(List<CommentModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CommentModel {
  int? id;
  User? user;
  String? text;

  CommentModel({
    this.id,
    this.user,
    this.text,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
    id: json["id"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    text: json["text"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user": user?.toJson(),
    "text": text,
  };
}

class User {
  int? id;
  String? name;
  String? type;

  User({
    this.id,
    this.name,
    this.type,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "type": type,
  };
}

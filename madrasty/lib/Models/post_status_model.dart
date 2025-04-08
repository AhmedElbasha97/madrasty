import 'dart:convert';

PostStatusModel postStatusModelFromJson(String str) => PostStatusModel.fromJson(json.decode(str));

String postStatusModelToJson(PostStatusModel data) => json.encode(data.toJson());

class PostStatusModel {
  int? status;

  PostStatusModel({
    this.status,
  });

  factory PostStatusModel.fromJson(Map<String, dynamic> json) => PostStatusModel(
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
  };
}

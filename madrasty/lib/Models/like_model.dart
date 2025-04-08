import 'dart:convert';

LikeModel likeModelFromJson(String str) => LikeModel.fromJson(json.decode(str));

String likeModelToJson(LikeModel data) => json.encode(data.toJson());

class LikeModel {
  int? like;

  LikeModel({
    this.like,
  });

  factory LikeModel.fromJson(Map<String, dynamic> json) => LikeModel(
    like: json["like"],
  );

  Map<String, dynamic> toJson() => {
    "like": like,
  };
}

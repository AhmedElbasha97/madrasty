import 'dart:convert';

List<AcademicAndBehaviorRecommendationModel> academicAndBehaviorRecommendationModelFromJson(String str) => List<AcademicAndBehaviorRecommendationModel>.from(json.decode(str).map((x) => AcademicAndBehaviorRecommendationModel.fromJson(x)));

String academicAndBehaviorRecommendationModelToJson(List<AcademicAndBehaviorRecommendationModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AcademicAndBehaviorRecommendationModel {
  int? id;
  String? student;
  String? teacher;
  String? title;
  String? msg;
  String? datetime;

  AcademicAndBehaviorRecommendationModel({
    this.id,
    this.student,
    this.teacher,
    this.title,
    this.msg,
    this.datetime,
  });

  factory AcademicAndBehaviorRecommendationModel.fromJson(Map<String, dynamic> json) => AcademicAndBehaviorRecommendationModel(
    id: json["id"],
    student: json["student"],
    teacher: json["teacher"],
    title: json["title"],
    msg: json["msg"],
    datetime: json["datetime"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "student": student,
    "teacher": teacher,
    "title": title,
    "msg": msg,
    "datetime": datetime,
  };
}
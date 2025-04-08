import 'dart:convert';

List<AcademicAndBehaviorRecommendationReasonModel> academicAndBehaviorRecommendationReasonModelFromJson(String str) => List<AcademicAndBehaviorRecommendationReasonModel>.from(json.decode(str).map((x) => AcademicAndBehaviorRecommendationReasonModel.fromJson(x)));

String academicAndBehaviorRecommendationReasonModelToJson(List<AcademicAndBehaviorRecommendationReasonModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AcademicAndBehaviorRecommendationReasonModel {
  int? id;
  String? name;
  String? nameEn;

  AcademicAndBehaviorRecommendationReasonModel({
    this.id,
    this.name,
    this.nameEn,
  });

  factory AcademicAndBehaviorRecommendationReasonModel.fromJson(Map<String, dynamic> json) => AcademicAndBehaviorRecommendationReasonModel(
    id: json["id"],
    name: json["name"],
    nameEn: json["name_en"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "name_en": nameEn,
  };
}
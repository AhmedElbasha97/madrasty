import 'dart:convert';

PostingStatusModel postingStatusModelFromJson(String str) => PostingStatusModel.fromJson(json.decode(str));

String postingStatusModelToJson(PostingStatusModel data) => json.encode(data.toJson());

class PostingStatusModel {
  String? classId;
  String? teacherId;
  String? studentStatus;
  String? parentStatus;

  PostingStatusModel({
    this.classId,
    this.teacherId,
    this.studentStatus,
    this.parentStatus,
  });

  factory PostingStatusModel.fromJson(Map<String, dynamic> json) => PostingStatusModel(
    classId: "${json["class_id"]}",
    teacherId: "${json["teacher_id"]}",
    studentStatus: "${json["student_status"]}",
    parentStatus: "${json["parent_status"]}",
  );

  Map<String, dynamic> toJson() => {
    "class_id": classId,
    "teacher_id": teacherId,
    "student_status": studentStatus,
    "parent_status": parentStatus,
  };
}

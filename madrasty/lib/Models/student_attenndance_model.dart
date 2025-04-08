// To parse this JSON data, do
//
//     final studentAttendanceModel = studentAttendanceModelFromJson(jsonString);

import 'dart:convert';

List<StudentAttendanceModel> studentAttendanceModelFromJson(String str) => List<StudentAttendanceModel>.from(json.decode(str).map((x) => StudentAttendanceModel.fromJson(x)));

String studentAttendanceModelToJson(List<StudentAttendanceModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StudentAttendanceModel {
  String? day;
  int? check;
  String? studentAttendanceModelIn;
  String? out;
  String? notes;

  StudentAttendanceModel({
    this.day,
    this.check,
    this.studentAttendanceModelIn,
    this.out,
    this.notes,
  });

  factory StudentAttendanceModel.fromJson(Map<String, dynamic> json) => StudentAttendanceModel(
    day: json["day"],
    check: json["check"],
    studentAttendanceModelIn: json["in"],
    out: json["out"],
    notes: json["notes"],
  );

  Map<String, dynamic> toJson() => {
    "day": day,
    "check": check,
    "in": studentAttendanceModelIn,
    "out": out,
    "notes": notes,
  };
}

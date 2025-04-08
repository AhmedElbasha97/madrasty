// To parse this JSON data, do
//
//     final attendanceTableModel = attendanceTableModelFromJson(jsonString);

import 'dart:convert';

List<AttendanceTableModel> attendanceTableModelFromJson(String str) => List<AttendanceTableModel>.from(json.decode(str).map((x) => AttendanceTableModel.fromJson(x)));

String attendanceTableModelToJson(List<AttendanceTableModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AttendanceTableModel {
  int? id;
  String? name;
  int? check;
  String? timeIn;
  String? timeOut;
  String? notes;


  AttendanceTableModel({
    this.id,
    this.name,
    this.check,
    this.timeIn,
    this.timeOut,
    this.notes,

  });

  factory AttendanceTableModel.fromJson(Map<String, dynamic> json) => AttendanceTableModel(
    id: json["id"],
    name: json["name"],
    check: json["check"],
    timeIn: json["in"],
    timeOut: json["out"],
    notes: json["notes"],

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "check": check,
    "in": timeIn,
    "out": timeOut,
    "notes": notes,

  };
}

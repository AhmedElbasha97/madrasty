// To parse this JSON data, do
//
//     final teacherSchedulesClassModel = teacherSchedulesClassModelFromJson(jsonString);

import 'dart:convert';

TeacherSchedulesClassModel teacherSchedulesClassModelFromJson(String str) => TeacherSchedulesClassModel.fromJson(json.decode(str));

String teacherSchedulesClassModelToJson(TeacherSchedulesClassModel data) => json.encode(data.toJson());

class TeacherSchedulesClassModel {
  List<String>? header;
  List<RowOfClass>? rows;

  TeacherSchedulesClassModel({
    this.header,
    this.rows,
  });

  factory TeacherSchedulesClassModel.fromJson(Map<String, dynamic> json) => TeacherSchedulesClassModel(
    header: json["header"] == null ? [] : List<String>.from(json["header"]!.map((x) => x)),
    rows: json["rows"] == null ? [] : List<RowOfClass>.from(json["rows"]!.map((x) => RowOfClass.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "header": header == null ? [] : List<dynamic>.from(header!.map((x) => x)),
    "rows": rows == null ? [] : List<dynamic>.from(rows!.map((x) => x.toJson())),
  };
}

class RowOfClass {
  String? day;
  List<List<ClassOfTheDay>>? classOfTheDay;

  RowOfClass({
    this.day,
    this.classOfTheDay,
  });

  factory RowOfClass.fromJson(Map<String, dynamic> json) => RowOfClass(
    day: json["day"],
    classOfTheDay: json["classOfTheDay"] == null ? [] : List<List<ClassOfTheDay>>.from(json["classOfTheDay"]!.map((x) => List<ClassOfTheDay>.from(x.map((x) => ClassOfTheDay.fromJson(x))))),
  );

  Map<String, dynamic> toJson() => {
    "day": day,
    "classOfTheDay": classOfTheDay == null ? [] : List<dynamic>.from(classOfTheDay!.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
  };
}

class ClassOfTheDay {
  String? subject;
  String? classOfTheDayClass;

  ClassOfTheDay({
    this.subject,
    this.classOfTheDayClass,
  });

  factory ClassOfTheDay.fromJson(Map<String, dynamic> json) => ClassOfTheDay(
    subject: json["subject"],
    classOfTheDayClass: json["class"],
  );

  Map<String, dynamic> toJson() => {
    "subject": subject,
    "class": classOfTheDayClass,
  };
}
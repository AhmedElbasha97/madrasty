// To parse this JSON data, do
//
//     final classSchedulesModel = classSchedulesModelFromJson(jsonString);

import 'dart:convert';

ClassSchedulesModel classSchedulesModelFromJson(String str) => ClassSchedulesModel.fromJson(json.decode(str));

String classSchedulesModelToJson(ClassSchedulesModel data) => json.encode(data.toJson());

class ClassSchedulesModel {
  List<String>? header;
  List<RowOfSubjects>? rows;

  ClassSchedulesModel({
    this.header,
    this.rows,
  });

  factory ClassSchedulesModel.fromJson(Map<String, dynamic> json) => ClassSchedulesModel(
    header: json["header"] == null ? [] : List<String>.from(json["header"]!.map((x) => x)),
    rows: json["rows"] == null ? [] : List<RowOfSubjects>.from(json["rows"]!.map((x) => RowOfSubjects.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "header": header == null ? [] : List<dynamic>.from(header!.map((x) => x)),
    "rows": rows == null ? [] : List<dynamic>.from(rows!.map((x) => x.toJson())),
  };
}

class RowOfSubjects {
  String? day;
  List<ClassOfTheDay>? classOfTheDay;

  RowOfSubjects({
    this.day,
    this.classOfTheDay,
  });

  factory RowOfSubjects.fromJson(Map<String, dynamic> json) => RowOfSubjects(
    day: json["day"],
    classOfTheDay: json["classOfTheDay"] == null ? [] : List<ClassOfTheDay>.from(json["classOfTheDay"]!.map((x) => ClassOfTheDay.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "day": day,
    "classOfTheDay": classOfTheDay == null ? [] : List<dynamic>.from(classOfTheDay!.map((x) => x.toJson())),
  };
}

class ClassOfTheDay {
  String? subject;
  String? teacher;

  ClassOfTheDay({
    this.subject,
    this.teacher,
  });

  factory ClassOfTheDay.fromJson(Map<String, dynamic> json) => ClassOfTheDay(
    subject: json["subject"],
    teacher: json["teacher"],
  );

  Map<String, dynamic> toJson() => {
    "subject": subject,
    "teacher": teacher,
  };
}

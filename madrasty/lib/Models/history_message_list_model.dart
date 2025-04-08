// To parse this JSON data, do
//
//     final historyMessagesListModel = historyMessagesListModelFromJson(jsonString);

import 'dart:convert';

List<HistoryMessagesListModel> historyMessagesListModelFromJson(String str) => List<HistoryMessagesListModel>.from(json.decode(str).map((x) => HistoryMessagesListModel.fromJson(x)));

String historyMessagesListModelToJson(List<HistoryMessagesListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HistoryMessagesListModel {
  int? id;
  String? name;
  String? type;
  LastMsg? lastMsg;

  HistoryMessagesListModel({
    this.id,
    this.name,
    this.type,
    this.lastMsg,
  });

  factory HistoryMessagesListModel.fromJson(Map<String, dynamic> json) => HistoryMessagesListModel(
    id: json["id"],
    name: json["name"],
    type: json["type"],
    lastMsg: json["last_msg"] == null ? null : LastMsg.fromJson(json["last_msg"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "type": type,
    "last_msg": lastMsg?.toJson(),
  };
}

class LastMsg {
  String? text;
  String? type;
  String? view;
  String? date;

  LastMsg({
    this.text,
    this.type,
    this.view,
    this.date,
  });

  factory LastMsg.fromJson(Map<String, dynamic> json) => LastMsg(
    text: json["text"],
    type: json["type"],
    view: "${json["view"]}",
    date: json["date"] ,
  );

  Map<String, dynamic> toJson() => {
    "text": text,
    "type": type,
    "view": view,
    "date": date,
  };
}



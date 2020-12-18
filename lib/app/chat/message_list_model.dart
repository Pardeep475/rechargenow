// To parse this JSON data, do
//
//     final messageListPojo = messageListPojoFromJson(jsonString);

import 'dart:convert';

MessageListPojo messageListPojoFromJson(String str) => MessageListPojo.fromJson(json.decode(str));

String messageListPojoToJson(MessageListPojo data) => json.encode(data.toJson());

class MessageListPojo {
  List<MessageList> messageList;
  String message;
  int status;

  MessageListPojo({
    this.messageList,
    this.message,
    this.status,
  });

  factory MessageListPojo.fromJson(Map<String, dynamic> json) => MessageListPojo(
    messageList: List<MessageList>.from(json["messageList"].map((x) => MessageList.fromJson(x))),
    message: json["message"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "messageList": List<dynamic>.from(messageList.map((x) => x.toJson())),
    "message": message,
    "status": status,
  };
}

class MessageList {
  String imagePath;
  String createdOnStr;
  int id;
  String message;
  DateTime createdOn;
  int userId;
  String sentBy;

  MessageList({
    this.imagePath,
    this.createdOnStr,
    this.id,
    this.message,
    this.createdOn,
    this.userId,
    this.sentBy,
  });

  factory MessageList.fromJson(Map<String, dynamic> json) => MessageList(
    imagePath: json["imagePath"] == null ? null : json["imagePath"],
    createdOnStr: json["createdOnStr"],
    id: json["id"],
    message: json["message"],
    createdOn: DateTime.parse(json["createdOn"]),
    userId: json["userId"],
    sentBy: json["sentBy"],
  );

  Map<String, dynamic> toJson() => {
    "imagePath": imagePath == null ? null : imagePath,
    "createdOnStr": createdOnStr,
    "id": id,
    "message": message,
    "createdOn": createdOn.toIso8601String(),
    "userId": userId,
    "sentBy": sentBy,
  };
}

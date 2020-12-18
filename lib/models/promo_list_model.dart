// To parse this JSON data, do
//
//     final promosListPojo = promosListPojoFromJson(jsonString);

import 'dart:convert';

PromosListPojo promosListPojoFromJson(String str) => PromosListPojo.fromJson(json.decode(str));

String promosListPojoToJson(PromosListPojo data) => json.encode(data.toJson());

class PromosListPojo {
  List<PromoCode> promoCodes;
  String message;
  int status;

  PromosListPojo({
    this.promoCodes,
    this.message,
    this.status,
  });

  factory PromosListPojo.fromJson(Map<String, dynamic> json) => PromosListPojo(
    promoCodes: List<PromoCode>.from(json["promoCodes"].map((x) => PromoCode.fromJson(x))),
    message: json["message"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "promoCodes": List<dynamic>.from(promoCodes.map((x) => x.toJson())),
    "message": message,
    "status": status,
  };
}

class PromoCode {
  String name;
  String description;
  int id;
  String createdOnStr;

  PromoCode({
    this.name,
    this.description,
    this.id,
    this.createdOnStr,
  });

  factory PromoCode.fromJson(Map<String, dynamic> json) => PromoCode(
    name: json["name"],
    description: json["description"],
    id: json["id"],
    createdOnStr: json["createdOnStr"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "description": description,
    "id": id,
    "createdOnStr": createdOnStr,
  };
}

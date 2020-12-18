// To parse this JSON data, do
//
//     final userDetailsPojo = userDetailsPojoFromJson(jsonString);

import 'dart:convert';

UserDetailsPojo userDetailsPojoFromJson(String str) =>
    UserDetailsPojo.fromJson(json.decode(str));

String userDetailsPojoToJson(UserDetailsPojo data) =>
    json.encode(data.toJson());

class UserDetailsPojo {
  String message;
  UserDetails userDetails;
  int status;
  bool isRental;

  UserDetailsPojo({
    this.message,
    this.userDetails,
    this.status,
    this.isRental
  });

  factory UserDetailsPojo.fromJson(Map<String, dynamic> json) =>
      UserDetailsPojo(
        message: json["message"],
        userDetails: UserDetails.fromJson(json["userDetails"]),
        status: json["status"],
        isRental: json["isRental"],
      );

  Map<String, dynamic> toJson() => {
    "message": message,
    "userDetails": userDetails.toJson(),
    "status": status,
    "isRental":isRental
  };}

class UserDetails {
  bool usercodeUsed;
  bool deleted;
  String phoneNumber;
  String countryCode;
  String paymentMethod;
  int id;
  String usercode;
  DateTime createdOn;
  String email;
  String contactMethod;
  String walletAmount;


  UserDetails({
    this.usercodeUsed,
    this.deleted,
    this.phoneNumber,
    this.countryCode,
    this.paymentMethod,
    this.id,
    this.usercode,
    this.createdOn,
    this.email,
    this.contactMethod,
    this.walletAmount,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) =>
      UserDetails(
        usercodeUsed: json["usercodeUsed"],
        deleted: json["deleted"],
        phoneNumber: json["phoneNumber"],
        countryCode: json["countryCode"],
        paymentMethod: json["paymentMethod"],
        id: json["id"],
        usercode: json["usercode"],
        createdOn: DateTime.parse(json["createdOn"]),
        email: json["email"],
        contactMethod: json["contactMethod"],
        walletAmount: json["walletAmount"],
      );

  Map<String, dynamic> toJson() =>
      {
        "usercodeUsed": usercodeUsed,
        "deleted": deleted,
        "phoneNumber": phoneNumber,
        "countryCode": countryCode,
        "paymentMethod": paymentMethod,
        "id": id,
        "usercode": usercode,
        "createdOn": createdOn.toIso8601String(),
        "email": email,
        "contactMethod": contactMethod,
        "walletAmount": walletAmount,
      };
}

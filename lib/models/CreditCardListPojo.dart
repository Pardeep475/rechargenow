// To parse this JSON data, do
//
//     final creditCardListPojo = creditCardListPojoFromJson(jsonString);

import 'dart:convert';

CreditCardListPojo creditCardListPojoFromJson(String str) => CreditCardListPojo.fromJson(json.decode(str));

String creditCardListPojoToJson(CreditCardListPojo data) => json.encode(data.toJson());

class CreditCardListPojo {
  List<CreditCard> creditCards;
  String message;
  int status;

  CreditCardListPojo({
    this.creditCards,
    this.message,
    this.status,
  });

  factory CreditCardListPojo.fromJson(Map<String, dynamic> json) => CreditCardListPojo(
    creditCards: List<CreditCard>.from(json["creditCards"].map((x) => CreditCard.fromJson(x))),
    message: json["message"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "creditCards": List<dynamic>.from(creditCards.map((x) => x.toJson())),
    "message": message,
    "status": status,
  };
}

class CreditCard {
  String number;
  int expireMonth;
  bool active;
  int id;
  String type;
  int expireYear;
  String paymentMethod;
  String payerEmail;

  CreditCard({
    this.number,
    this.expireMonth,
    this.active,
    this.id,
    this.type,
    this.expireYear,
    this.paymentMethod,
    this.payerEmail
  });

  factory CreditCard.fromJson(Map<String, dynamic> json) => CreditCard(
    number: json["number"],
    expireMonth: json["expireMonth"],
    active: json["active"],
    id: json["id"],
    type: json["type"],
    expireYear: json["expireYear"],
    paymentMethod: json["paymentMethod"],
    payerEmail: json["payerEmail"],
  );

  Map<String, dynamic> toJson() => {
    "number": number,
    "expireMonth": expireMonth,
    "active": active,
    "id": id,
    "type": type,
    "expireYear": expireYear,
    "paymentMethod": paymentMethod,
    "payerEmail": payerEmail,
  };
}

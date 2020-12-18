
import 'dart:convert';

HistoryListPojo historyListPojoFromJson(String str) => HistoryListPojo.fromJson(json.decode(str));

String historyListPojoToJson(HistoryListPojo data) => json.encode(data.toJson());

class HistoryListPojo {
  List<History> history;
  String message;
  int status;

  HistoryListPojo({
    this.history,
    this.message,
    this.status,
  });

  factory HistoryListPojo.fromJson(Map<String, dynamic> json) => HistoryListPojo(
    history: List<History>.from(json["history"].map((x) => History.fromJson(x))),
    message: json["message"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "history": List<dynamic>.from(history.map((x) => x.toJson())),
    "message": message,
    "status": status,
  };
}

class History {
  String totalAmount;
  int totalRecords;
  String monthYear;
  String locationName;
  String latitude;
  String rentalTime;
  String powerbankNumber;
  String stationNumber;
  int id;
  String transactionDate;
  String rentalDate;
  String returnLocationName;
  String type;
  String paymentStatus;
  String longitude;

  History({
    this.totalAmount,
    this.totalRecords,
    this.locationName,
    this.returnLocationName,
    this.powerbankNumber,
    this.rentalDate,
    this.latitude,
    this.monthYear,
    this.rentalTime,
    this.stationNumber,
    this.id,
    this.transactionDate,
    this.type,
    this.paymentStatus,
    this.longitude,
  });

  factory History.fromJson(Map<String, dynamic> json) => History(
    totalAmount: json["totalAmount"],
    totalRecords: json["totalRecords"],
    locationName: json["locationName"],
    powerbankNumber: json["powerbankNumber"],
    rentalDate: json["rentalDate"],
    returnLocationName: json["returnLocationName"],
    stationNumber: json["stationNumber"],
    latitude: json["latitude"],
    rentalTime: json["rentalTime"],
    id: json["id"],
    transactionDate: json["transactionDate"],
    type: json["type"],
    monthYear: json["monthYear"],
    paymentStatus: json["paymentStatus"],
    longitude: json["longitude"],
  );

  Map<String, dynamic> toJson() => {
    "totalAmount": totalAmount,
    "totalRecords": totalRecords,
    "rentalDate": rentalDate,
    "powerbankNumber": powerbankNumber,
    "locationName": locationName,
    "returnLocationName": returnLocationName,
    "stationNumber": stationNumber,
    "monthYear": monthYear,
    "latitude": latitude,
    "rentalTime": rentalTime,
    "id": id,
    "transactionDate": transactionDate,
    "type": type,
    "paymentStatus": paymentStatus,
    "longitude": longitude,
  };
}

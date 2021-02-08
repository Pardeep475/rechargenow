// To parse this JSON data, do
//
//     final stationsListPojo = stationsListPojoFromJson(jsonString);

import 'dart:convert';

StationsListPojo stationsListPojoFromJson(String str) => StationsListPojo.fromJson(json.decode(str));

String stationsListPojoToJson(StationsListPojo data) => json.encode(data.toJson());

class StationsListPojo {
  String message;
  List<MapLocation> mapLocations;
  int status;

  StationsListPojo({
    this.message,
    this.mapLocations,
    this.status,
  });

  factory StationsListPojo.fromJson(Map<String, dynamic> json) => StationsListPojo(
    message: json["message"],
    mapLocations: List<MapLocation>.from(json["mapLocations"].map((x) => MapLocation.fromJson(x))),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "mapLocations": List<dynamic>.from(mapLocations.map((x) => x.toJson())),
    "status": status,
  };
}

class MapLocation {
  int id;
  String name;
  String houseNumber;
  String address;
  String pincode;
  String city;
  String country;
  String category;
  String distance;
  String latitude;
  String longitude;
  String description;
  String mondayHours;
  String tuesdayHours;
  String wednesdayHours;
  String thursdayHours;
  String fridayHours;
  String saturdayHours;
  String sundayHours;
  bool mondayClosed;
  bool tuesdayClosed;
  bool wednesdayClosed;
  bool thursdayClosed;
  bool fridayClosed;
  bool saturdayClosed;
  bool sundayClosed;
  int availablePowerbanks;
  int freeSlots;
  String imageFullPath;
  String imageAvatarPath;
  String status;
  bool open;
  int totalStaions;
  int stationSlots;

  MapLocation({
    this.id,
    this.name,
    this.houseNumber,
    this.address,
    this.pincode,
    this.city,
    this.country,
    this.category,
    this.distance,
    this.latitude,
    this.longitude,
    this.description,
    this.mondayHours,
    this.tuesdayHours,
    this.wednesdayHours,
    this.thursdayHours,
    this.fridayHours,
    this.saturdayHours,
    this.sundayHours,
    this.mondayClosed,
    this.tuesdayClosed,
    this.wednesdayClosed,
    this.thursdayClosed,
    this.fridayClosed,
    this.saturdayClosed,
    this.sundayClosed,
    this.availablePowerbanks,
    this.freeSlots,
    this.imageFullPath,
    this.imageAvatarPath,
    this.status,
    this.open,
    this.totalStaions,
    this.stationSlots,
  });

  factory MapLocation.fromJson(Map<String, dynamic> json) => MapLocation(
    id: json["id"],
    name: json["name"],
    houseNumber: json["houseNumber"],
    address: json["address"],
    pincode: json["pincode"],
    city: json["city"],
    country: json["country"],
    category: json["category"],
    distance: json["distance"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    description: json["description"],
    mondayHours: json["mondayHours"],
    tuesdayHours: json["tuesdayHours"],
    wednesdayHours: json["wednesdayHours"],
    thursdayHours: json["thursdayHours"],
    fridayHours: json["fridayHours"],
    saturdayHours: json["saturdayHours"],
    sundayHours: json["sundayHours"],
    mondayClosed: json["mondayClosed"],
    tuesdayClosed: json["tuesdayClosed"],
    wednesdayClosed: json["wednesdayClosed"],
    thursdayClosed: json["thursdayClosed"],
    fridayClosed: json["fridayClosed"],
    saturdayClosed: json["saturdayClosed"],
    sundayClosed: json["sundayClosed"],
    availablePowerbanks: json["availablePowerbanks"],
    freeSlots: json["freeSlots"],
    imageFullPath: json["imagePath"],
    imageAvatarPath: json["thumbnailPath"],
    status: json["status"],
    open:json["open"],
    totalStaions:json["totalStations"],
    stationSlots:json["stationSlots"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "houseNumber": houseNumber,
    "address": address,
    "pincode": pincode,
    "city": city,
    "country": country,
    "category": category,
    "distance": distance,
    "latitude": latitude,
    "longitude": longitude,
    "description": description,
    "mondayHours": mondayHours,
    "tuesdayHours": tuesdayHours,
    "wednesdayHours": wednesdayHours,
    "thursdayHours": thursdayHours,
    "fridayHours": fridayHours,
    "saturdayHours": saturdayHours,
    "sundayHours": sundayHours,
    "mondayClosed": mondayClosed,
    "tuesdayClosed": tuesdayClosed,
    "wednesdayClosed": wednesdayClosed,
    "thursdayClosed": thursdayClosed,
    "fridayClosed": fridayClosed,
    "saturdayClosed": saturdayClosed,
    "sundayClosed": sundayClosed,
    "availablePowerbanks": availablePowerbanks,
    "freeSlots": freeSlots,
    "imagePath": imageFullPath,
    "thumbnailPath": imageAvatarPath,
    "status": status,
    "open": open,
    "totalStations": totalStaions,
    "stationSlots": stationSlots,

  };
}

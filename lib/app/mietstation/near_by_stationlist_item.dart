// To parse this JSON data, do
//
//     final nearbyStationsListPojo = nearbyStationsListPojoFromJson(jsonString);

import 'dart:convert';

NearbyStationsListPojo nearbyStationsListPojoFromJson(String str) => NearbyStationsListPojo.fromJson(json.decode(str));

String nearbyStationsListPojoToJson(NearbyStationsListPojo data) => json.encode(data.toJson());

class NearbyStationsListPojo {
  String message;
  List<NearbyLocation> nearbyLocations;
  int status;

  NearbyStationsListPojo({
    this.message,
    this.nearbyLocations,
    this.status,
  });

  factory NearbyStationsListPojo.fromJson(Map<String, dynamic> json) => NearbyStationsListPojo(
    message: json["message"],
    nearbyLocations: List<NearbyLocation>.from(json["nearbyLocations"].map((x) => NearbyLocation.fromJson(x))),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "nearbyLocations": List<dynamic>.from(nearbyLocations.map((x) => x.toJson())),
    "status": status,
  };
}

class NearbyLocation {
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
  bool open;
  int availablePowerbanks;
  int freeSlots;
  String imageFullPath;
  String imageAvatarPath;
  String status;

  NearbyLocation({
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
    this.open,
    this.sundayClosed,
    this.availablePowerbanks,
    this.freeSlots,
    this.imageFullPath,
    this.imageAvatarPath,
    this.status,
  });

  factory NearbyLocation.fromJson(Map<String, dynamic> json) => NearbyLocation(
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
    open: json["open"],
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
  };
}

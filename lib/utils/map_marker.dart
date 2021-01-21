import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'package:recharge_now/app/home_screen.dart';
import 'package:recharge_now/models/station_list_model.dart';

class MapMarker extends Clusterable {
  final String id;
  final LatLng position;
  BitmapDescriptor icon;
  MapLocation data;
  BuildContext context;
  final  homeScreenState = HomeScreenState();
  MapMarker({
    @required this.id,
    @required this.position,
    this.icon,
    this.data,
    this.context,
    isCluster = false,
    clusterId,
    pointsSize,
    childMarkerId,
  }) : super(
          markerId: id,
          latitude: position.latitude,
          longitude: position.longitude,
          isCluster: isCluster,
          clusterId: clusterId,
          pointsSize: pointsSize,
          childMarkerId: childMarkerId,
        );

  Marker toMarker() => Marker(
        markerId: MarkerId(isCluster ? 'cl_$id' : id),
        position: LatLng(
          position.latitude,
          position.longitude,
        ),
        icon: icon,
        onTap: () {
          homeScreenState.onMarkerClick(data,context);
        },
      );

}

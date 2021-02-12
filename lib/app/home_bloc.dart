import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
class HomeBloc {
  StreamController _homeController = StreamController<Set<Marker>>();

  StreamSink<Set<Marker>> get homeSink => _homeController.sink;

  Stream<Set<Marker>> get homeStream => _homeController.stream;




}

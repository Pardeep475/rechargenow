import 'dart:async';

import 'package:rxdart/rxdart.dart';

class TimerBloc {
  Stream get progressStream => progressController.stream;

  final BehaviorSubject progressController = BehaviorSubject<int>();

  StreamSink get progressSink => progressController.sink;
}

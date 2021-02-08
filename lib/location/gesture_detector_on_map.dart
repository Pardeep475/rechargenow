import 'package:flutter/gestures.dart';

class GestureDetectorOnMap extends DragGestureRecognizer {
  Function _gestureDetector;

  GestureDetectorOnMap(this._gestureDetector);

  @override
  bool isFlingGesture(VelocityEstimate estimate, PointerDeviceKind kind) {
    return true;
  }

  @override
  void resolve(GestureDisposition disposition) {
    super.resolve(disposition);
    this._gestureDetector();
  }

  @override
  String get debugDescription => "testing";
}

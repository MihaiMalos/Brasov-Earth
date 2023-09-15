import 'dart:typed_data';

import 'package:brasov_earth/repositories/models/interfaces/coordinates_model.dart';

abstract interface class LandmarkModel {
  Uint8List? get icon;
  String get name;
  CoordinatesModel get coordinates;
  String get adress;

  double distanceFromCoordinates(CoordinatesModel coordinates);

  static String formatDistance(double distance) {
    if (distance < 1000) {
      return '${distance.floor()} m';
    }
    String integerPart = (distance ~/ 1000).toString();
    String decimalPart = (distance % 1).toStringAsFixed(1).substring(2);
    return '$integerPart.$decimalPart km';
  }
}

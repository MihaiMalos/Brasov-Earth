import 'package:flutter/services.dart';
import 'package:gem_kit/api/gem_coordinates.dart';

abstract interface class PositionRepository {
  Future<void> followPosition();
  Coordinates? screenSizeToCoordinates(Size screenSize);
  Future<void> centerOnCoordinates(Coordinates coordinates);
}

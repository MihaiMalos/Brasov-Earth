import 'package:gem_kit/api/gem_coordinates.dart';

abstract interface class PositionRepository {
  Future<void> followPosition();
  Coordinates? screenSizeToCoordinates({required int x, required int y});
  Future<void> centerOnCoordinates(Coordinates coordinates);
}

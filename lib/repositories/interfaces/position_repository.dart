import 'package:brasov_earth/repositories/models/interfaces/coordinates_model.dart';

abstract interface class PositionRepository {
  Future<void> init();
  Future<void> followPosition();
  CoordinatesModel get mapCenterCoordinates;
  CoordinatesModel? get locationCoordinates;
  Future<void> centerOnCoordinates(CoordinatesModel coordinates);
}

import 'package:brasov_earth/repositories/models/interfaces/coordinates_model.dart';
import 'package:gem_kit/api/gem_coordinates.dart';

class CoordinatesModelImpl implements CoordinatesModel {
  final Coordinates _coordinates;

  const CoordinatesModelImpl(this._coordinates);

  @override
  double get latitude => _coordinates.latitude!;

  @override
  double get longitude => _coordinates.longitude!;

  @override
  double get altitude => _coordinates.altitude!;

  Coordinates get gemCoordinates => _coordinates;

  @override
  double distance(CoordinatesModel coordinates) {
    final gemCoordinates = coordinates as CoordinatesModelImpl;
    return gemCoordinates._coordinates.distance(_coordinates);
  }
}

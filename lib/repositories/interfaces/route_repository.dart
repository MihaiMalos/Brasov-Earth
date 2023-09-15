import 'dart:math';

import 'package:brasov_earth/repositories/models/interfaces/coordinates_model.dart';

abstract interface class RouteRepository {
  Future<void> init();
  Future<void> calculateSingleRoute(
    CoordinatesModel firstLocation,
    CoordinatesModel secondLocation,
  );
  Future<bool> selectRouteByScreenCoordinates(Point<num> pos);
  Future<void> removeRoutes();
}

import 'dart:math';

import 'package:brasov_earth/repositories/interfaces/route_repository.dart';
import 'package:brasov_earth/repositories/models/implementations/coordinates_model_impl.dart';
import 'package:brasov_earth/repositories/models/interfaces/coordinates_model.dart';
import 'package:gem_kit/api/gem_landmark.dart';
import 'package:gem_kit/api/gem_routingpreferences.dart';
import 'package:gem_kit/api/gem_routingservice.dart';
import 'package:gem_kit/gem_kit_basic.dart';
import 'package:gem_kit/gem_kit_map_controller.dart';

class RouteRepositoryImpl implements RouteRepository {
  final GemMapController _mapController;
  late RoutingService _routingService;
  final List<Route> shownRoutes;

  late bool haveRoutes;

  RouteRepositoryImpl({required GemMapController mapController})
      : _mapController = mapController,
        haveRoutes = false,
        shownRoutes = [];

  @override
  Future<void> init() async {
    RoutingService.create(_mapController.mapId).then((service) {
      _routingService = service;
    });
  }

  @override
  Future<void> calculateSingleRoute(
    CoordinatesModel firstLocation,
    CoordinatesModel secondLocation,
  ) async {
    removeRoutes();
    final routePreferences = RoutePreferences();
    final landmarkWaypoints = await LandmarkList.create(_mapController.mapId);

    final gemFirstCoords = firstLocation as CoordinatesModelImpl;
    final gemSecondCoords = secondLocation as CoordinatesModelImpl;

    final firstLandmark = Landmark.create();
    await firstLandmark.setCoordinates(gemFirstCoords.gemCoordinates);
    landmarkWaypoints.push_back(firstLandmark);

    final secondLandmark = Landmark.create();
    await secondLandmark.setCoordinates(gemSecondCoords.gemCoordinates);
    landmarkWaypoints.push_back(secondLandmark);

    await _routingService.calculateRoute(landmarkWaypoints, routePreferences,
        (err, routes) async {
      if (err != GemError.success || routes == null) {
        return;
      } else {
        // Get the controller's preferences
        final mapViewPreferences = _mapController.preferences();
        // Get the routes from the preferences
        final routesMap = await mapViewPreferences.routes();

        //Get the number of routes
        final routesSize = await routes.size();

        for (int i = 0; i < routesSize; i++) {
          final route = await routes.at(i);
          shownRoutes.add(route);

          final timeDistance = await route.getTimeDistance();

          final totalDistance = _convertDistance(
              timeDistance.unrestrictedDistanceM +
                  timeDistance.restrictedDistanceM);

          final totalTime = _convertDuration(
              timeDistance.unrestrictedTimeS + timeDistance.restrictedTimeS);
          // Add labels to the routes
          await routesMap.add(route, i == 0,
              label: '$totalDistance \n $totalTime');
        }
        // Select the first route as the main one
        await _mapController.centerOnRoutes(routes);
      }
    });
    haveRoutes = true;
  }

  @override
  Future<bool> selectRouteByScreenCoordinates(Point<num> pos) async {
    await _mapController.selectMapObjects(pos);

    final selectedRoutes = await _mapController.cursorSelectionRoutes();
    final selectedRoutesSize = await selectedRoutes.size();
    if (selectedRoutesSize <= 0) return false;

    final selectedRoute = await selectedRoutes.at(0);
    final prefs = _mapController.preferences();
    final routesMap = await prefs.routes();

    await routesMap.setMainRoute(selectedRoute);
    return true;
  }

  @override
  Future<void> removeRoutes() async {
    final prefs = _mapController.preferences();
    final routesMap = await prefs.routes();

    for (final route in shownRoutes) {
      routesMap.remove(route);
    }
    haveRoutes = false;
  }

  String _convertDistance(int meters) {
    if (meters >= 1000) {
      double kilometers = meters / 1000;
      return '${kilometers.toStringAsFixed(1)} km';
    } else {
      return '${meters.toString()} m';
    }
  }

  String _convertDuration(int seconds) {
    int hours = seconds ~/ 3600; // Number of whole hours
    int minutes = (seconds % 3600) ~/ 60; // Number of whole minutes

    String hoursText = (hours > 0) ? '$hours h ' : ''; // Hours text
    String minutesText = '$minutes min'; // Minutes text

    return hoursText + minutesText;
  }
}

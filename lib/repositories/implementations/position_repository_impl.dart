import 'dart:async';
import 'package:brasov_earth/repositories/models/implementations/coordinates_model_impl.dart';
import 'package:brasov_earth/repositories/models/interfaces/coordinates_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:gem_kit/api/gem_mapviewpreferences.dart';
import 'package:gem_kit/api/gem_types.dart';
import 'package:gem_kit/gem_kit_map_controller.dart';
import 'package:gem_kit/gem_kit_position.dart';

import 'package:brasov_earth/repositories/interfaces/position_repository.dart';

class PositionRepositoryImpl implements PositionRepository {
  final GemMapController _mapController;
  late PositionService _positionService;
  late PermissionStatus _locationPermissionStatus = PermissionStatus.denied;
  late bool _hasLiveDataSource = false;
  CoordinatesModel? _currentLocation;

  PositionRepositoryImpl({required GemMapController mapController})
      : _mapController = mapController,
        _currentLocation = null;

  @override
  Future<void> init() async {
    await PositionService.create(_mapController.mapId).then((service) {
      _positionService = service;
    });
  }

  @override
  Future<void> followPosition() async {
    if (kIsWeb) {
      _locationPermissionStatus = PermissionStatus.granted;
    } else {
      _locationPermissionStatus = await Permission.locationWhenInUse.request();
    }

    if (_locationPermissionStatus != PermissionStatus.granted) {
      return;
    }

    if (!_hasLiveDataSource) {
      await _positionService.removeDataSource();
      await _positionService.setLiveDataSource();
      _hasLiveDataSource = true;
    }

    if (_locationPermissionStatus == PermissionStatus.granted) {
      final animation = GemAnimation(type: EAnimation.AnimationLinear);
      await _mapController.startFollowingPosition(
        animation: animation,
        viewAngle: 0,
      );
    }

    await _positionService.addPositionListener((p0) {
      _currentLocation = CoordinatesModelImpl(p0.coordinates);
    });
  }

  @override
  CoordinatesModel get mapCenterCoordinates {
    final xy = XyType(
      x: _mapController.viewport.width ~/ 2,
      y: _mapController.viewport.height ~/ 2,
    );
    return CoordinatesModelImpl(_mapController.transformScreenToWgs(xy)!);
  }

  @override
  CoordinatesModel? get locationCoordinates => _currentLocation;

  @override
  Future<void> centerOnCoordinates(CoordinatesModel coordinates) async {
    final xy = XyType(
      x: _mapController.viewport.width ~/ 2,
      y: _mapController.viewport.height ~/ 2,
    );
    final gemCoordinates = coordinates as CoordinatesModelImpl;
    final animation = GemAnimation(type: EAnimation.AnimationLinear);
    await _mapController.centerOnCoordinates(
      gemCoordinates.gemCoordinates,
      xy: xy,
      viewAngle: 0,
      zoomLevel: -1,
      animation: animation,
    );
  }
}

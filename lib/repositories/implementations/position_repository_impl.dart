import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:gem_kit/api/gem_coordinates.dart';
import 'package:gem_kit/api/gem_mapviewpreferences.dart';
import 'package:gem_kit/api/gem_types.dart';
import 'package:gem_kit/gem_kit_map_controller.dart';
import 'package:gem_kit/gem_kit_position.dart';

import 'package:brasov_earth/repositories/interfaces/position_repository.dart';

class PositionRepositoryImpl implements PositionRepository {
  final GemMapController _mapController;
  late PermissionStatus _locationPermissionStatus = PermissionStatus.denied;
  late PositionService _positionService;
  late bool _hasLiveDataSource = false;

  PositionRepositoryImpl({required GemMapController mapController})
      : _mapController = mapController {
    PositionService.create(_mapController.mapId).then((service) {
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
      await _mapController.startFollowingPosition(animation: animation);
    }
  }

  @override
  Coordinates? screenSizeToCoordinates({required int x, required int y}) {
    return _mapController.transformScreenToWgs(XyType(
      x: x,
      y: y,
    ));
  }

  @override
  Future<void> centerOnCoordinates(Coordinates coordinates) async {
    await _mapController.centerOnCoordinates(coordinates);
  }
}

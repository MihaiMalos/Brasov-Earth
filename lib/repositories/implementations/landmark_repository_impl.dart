import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:brasov_earth/repositories/models/interfaces/landmark_info.dart';
import 'package:gem_kit/api/gem_mapviewpreferences.dart';
import 'package:gem_kit/api/gem_types.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:typed_data';

import 'package:brasov_earth/repositories/interfaces/landmark_repository.dart';
import 'package:brasov_earth/utility/image_utility.dart';
import 'package:gem_kit/api/gem_coordinates.dart';
import 'package:gem_kit/api/gem_landmark.dart';
import 'package:gem_kit/api/gem_searchservice.dart';
import 'package:gem_kit/gem_kit_basic.dart';
import 'package:gem_kit/gem_kit_map_controller.dart';

class LandmarkRepositoryImpl implements LandmarkRepository {
  final GemMapController _mapController;
  late SearchService _searchService;

  LandmarkRepositoryImpl({required GemMapController mapController})
      : _mapController = mapController {
    SearchService.create(_mapController.mapId).then((service) {
      _searchService = service;
    });
  }

  @override
  Future<List<Landmark>> searchByText(
    String text,
    Coordinates coordinates,
  ) async {
    var completer = Completer<List<Landmark>>();

    _searchService.search(text, coordinates, (err, results) async {
      if (err != GemError.success || results == null) {
        completer.complete([]);
        return;
      }
      final size = await results.size();
      List<Landmark> searchResults = [];

      for (int i = 0; i < size; i++) {
        final gemLmk = await results.at(i);

        searchResults.add(gemLmk);
      }

      if (!completer.isCompleted) completer.complete(searchResults);
    });

    final result = await completer.future;

    return result;
  }

  @override
  Future<LandmarkInfo?> selectLandmarkByScreenCoordinates(
      Point<num> position) async {
    await _mapController.selectMapObjects(position);

    final landmarks = await _mapController.cursorSelectionLandmarks();
    final landmarksSize = await landmarks.size();

    if (landmarksSize == 0) return null;

    _mapController.activateHighlight(landmarks);

    final lmk = await landmarks.at(0);
    final result = await _getLandmarkInfo(lmk);

    return result;
  }

  @override
  Future<void> deselectLandmark() async {
    await _mapController.deactivateAllHighlights();
  }

  Future<LandmarkInfo> _getLandmarkInfo(Landmark landmark) async {
    Uint8List? icon =
        await ImageUtility.decodeImageData(landmark.getImage(100, 100));
    String name = landmark.getName();
    Coordinates coordinates = landmark.getCoordinates();

    return LandmarkInfo(
      icon,
      name,
      coordinates,
    );
  }
}

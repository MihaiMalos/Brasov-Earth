import 'dart:async';
import 'dart:math';
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
  Future<Landmark?> selectLandmarkByScreenCoordinates(
      Point<num> position) async {
    await _mapController.selectMapObjects(position);

    final landmarks = await _mapController.cursorSelectionLandmarks();
    final landmarksSize = await landmarks.size();

    if (landmarksSize == 0) return null;

    _mapController.activateHighlight(landmarks);

    final result = await landmarks.at(0);
    return result;
  }

  @override
  Future<LandmarkInfo> getLandmarkInfo(Landmark landmark) async {
    Uint8List? icon =
        await ImageUtility.decodeImageData(landmark.getImage(100, 100));
    String name = landmark.getName();
    Coordinates coordinates = landmark.getCoordinates();
    List<LandmarkCategory> categories = landmark.getCategories();

    return LandmarkInfo(
      icon: icon,
      name: name,
      coordinates: coordinates,
      categories: categories,
    );
  }
}

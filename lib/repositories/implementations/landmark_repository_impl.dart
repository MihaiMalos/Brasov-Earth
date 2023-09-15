import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:brasov_earth/repositories/models/implementations/landmark_model_impl.dart';
import 'package:gem_kit/api/gem_landmark.dart';
import 'package:gem_kit/api/gem_routingservice.dart';
import 'package:gem_kit/api/gem_searchservice.dart';
import 'package:gem_kit/api/gem_types.dart';
import 'package:gem_kit/gem_kit_basic.dart';
import 'package:gem_kit/gem_kit_map_controller.dart';

import 'package:brasov_earth/repositories/models/interfaces/landmark_model.dart';
import 'package:brasov_earth/repositories/interfaces/landmark_repository.dart';
import 'package:brasov_earth/utility/image_utility.dart';

class LandmarkRepositoryImpl implements LandmarkRepository {
  final GemMapController _mapController;
  late SearchService _searchService;

  LandmarkRepositoryImpl({required GemMapController mapController})
      : _mapController = mapController;

  @override
  Future<void> init() async {
    await SearchService.create(_mapController.mapId).then((service) {
      _searchService = service;
    });
  }

  @override
  Future<List<LandmarkModel>> searchByText(String text) async {
    final completer = Completer<List<LandmarkModel>>();
    final coords = _mapController.transformScreenToWgs(XyType(
      x: _mapController.viewport.width ~/ 2,
      y: _mapController.viewport.height ~/ 2,
    ));
    _searchService.search(text, coords!, (err, results) async {
      if (err != GemError.success || results == null) {
        completer.complete([]);
        return;
      }
      final size = await results.size();
      List<LandmarkModel> searchResults = [];

      for (int i = 0; i < size; i++) {
        final gemLmk = await results.at(i);
        final modelLmk = await _getLandmarkModel(gemLmk);
        searchResults.add(modelLmk);
      }

      if (!completer.isCompleted) completer.complete(searchResults);
    });

    final result = await completer.future;

    return result;
  }

  @override
  Future<LandmarkModel?> selectLandmarkByScreenCoordinates(
      Point<num> position) async {
    await _mapController.selectMapObjects(position);

    final landmarks = await _mapController.cursorSelectionLandmarks();
    final landmarksSize = await landmarks.size();

    if (landmarksSize == 0) return null;

    _mapController.activateHighlight(landmarks);

    final lmk = await landmarks.at(0);
    final result = await _getLandmarkModel(lmk);

    return result;
  }

  @override
  Future<void> focusLandmark(LandmarkModel landmark) async {
    final gemLandmark = landmark as LandmarkModelImpl;
    final list = await LandmarkList.create(_mapController.mapId);
    await list.push_back(gemLandmark.landmark);
    await _mapController.activateHighlight(list);
  }

  @override
  Future<void> deselectLandmark() async {
    await _mapController.deactivateAllHighlights();
  }

  Future<LandmarkModel> _getLandmarkModel(Landmark landmark) async {
    Uint8List? icon =
        await ImageUtility.decodeImageData(landmark.getImage(100, 100));
    return LandmarkModelImpl(icon, landmark);
  }
}

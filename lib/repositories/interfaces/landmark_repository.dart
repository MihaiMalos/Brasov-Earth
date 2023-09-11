import 'dart:math';

import 'package:brasov_earth/repositories/models/interfaces/landmark_info.dart';
import 'package:gem_kit/api/gem_coordinates.dart';
import 'package:gem_kit/api/gem_landmark.dart';

abstract interface class LandmarkRepository {
  Future<List<Landmark>> searchByText(String text, Coordinates coordinates);
  Future<LandmarkInfo?> selectLandmarkByScreenCoordinates(Point<num> position);
  Future<void> deselectLandmark();
}

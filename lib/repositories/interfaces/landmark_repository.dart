import 'dart:math';
import 'package:brasov_earth/repositories/models/interfaces/landmark_model.dart';

abstract interface class LandmarkRepository {
  Future<void> init();
  Future<List<LandmarkModel>> searchByText(String text);
  Future<LandmarkModel?> selectLandmarkByScreenCoordinates(Point<num> position);
  Future<void> focusLandmark(LandmarkModel landmark);
  Future<void> deselectLandmark();
}

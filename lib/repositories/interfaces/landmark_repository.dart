import 'dart:math';
import 'dart:typed_data';

import 'package:gem_kit/api/gem_coordinates.dart';
import 'package:gem_kit/api/gem_landmark.dart';

abstract interface class LandmarkRepository {
  Future<List<Landmark>> searchByText(String text, Coordinates coordinates);
  Future<Landmark?> selectLandmarkByScreenCoordinates(Point<num> position);
  Future<LandmarkInfo> getLandmarkInfo(Landmark landmark);
}

class LandmarkInfo {
  final Uint8List? _icon;
  final String _name;
  final Coordinates _coordinates;
  final List<LandmarkCategory> _categories;

  LandmarkInfo(
      {Uint8List? icon,
      required String name,
      required Coordinates coordinates,
      required List<LandmarkCategory> categories})
      : _name = name,
        _categories = categories,
        _coordinates = coordinates,
        _icon = icon;

  Uint8List? get icon => _icon;
  String get name => _name;
  Coordinates get coordinates => _coordinates;
  List<LandmarkCategory> get categories => _categories;
}

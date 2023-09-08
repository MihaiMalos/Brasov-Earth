import 'dart:math';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:gem_kit/api/gem_coordinates.dart';
import 'package:gem_kit/api/gem_landmark.dart';

abstract interface class LandmarkRepository {
  Future<List<Landmark>> searchByText(String text, Coordinates coordinates);
  Future<Landmark?> selectLandmarkByScreenCoordinates(Point<num> position);
  Future<LandmarkInfo> getLandmarkInfo(Landmark landmark);
}

class LandmarkInfo extends Equatable {
  final Uint8List? _icon;
  final String _name;
  final Coordinates _coordinates;

  const LandmarkInfo({
    Uint8List? icon,
    required String name,
    required Coordinates coordinates,
  })  : _name = name,
        _coordinates = coordinates,
        _icon = icon;

  Uint8List? get icon => _icon;
  String get name => _name;
  Coordinates get coordinates => _coordinates;

  @override
  List<Object?> get props => [icon, name, coordinates];
}

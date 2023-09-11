import 'dart:typed_data';

import 'package:brasov_earth/repositories/models/implementations/landmark_info_impl.dart';
import 'package:gem_kit/api/gem_coordinates.dart';

abstract interface class LandmarkInfo {
  factory LandmarkInfo(
    Uint8List? icon,
    String name,
    Coordinates coordinates,
  ) =>
      LandmarkInfoImpl(icon, name, coordinates);

  Uint8List? get icon;
  String get name;
  Coordinates get coordinates;
}

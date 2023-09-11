import 'dart:typed_data';

import 'package:brasov_earth/repositories/models/interfaces/landmark_info.dart';
import 'package:equatable/equatable.dart';
import 'package:gem_kit/api/gem_coordinates.dart';

class LandmarkInfoImpl extends Equatable implements LandmarkInfo {
  final Uint8List? _icon;
  final String _name;
  final Coordinates _coordinates;

  const LandmarkInfoImpl(
    this._icon,
    this._name,
    this._coordinates,
  );

  @override
  Uint8List? get icon => _icon;
  @override
  String get name => _name;
  @override
  Coordinates get coordinates => _coordinates;

  @override
  List<Object?> get props => [icon, name, coordinates];
}

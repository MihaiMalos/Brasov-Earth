import 'dart:typed_data';

import 'package:brasov_earth/repositories/models/implementations/coordinates_model_impl.dart';
import 'package:brasov_earth/repositories/models/interfaces/coordinates_model.dart';
import 'package:brasov_earth/repositories/models/interfaces/landmark_model.dart';
import 'package:equatable/equatable.dart';
import 'package:gem_kit/api/gem_addressinfo.dart';
import 'package:gem_kit/api/gem_landmark.dart';

class LandmarkModelImpl extends Equatable implements LandmarkModel {
  final Landmark _landmark;
  final Uint8List? _icon;
  const LandmarkModelImpl(this._icon, this._landmark);

  @override
  Uint8List? get icon => _icon;
  @override
  String get name => _landmark.getName();
  @override
  CoordinatesModel get coordinates =>
      CoordinatesModelImpl(_landmark.getCoordinates());

  @override
  List<Object?> get props => [icon, name, coordinates, adress];

  Landmark get landmark => _landmark;

  @override
  String get adress {
    final landmarkAdress = _landmark.getAddress();
    final formattedAdress =
        '${landmarkAdress.getField(EAddressField.StreetName)} '
        '${landmarkAdress.getField(EAddressField.StreetNumber)}, '
        '${landmarkAdress.getField(EAddressField.City)}, '
        '${landmarkAdress.getField(EAddressField.Country)}';
    return formattedAdress;
  }

  @override
  double distanceFromCoordinates(CoordinatesModel coordinates) {
    return coordinates.distance(this.coordinates);
  }
}

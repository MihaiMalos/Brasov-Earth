import 'dart:typed_data';

abstract interface class InstructionModel {
  String get nextTurnDistance;
  String get eta;
  String get streetName;
  String get nextStreetName;
  Uint8List? get nextTurnImageData;
  String get remainingDistance;
  String get remainingDuration;
}

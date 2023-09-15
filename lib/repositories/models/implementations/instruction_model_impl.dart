import 'dart:async';
import 'dart:typed_data';
import 'package:brasov_earth/repositories/models/interfaces/instruction_model.dart';
import 'package:brasov_earth/utility/image_utility.dart';
import 'package:brasov_earth/utility/string_format_utility.dart';
import 'package:gem_kit/api/gem_navigationinstruction.dart';

class InstructionModelImpl implements InstructionModel {
  final String _nextTurnDistance;
  final String _eta;
  final String _streetName;
  final String _nextStreetName;
  final Uint8List? _nextTurnImageData;
  final String _remainingDistance;
  final String _remainingDuration;

  InstructionModelImpl(
      {required String nextTurnDistance,
      required String eta,
      required String streetName,
      required String nextStreetName,
      required Uint8List? nextTurnImageData,
      required String remainingDistance,
      required String remainingDuration})
      : _remainingDuration = remainingDuration,
        _remainingDistance = remainingDistance,
        _nextTurnImageData = nextTurnImageData,
        _nextStreetName = nextStreetName,
        _streetName = streetName,
        _eta = eta,
        _nextTurnDistance = nextTurnDistance;

  @override
  String get nextTurnDistance => _nextStreetName;
  @override
  String get eta => _eta;
  @override
  String get streetName => _streetName;
  @override
  String get nextStreetName => _nextStreetName;
  @override
  Uint8List? get nextTurnImageData => _nextTurnImageData;
  @override
  String get remainingDistance => _remainingDistance;
  @override
  String get remainingDuration => _remainingDuration;

  static Future<InstructionModelImpl> fromGemInstruction(
      NavigationInstruction ins) async {
    final timeDistance = ins.getTimeDistanceToNextTurn();
    final rawDistance =
        timeDistance.restrictedDistanceM + timeDistance.unrestrictedDistanceM;

    final formattedDistance = StringFormatUtility.convertDistance(rawDistance);

    final currentStreetName = ins.getCurrentStreetName();
    final nextStreetname = ins.getNextStreetName();

    final nextTurnDetails = ins.getNextTurnDetails();
    final imageData = nextTurnDetails.getAbstractGeometryImage(100, 100);
    final decodedImage = await ImageUtility.decodeImageData(imageData);

    final remainingTimeDistance = ins.getRemainingTravelTimeDistance();
    final rawRemainingTime = remainingTimeDistance.restrictedTimeS +
        remainingTimeDistance.unrestrictedTimeS;
    final rawRemainingDist = remainingTimeDistance.restrictedDistanceM +
        remainingTimeDistance.unrestrictedDistanceM;

    final formattedEta =
        StringFormatUtility.getCurrentTime(additionalSeconds: rawRemainingTime);
    final formattedRemainingDuration =
        StringFormatUtility.convertDuration(rawRemainingTime);
    final formattedRemainingDistance =
        StringFormatUtility.convertDistance(rawRemainingDist);

    return InstructionModelImpl(
      nextTurnDistance: formattedDistance,
      eta: formattedEta,
      nextTurnImageData: decodedImage,
      remainingDistance: formattedRemainingDistance,
      remainingDuration: formattedRemainingDuration,
      streetName: currentStreetName,
      nextStreetName: nextStreetname,
    );
  }
}

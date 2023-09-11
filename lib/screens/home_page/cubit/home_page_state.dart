import 'dart:math';

import 'package:brasov_earth/repositories/models/interfaces/landmark_info.dart';
import 'package:equatable/equatable.dart';

enum HomePageStates {
  landmarkSelected,
  noneSelected,
}

class HomePageState extends Equatable {
  final Point<num>? currentPosition;
  final LandmarkInfo? selectedLandmark;

  const HomePageState({
    this.currentPosition,
    this.selectedLandmark,
  });

  HomePageState copyWith({
    Point<num>? currentPosition,
    required LandmarkInfo? selectedLandmark,
  }) =>
      HomePageState(
        currentPosition: currentPosition ?? this.currentPosition,
        selectedLandmark: selectedLandmark,
      );

  @override
  List<Object?> get props => [currentPosition, selectedLandmark];
}

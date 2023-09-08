import 'dart:math';

import 'package:brasov_earth/repositories/interfaces/landmark_repository.dart';
import 'package:gem_kit/api/gem_landmark.dart';
import 'package:equatable/equatable.dart';

enum HomePageStates {
  initialState,
  landmarkPressed,
  emptySpacePressed,
}

class HomePageState extends Equatable {
  final Point<num>? currentPosition;
  final LandmarkInfo? selectedLandmarkInfo;
  final HomePageStates currentState;

  const HomePageState({
    this.currentPosition,
    this.selectedLandmarkInfo,
    this.currentState = HomePageStates.initialState,
  });

  HomePageState copyWith({
    Point<num>? currentPosition,
    LandmarkInfo? selectedLandmarkInfo,
    HomePageStates? currentState,
  }) =>
      HomePageState(
        currentPosition: currentPosition ?? this.currentPosition,
        selectedLandmarkInfo: selectedLandmarkInfo ?? this.selectedLandmarkInfo,
        currentState: currentState ?? this.currentState,
      );

  @override
  List<Object?> get props =>
      [currentPosition, selectedLandmarkInfo, currentState];
}

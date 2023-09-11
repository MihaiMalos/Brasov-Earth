import 'dart:math';

import 'package:brasov_earth/repositories/interfaces/landmark_repository.dart';
import 'package:equatable/equatable.dart';

enum HomePageStates {
  initialState,
  landmarkPressed,
  emptySpacePressed,
  followPositionActivated,
}

class HomePageState extends Equatable {
  final Point<num>? currentPosition;
  final LandmarkInfo? selectedLandmark;
  final HomePageStates currentState;

  const HomePageState({
    this.currentPosition,
    this.selectedLandmark,
    this.currentState = HomePageStates.initialState,
  });

  HomePageState copyWith({
    Point<num>? currentPosition,
    LandmarkInfo? selectedLandmark,
    HomePageStates? currentState,
  }) =>
      HomePageState(
        currentPosition: currentPosition ?? this.currentPosition,
        selectedLandmark: selectedLandmark ?? this.selectedLandmark,
        currentState: currentState ?? this.currentState,
      );

  @override
  List<Object?> get props => [currentPosition, selectedLandmark, currentState];
}

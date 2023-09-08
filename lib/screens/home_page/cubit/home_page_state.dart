import 'dart:math';

import 'package:gem_kit/api/gem_landmark.dart';
import 'package:equatable/equatable.dart';

enum HomePageStates {
  initialState,
  landmarkPressed,
}

class HomePageState extends Equatable {
  final Point<num>? currentPosition;
  final Landmark? selectedLandmark;
  final HomePageStates currentState;

  const HomePageState({
    this.currentPosition,
    this.selectedLandmark,
    this.currentState = HomePageStates.initialState,
  });

  HomePageState copyWith({
    Point<num>? currentPosition,
    Landmark? selectedLandmark,
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

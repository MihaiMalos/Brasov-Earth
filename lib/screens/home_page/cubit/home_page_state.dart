import 'dart:math';

import 'package:brasov_earth/repositories/models/interfaces/landmark_model.dart';
import 'package:equatable/equatable.dart';

class HomePageState extends Equatable {
  final LandmarkModel? selectedLandmark;

  const HomePageState({
    this.selectedLandmark,
  });

  HomePageState copyWith({
    Point<num>? currentPosition,
    required LandmarkModel? selectedLandmark,
  }) =>
      HomePageState(
        selectedLandmark: selectedLandmark,
      );

  @override
  List<Object?> get props => [selectedLandmark];
}

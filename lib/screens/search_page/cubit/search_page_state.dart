import 'package:brasov_earth/repositories/models/interfaces/landmark_model.dart';
import 'package:equatable/equatable.dart';

class SearchPageState extends Equatable {
  final List<LandmarkModel> searchedLandmarks;

  SearchPageState.init() : searchedLandmarks = [];

  const SearchPageState({
    required this.searchedLandmarks,
  });

  @override
  List<Object?> get props => [searchedLandmarks];
}

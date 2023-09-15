import 'package:bloc/bloc.dart';
import 'package:brasov_earth/repositories/injection_container.dart';
import 'package:brasov_earth/repositories/interfaces/landmark_repository.dart';
import 'package:brasov_earth/repositories/interfaces/position_repository.dart';
import 'package:brasov_earth/repositories/models/interfaces/coordinates_model.dart';
import 'package:brasov_earth/screens/search_page/cubit/search_page_state.dart';

class SearchPageCubit extends Cubit<SearchPageState> {
  LandmarkRepository? _landmarkRepository;
  PositionRepository? _positionRepository;
  SearchPageCubit() : super(SearchPageState.init());

  Future<void> setRepos() async {
    _landmarkRepository =
        InjectionContainer.repoInstance.get<LandmarkRepository>();
    _positionRepository =
        InjectionContainer.repoInstance.get<PositionRepository>();

    await _landmarkRepository!.init();
    await _positionRepository!.init();
  }

  Future<void> searchByText(String text) async {
    final searchOutput = await _landmarkRepository!.searchByText(text);
    emit(SearchPageState(searchedLandmarks: searchOutput));
  }

  CoordinatesModel get mapCenterCoordinates {
    return _positionRepository!.mapCenterCoordinates;
  }

  void resetPage() {
    emit(SearchPageState.init());
  }
}

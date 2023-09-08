import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:brasov_earth/injection_container.dart';
import 'package:brasov_earth/repositories/interfaces/landmark_repository.dart';
import 'package:brasov_earth/screens/home_page/cubit/home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  LandmarkRepository? landmarkRepository;

  HomePageCubit()
      : super(const HomePageState(
          currentPosition: null,
          selectedLandmark: null,
          currentState: HomePageStates.initialState,
        ));

  void setRepos() {
    landmarkRepository =
        InjectionContainer.repoInstance.get<LandmarkRepository>();
  }

  Future<void> pressOnMap(Point<num> pos) async {
    await _selectLandmarkByScreenCoords(pos);
  }

  Future<void> _selectLandmarkByScreenCoords(Point<num> pos) async {
    final landmark =
        await landmarkRepository!.selectLandmarkByScreenCoordinates(pos);
    if (landmark != null) {
      LandmarkInfo info = await landmarkRepository!.getLandmarkInfo(landmark);
      print(info.coordinates.longitude);
      emit(state.copyWith(
        selectedLandmark: landmark,
        currentState: HomePageStates.landmarkPressed,
      ));
    }
  }
}
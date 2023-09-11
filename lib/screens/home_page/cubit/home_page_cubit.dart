import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:brasov_earth/injection_container.dart';
import 'package:brasov_earth/repositories/interfaces/landmark_repository.dart';
import 'package:brasov_earth/repositories/interfaces/position_repository.dart';
import 'package:brasov_earth/screens/home_page/cubit/home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  LandmarkRepository? landmarkRepository;
  PositionRepository? positionRepository;

  HomePageCubit()
      : super(const HomePageState(
          currentPosition: null,
          selectedLandmark: null,
          currentState: HomePageStates.initialState,
        ));

  void setRepos() {
    landmarkRepository =
        InjectionContainer.repoInstance.get<LandmarkRepository>();
    positionRepository =
        InjectionContainer.repoInstance.get<PositionRepository>();
  }

  Future<void> pressOnMap(Point<num> pos) async {
    final landmarkInfo =
        await landmarkRepository!.selectLandmarkByScreenCoordinates(pos);
    if (landmarkInfo != null) {
      emit(state.copyWith(
        selectedLandmark: landmarkInfo,
        currentState: HomePageStates.landmarkPressed,
      ));
    } else {
      await landmarkRepository!.deselectLandmark();
      emit(state.copyWith(
        selectedLandmark: null,
        currentState: HomePageStates.emptySpacePressed,
      ));
    }
  }

  Future<void> followPosition() async {
    await positionRepository!.followPosition();
    emit(state.copyWith(
      selectedLandmark: null,
      currentState: HomePageStates.followPositionActivated,
    ));
  }
}

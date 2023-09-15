import 'dart:math';

import 'package:bloc/bloc.dart';

import 'package:brasov_earth/repositories/injection_container.dart';
import 'package:brasov_earth/repositories/interfaces/landmark_repository.dart';
import 'package:brasov_earth/repositories/interfaces/position_repository.dart';
import 'package:brasov_earth/repositories/interfaces/route_repository.dart';
import 'package:brasov_earth/repositories/models/interfaces/coordinates_model.dart';
import 'package:brasov_earth/repositories/models/interfaces/landmark_model.dart';
import 'package:brasov_earth/screens/home_page/cubit/home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  LandmarkRepository? _landmarkRepository;
  PositionRepository? _positionRepository;
  RouteRepository? _routeRepository;

  HomePageCubit()
      : super(const HomePageState(
          selectedLandmark: null,
        ));

  Future<void> setRepos() async {
    _landmarkRepository =
        InjectionContainer.repoInstance.get<LandmarkRepository>();
    _positionRepository =
        InjectionContainer.repoInstance.get<PositionRepository>();
    _routeRepository = InjectionContainer.repoInstance.get<RouteRepository>();

    await _landmarkRepository!.init();
    await _positionRepository!.init();
    await _routeRepository!.init();
  }

  Future<void> pressOnMap(Point<num> pos) async {
    final landmarkInfo =
        await _landmarkRepository!.selectLandmarkByScreenCoordinates(pos);
    if (landmarkInfo != null) {
      _positionRepository!.centerOnCoordinates(landmarkInfo.coordinates);
      emit(state.copyWith(
        selectedLandmark: landmarkInfo,
      ));
    } else {
      final routeChanged =
          await _routeRepository!.selectRouteByScreenCoordinates(pos);
      if (!routeChanged) await _routeRepository!.removeRoutes();
      await _routeRepository!.simulateRoute();
      await _landmarkRepository!.deselectLandmark();
      emit(state.copyWith(
        selectedLandmark: null,
      ));
    }
  }

  Future<void> followPosition() async {
    await _positionRepository!.followPosition();
    emit(state.copyWith(
      selectedLandmark: null,
    ));
  }

  Future<void> centerOnLandmark(LandmarkModel landmark) async {
    await _positionRepository!.centerOnCoordinates(landmark.coordinates);
    await _landmarkRepository!.focusLandmark(landmark);
    emit(state.copyWith(
      selectedLandmark: landmark,
    ));
  }

  CoordinatesModel? get currentLocation =>
      _positionRepository!.locationCoordinates;

  Future<void> calculateRouteToLandmark(LandmarkModel landmark) async {
    if (currentLocation == null) return;
    await _routeRepository!
        .calculateSingleRoute(landmark.coordinates, currentLocation!);
  }
}

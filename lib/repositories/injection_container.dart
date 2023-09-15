import 'package:brasov_earth/repositories/implementations/position_repository_impl.dart';
import 'package:brasov_earth/repositories/implementations/route_repository_impl.dart';
import 'package:brasov_earth/repositories/interfaces/landmark_repository.dart';
import 'package:brasov_earth/repositories/implementations/landmark_repository_impl.dart';
import 'package:brasov_earth/repositories/interfaces/position_repository.dart';
import 'package:brasov_earth/repositories/interfaces/route_repository.dart';
import 'package:gem_kit/gem_kit_map_controller.dart';
import 'package:get_it/get_it.dart';

class InjectionContainer {
  static final repoInstance = GetIt.instance;

  static void init(GemMapController mapController) {
    repoInstance.registerLazySingleton<LandmarkRepository>(
        () => LandmarkRepositoryImpl(mapController: mapController));
    repoInstance.registerLazySingleton<PositionRepository>(
        () => PositionRepositoryImpl(mapController: mapController));
    repoInstance.registerLazySingleton<RouteRepository>(
        () => RouteRepositoryImpl(mapController: mapController));
  }
}

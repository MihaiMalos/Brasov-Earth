abstract interface class CoordinatesModel {
  double get latitude;
  double get longitude;
  double get altitude;

  double distance(CoordinatesModel coordinates);
}

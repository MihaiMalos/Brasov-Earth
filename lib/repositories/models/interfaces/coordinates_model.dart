abstract interface class CoordinatesModel {

  CoordinatesModel createFromLatLong(double latitude, double longitude);

  double get latitude;
  double get longitude;
  double get altitude;

  double distance(CoordinatesModel coordinates);
}

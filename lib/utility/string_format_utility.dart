import 'package:intl/intl.dart';

class StringFormatUtility {
  static String convertDistance(int meters) {
    if (meters >= 1000) {
      double kilometers = meters / 1000;
      return '${kilometers.toStringAsFixed(1)} km';
    } else {
      return '${meters.toString()} m';
    }
  }

  static String convertDuration(int seconds) {
    int hours = seconds ~/ 3600; // Number of whole hours
    int minutes = (seconds % 3600) ~/ 60; // Number of whole minutes

    String hoursText = (hours > 0) ? '$hours h ' : ''; // Hours text
    String minutesText = '$minutes min'; // Minutes text

    return hoursText + minutesText;
  }

  static String getCurrentTime(
      {int additionalHours = 0,
      int additionalMinutes = 0,
      int additionalSeconds = 0}) {
    var now = DateTime.now();
    var updatedTime = now.add(Duration(
        hours: additionalHours,
        minutes: additionalMinutes,
        seconds: additionalSeconds));
    var formatter = DateFormat('HH:mm');
    return formatter.format(updatedTime);
  }
}

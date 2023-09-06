import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';

class FileUtility {
  static Future<Map<String, dynamic>> loadFromJson(String path) async {
    final String response = await rootBundle.loadString(path);
    final data = await json.decode(response);
    return data;
  }

  static Future<String> getApiKey() async {
    Map<String, dynamic> data;
    if (kIsWeb) {
      data = await loadFromJson("settings.json");
    } else {
      data = await loadFromJson("assets/settings.json");
    }
    return data["api_key"];
  }
}

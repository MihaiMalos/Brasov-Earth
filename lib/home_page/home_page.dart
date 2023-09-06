import 'package:flutter/material.dart';
import 'package:gem_kit/api/gem_sdksettings.dart';
import 'package:gem_kit/gem_kit_map_controller.dart';
import 'package:gem_kit/widget/gem_kit_map.dart';
import 'package:hello_map/utility/file_utility.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  HomePage({super.key});

  late GemMapController mapController;

  late SdkSettings _sdkSettings;

  Future<void> onMapCreated(GemMapController controller) async {
    final apiKey = await FileUtility.getApiKey();
    mapController = controller;
    SdkSettings.create(mapController.mapId).then((value) {
      _sdkSettings = value;
      _sdkSettings.setAppAuthorization(apiKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            GemMap(
              onMapCreated: onMapCreated,
            ),
          ],
        ),
      ),
    );
  }
}

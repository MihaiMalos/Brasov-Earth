// ignore_for_file: use_build_context_synchronously
import 'package:brasov_earth/injection_container.dart';
import 'package:brasov_earth/screens/home_page/cubit/home_page_cubit.dart';
import 'package:brasov_earth/screens/home_page/cubit/home_page_state.dart';
import 'package:brasov_earth/screens/home_page/view/widgets/landmark_panel.dart';
import 'package:brasov_earth/utility/file_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gem_kit/api/gem_sdksettings.dart';
import 'package:gem_kit/gem_kit_map_controller.dart';
import 'package:gem_kit/widget/gem_kit_map.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> onMapCreated(GemMapController controller) async {
    final apiKey = await FileUtility.getApiKey();
    InjectionContainer.init(controller);
    SdkSettings.setAppAuthorization(apiKey);

    context.read<HomePageCubit>().setRepos();

    controller.registerTouchCallback((pos) async {
      await context.read<HomePageCubit>().pressOnMap(pos);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: IconButton(
        icon: const Icon(Icons.location_searching),
        onPressed: () async {
          await context.read<HomePageCubit>().followPosition();
        },
      ),
      body: Center(
        child: Stack(
          children: [
            GemMap(
              onMapCreated: onMapCreated,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).viewPadding.top + 10,
                      horizontal: 15),
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            offset: const Offset(0, 1),
                            blurRadius: 2,
                          )
                        ]),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () =>
                            Navigator.of(context).pushNamed('/search'),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.search_rounded,
                                color: Colors.grey,
                              ),
                              Text(
                                "Search here",
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.3),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            BlocBuilder<HomePageCubit, HomePageState>(
              builder: (context, state) {
                if (state.currentState == HomePageStates.landmarkPressed) {
                  return LandmarkPanel(landmarkInfo: state.selectedLandmark!);
                } else {
                  return Container();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

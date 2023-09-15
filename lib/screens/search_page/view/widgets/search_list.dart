import 'package:brasov_earth/repositories/models/interfaces/coordinates_model.dart';
import 'package:brasov_earth/repositories/models/interfaces/landmark_model.dart';
import 'package:brasov_earth/screens/home_page/cubit/home_page_cubit.dart';
import 'package:brasov_earth/screens/search_page/cubit/search_page_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchList extends StatelessWidget {
  final List<LandmarkModel> landmarkList;
  final int maximumElementsCount;
  final CoordinatesModel currentCoordinates;

  const SearchList({
    super.key,
    required this.landmarkList,
    required this.maximumElementsCount,
    required this.currentCoordinates,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(0),
        itemCount: maximumElementsCount,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () async {
              Navigator.of(context).pop();
              context.read<SearchPageCubit>().resetPage();
              await context
                  .read<HomePageCubit>()
                  .centerOnLandmark(landmarkList.elementAt(index));
            },
            child: SizedBox(
              height: 88,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.memory(
                          landmarkList.elementAt(index).icon!,
                          gaplessPlayback: true,
                          scale: 3,
                        ),
                        Text(
                          LandmarkModel.formatDistance(
                            landmarkList
                                .elementAt(index)
                                .distanceFromCoordinates(currentCoordinates),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width - 100,
                        ),
                        child: Text(landmarkList.elementAt(index).name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                            )),
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width - 100,
                        ),
                        child: Text(landmarkList.elementAt(index).adress,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.7),
                              fontSize: 18,
                            )),
                      ),
                      const SizedBox(
                        width: 300,
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}

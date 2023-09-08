import 'package:brasov_earth/repositories/interfaces/landmark_repository.dart';
import 'package:flutter/material.dart';

class LandmarkPanel extends StatelessWidget {
  final LandmarkInfo landmarkInfo;
  const LandmarkPanel({super.key, required this.landmarkInfo});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: 150,
          decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(blurRadius: 10, offset: Offset(0, 3)),
              ],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              )),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.memory(
                      landmarkInfo.icon!,
                      gaplessPlayback: true,
                      scale: 1.5,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(landmarkInfo.name,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 25)),
                        Text(
                          '${landmarkInfo.coordinates.latitude}, ${landmarkInfo.coordinates.longitude}',
                          style: const TextStyle(
                              color: Colors.black, fontSize: 15),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: const MaterialStatePropertyAll(
                          Color.fromARGB(255, 11, 148, 72)),
                      iconColor: const MaterialStatePropertyAll(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.directions),
                    label: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Directions',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor:
                          const MaterialStatePropertyAll(Colors.white),
                      iconColor: const MaterialStatePropertyAll(
                          Color.fromARGB(255, 11, 148, 72)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.bookmark_border),
                    label: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Save',
                          style: TextStyle(
                              color: Color.fromARGB(255, 11, 148, 72),
                              fontSize: 14,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smartx_flutter_app/extension/context_extension.dart';
import 'package:smartx_flutter_app/models/walk_model.dart';
import 'package:smartx_flutter_app/ui/map-walk/map_walk_screen.dart';
import 'package:smartx_flutter_app/ui/map-walk/stop_walk_screen.dart';
import 'package:smartx_flutter_app/util/constants.dart';

import '../../map-walk/map_walk_controller.dart';

class LocationScreen extends StatefulWidget {
  static const String key_title = '/location_screen_title';

  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late double width, height;
  final controller = Get.put(MapWalkController());
  @override
  Widget build(BuildContext context) {
    final size = context.screenSize;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        GetX<MapWalkController>(
          builder: (DisposableInterface con) => Expanded(
            child: ListView.builder(
                itemCount: controller.userWalks.length,
                itemBuilder: (BuildContext context, index) {
                  return walkWidget(controller.userWalks[index]);
                }),
          ),
        )
      ],
    );
  }

  Widget walkWidget(WalkModel model) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
        width: width,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.red),
            color: Constants.colorOnBackground,
            borderRadius: BorderRadius.circular(10)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            ),
            height: 150,
            width: width,
            child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                child: googleMap(model)),
          ),
          // ClipRRect(
          //   borderRadius: const BorderRadius.only(
          //       topLeft: Radius.circular(10),
          //       topRight: Radius.circular(10)),
          //   child: Image.asset(
          //     'assets/location_view.png',
          //     height: 130,
          //     width: width,
          //     fit: BoxFit.cover,
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.title,
                  style: const TextStyle(
                    fontFamily: Constants.workSansMedium,
                  ),
                ),
                Row(
                  children: [
                    Text(model.distance.toStringAsFixed(0),
                        style: const TextStyle(
                            fontFamily: Constants.workSansMedium,
                            color: Constants.colorOnSurface)),
                    const SizedBox(width: 10),
                    const DottedLineContainer(),
                    const SizedBox(width: 10),
                    Text(model.duration.toString(),
                        style: const TextStyle(
                            fontFamily: Constants.workSansMedium,
                            color: Constants.colorOnSurface)),
                  ],
                ),
                if (model.dogs != null) ...[
                  for (var e in model.dogs!)
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Constants.colorSecondary)),
                      child: CircleAvatar(
                        radius: 15,
                        backgroundImage: NetworkImage(
                          e.imagePath!,
                        ),
                      ),
                    )
                ]
              ],
            ),
          )
        ]),
      ),
    );
  }

  Widget googleMap(WalkModel model) {
    return GoogleMap(
      initialCameraPosition:   CameraPosition(
          zoom: 25, target: model.paths.first),
      onMapCreated: (GoogleMapController controller) {
        print('changes');
        // _controller = controller;
        // _setMyLocation();
      },
      // myLocationEnabled: true,
      // markers: {
      //    Marker(markerId: const MarkerId("1"),
      //   position: model.paths.first,
      //      icon: BitmapDescriptor.defaultMarkerWithHue(12)
      //   )
      // },
      polylines: {
        Polyline(
          polylineId: const PolylineId('path'),
          color: Constants.buttonColor,
          points: model.paths,
        ),
      },
    );
  }
}

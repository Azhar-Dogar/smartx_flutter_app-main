import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smartx_flutter_app/models/walk_model.dart';

import '../util/constants.dart';

class GoogleMapWidget extends StatelessWidget {
   GoogleMapWidget({super.key,required this.model});
WalkModel model;
  @override
  Widget build(BuildContext context) {
    return  GoogleMap(
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

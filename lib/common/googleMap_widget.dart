import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smartx_flutter_app/models/walk_model.dart';

import '../util/constants.dart';

class GoogleMapWidget extends StatelessWidget {
  const GoogleMapWidget({super.key, required this.model});

  final WalkModel model;

  @override
  Widget build(BuildContext context) {
    if (model.paths.isEmpty) {
      return SizedBox();
    }
    return GoogleMap(
      myLocationButtonEnabled: false,
      initialCameraPosition:
          CameraPosition(zoom: 12, target: model.paths.first),
      zoomControlsEnabled: false,
      onMapCreated: (GoogleMapController controller) {

      },
      polylines: {
        Polyline(
            polylineId: const PolylineId('path'),
            color: Colors.blue,
            points: model.paths,
            width: 5),
      },
    );
  }
}

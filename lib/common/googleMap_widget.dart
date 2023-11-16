import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smartx_flutter_app/models/walk_model.dart';

import '../util/constants.dart';

class GoogleMapWidget extends StatefulWidget {
  const GoogleMapWidget({super.key, required this.model});

  final WalkModel model;

  @override
  State<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if (widget.model.paths.isEmpty) {
      return  const SizedBox();
    }
    return GoogleMap(
      myLocationButtonEnabled: false,
      initialCameraPosition:
          CameraPosition(zoom: 15, target: widget.model.paths.first),

      onMapCreated: (GoogleMapController controller) {

      },
      polylines: {
        Polyline(
            polylineId: const PolylineId('path'),
            color: Colors.blue,
            points: widget.model.paths,
            width: 5,
          ),
        },

    );
  }

}

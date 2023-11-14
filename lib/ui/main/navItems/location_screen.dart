import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartx_flutter_app/common/googleMap_widget.dart';
import 'package:smartx_flutter_app/extension/context_extension.dart';
import 'package:smartx_flutter_app/models/walk_model.dart';
import 'package:smartx_flutter_app/ui/map-walk/stop_walk_screen.dart';
import 'package:smartx_flutter_app/util/constants.dart';

import '../../../common/walk_widget.dart';
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
    print(FirebaseAuth.instance.currentUser!.uid);
    final size = context.screenSize;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Obx(() {
      return Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: (controller.userWalks.isEmpty)
                ? const Center(
                    child: Text("No walk to show"),
                  )
                : ListView.builder(
                    itemCount: controller.userWalks.length,
                    itemBuilder: (BuildContext context, index) {
                      return WalkWidget(model: controller.userWalks[index]);
                    }),
          ),
        ],
      );
    });
  }
}

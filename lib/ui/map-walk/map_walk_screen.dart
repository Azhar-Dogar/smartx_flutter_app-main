import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartx_flutter_app/extension/context_extension.dart';
import 'package:smartx_flutter_app/ui/map-walk/map_walk_controller.dart';
import 'package:smartx_flutter_app/ui/map-walk/stop_walk_screen.dart';
import 'package:smartx_flutter_app/util/constants.dart';

class MapWalkScreen extends StatelessWidget {
  static const String route = '/map_walk_screen_route';
  static const String key_title = '/map_walk_screen_title';
  const MapWalkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = context.screenSize;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Constants.colorSecondary,
        // titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: InkWell(
          onTap: () => Get.back(),
          child: const Row(
            children: [
              Icon(
                Icons.arrow_back,
                color: Constants.colorOnBackground,
              ),
              Text(
                'Back',
                style: TextStyle(
                    fontFamily: Constants.workSansRegular,
                    color: Constants.colorOnBackground,
                    fontSize: 16),
              ),
            ],
          ),
        ),
      ),
     
     
     
     
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: GetX<MapWalkController>(
                builder: (controller) {
                  if (controller.isStart.value) {
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          margin: const EdgeInsets.only(top: 40),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.7),
                                  offset: const Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 3.0,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(10),
                              color: Constants.colorOnBackground),
                          child: const Column(
                            children: [
                              Text(
                                '300m',
                                style: TextStyle(
                                    fontFamily: Constants.workSansBold,
                                    fontSize: 28),
                              ),
                              Text(
                                'Distance Covered',
                                style: TextStyle(
                                  fontFamily: Constants.workSansLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.7),
                                  offset: const Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 3.0,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(10),
                              color: Constants.colorOnBackground),
                          child: const Column(
                            children: [
                              Text(
                                '00:02:03',
                                style: TextStyle(
                                    fontFamily: Constants.workSansBold,
                                    fontSize: 28),
                              ),
                              Text(
                                'Hrs    Min    Sec',
                                style: TextStyle(
                                  fontFamily: Constants.workSansLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                                alignment: Alignment.center,
                                height: 40,
                                margin: EdgeInsets.only(
                                    bottom: 50,
                                    right: 20,
                                    left: size.width * 0.2),
                                width: 40,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Constants.colorOnSurface),
                                child: const Icon(Icons.pause)),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: 110,
                                  margin: const EdgeInsets.only(bottom: 50),
                                  width: 110,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Constants.colorOnSurface
                                          .withOpacity(0.4)),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(StopWalkScreen.route);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 70,
                                    margin: const EdgeInsets.only(bottom: 50),
                                    width: 70,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Constants.colorSecondary),
                                    child: const Text('Stop',
                                        style: TextStyle(
                                            color:
                                                Constants.colorOnBackground)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    );
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => controller.isStart(true),
                        child: Container(
                          alignment: Alignment.center,
                          height: 80,
                          margin: const EdgeInsets.only(bottom: 50),
                          width: 80,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Constants.colorOnSurface),
                          child: const Text('Start',
                              style: TextStyle(
                                  color: Constants.colorOnBackground)),
                        ),
                      ),
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

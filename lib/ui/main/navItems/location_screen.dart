import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartx_flutter_app/extension/context_extension.dart';
import 'package:smartx_flutter_app/ui/map-walk/map_walk_screen.dart';
import 'package:smartx_flutter_app/ui/map-walk/stop_walk_screen.dart';
import 'package:smartx_flutter_app/util/constants.dart';

class LocationScreen extends StatelessWidget {
  static const String key_title = '/location_screen_title';

  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = context.screenSize;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        GestureDetector(
          child: Container(
            margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
            width: size.width,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red),
                color: Constants.colorOnBackground,
                borderRadius: BorderRadius.circular(10)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                child: Image.asset(
                  'assets/location_view.png',
                  height: 130,
                  width: size.width,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pawsome Pathways: A Scenic Stroll with Furry Friends',
                      style: TextStyle(
                        fontFamily: Constants.workSansMedium,
                      ),
                    ),
                    const Row(
                      children: [
                        Text('450m',
                            style: TextStyle(
                                fontFamily: Constants.workSansMedium,
                                color: Constants.colorOnSurface)),
                        SizedBox(width: 10),
                                     DottedLineContainer(),

                        SizedBox(width: 10),
                        Text('5m',
                            style: TextStyle(
                                fontFamily: Constants.workSansMedium,
                                color: Constants.colorOnSurface)),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Constants.colorSecondary)),
                      child: Image.asset('assets/7.png',
                          height: 30, fit: BoxFit.contain),
                    )
                  ],
                ),
              )
            ]),
          ),
        )
      ],
    );
  }
}

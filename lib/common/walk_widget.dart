import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/walk_model.dart';
import '../ui/map-walk/stop_walk_screen.dart';
import '../util/constants.dart';
import 'googleMap_widget.dart';

class WalkWidget extends StatelessWidget {
  const WalkWidget({Key? key, required this.model}) : super(key: key);

  final WalkModel model;

  @override
  Widget build(BuildContext context) {
    var width = context.width;
    return GestureDetector(
      onTap: () {
        Get.to(() => StopWalkScreen(
              walk: model,
            ));
      },
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
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
              ),
              height: 150,
              width: width,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                child: GoogleMapWidget(
                  model: model,
                ),
              ),
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
            child: Row(
              children: [
                Expanded(
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
                      Row(children: [
                        if (model.dogs != null) ...[
                          for (var e in model.dogs!)
                            Container(
                              margin: const EdgeInsets.only(top: 10, right: 5),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Constants.colorSecondary)),
                              child: CircleAvatar(
                                radius: 15,
                                backgroundImage: NetworkImage(
                                  e.imagePath!,
                                ),
                              ),
                            )
                        ]
                      ])
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (ctx) {
                      return Scaffold(
                        appBar: AppBar(),
                        body: GoogleMapWidget(
                          model: model,
                        ),
                      );
                    }));
                  },
                  icon: Icon(
                    Icons.fullscreen,
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}

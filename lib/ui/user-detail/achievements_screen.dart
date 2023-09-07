import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartx_flutter_app/models/achievement_model.dart';
import 'package:smartx_flutter_app/models/walk_model.dart';
import 'package:smartx_flutter_app/ui/map-walk/map_walk_controller.dart';
import 'package:smartx_flutter_app/util/constants.dart';

class AchievementScreen extends StatefulWidget {
  const AchievementScreen({super.key});

  @override
  State<AchievementScreen> createState() => _AchievementScreenState();
}

class _AchievementScreenState extends State<AchievementScreen> {
  final controller = Get.put(MapWalkController());
  late double width, height;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        StreamBuilder(
            stream: controller.stream,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                List<WalkModel> streakList = [];
                DateTime currentDate = DateTime.now().add(Duration(days: 1));
                DateTime weekStart =
                    currentDate.subtract(const Duration(days: 7));
                final walks = snapshot.data!.docs
                    .map((e) =>
                        WalkModel.fromJson(e.data() as Map<String, dynamic>))
                    .toList();
                for (var i = 0; i < 7; i++) {
                  print( weekStart.add(Duration(days: i)).day);
                  print("day");
                  WalkModel? foundModel = walks.firstWhere(
                      (model) =>
                          model.dateTime.day ==
                          weekStart.add(Duration(days: i)).day,
                      orElse: () => null);
                  // for (var element in walks) {
                  //   if(weekStart.add(Duration(days: i)).day == element.dateTime.day){
                  //     print("weekday");
                  //     print(weekStart.add(Duration(days: i)).day);
                  //     print("element day");
                  //     print(element.dateTime.day);
                  if (foundModel != null) {
                    streakList.add(foundModel);
                    //   }
                  }
                }
                print(streakList.length);
                print("streaks");
                if (streakList.length >= 7) {
                  print("object");
                  return item();
                } else {
                  // return Expanded(
                  //   child: GridView.builder(
                  //       gridDelegate:
                  //           const SliverGridDelegateWithMaxCrossAxisExtent(
                  //               maxCrossAxisExtent: 200,
                  //               childAspectRatio: 4 / 2,
                  //               crossAxisSpacing: 10,
                  //               mainAxisSpacing: 10),
                  //       itemCount: walks.length,
                  //       itemBuilder: (BuildContext ctx, index) {
                  //         return Text(walks[index].title);
                  //       }),
                  // );
                }
              }
              return SizedBox();
            }),
      ],
    );
  }

  Widget item() {
    return Container(
      // width: width * 0.5,
      height: height * 0.11,
      decoration: BoxDecoration(
          color: Constants.colorSecondaryVariant,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(color: Constants.redShadow, offset: Offset(4, 4))
          ],
          border: Border.all(color: Constants.redBorder)),
      child: Center(
          child: Text(
        "1 week streak",
        style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Constants.redBorder),
      )),
    );
  }
}

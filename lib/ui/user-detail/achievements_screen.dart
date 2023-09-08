import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
                // List<WalkModel> streakList = [];
                DateTime currentDate = DateTime.now();
                List<String> badges = [];
                final walks = snapshot.data!.docs
                    .map((e) =>
                        WalkModel.fromJson(e.data() as Map<String, dynamic>))
                    .toList();
                double totalDistance = 0.0;
                badges.clear();
                for(var e in walks){
                  if(e.dateTime.day == DateTime.now().day){
                    if(e.dateTime.hour<11 && e.dateTime.hour > 6){
                      var f = DateFormat.jm().format(e.dateTime);
                      if(f.contains("PM")){
                        badges.add("Night Owl");
                      }else{
                        badges.add("Early Bird");
                      }
                    }
                  }
                  totalDistance = totalDistance + e.distance;
                }
                if(totalDistance*100 >=10000){
                  badges.add("10k walked");
                }
                List<WalkModel> streakList = checkWeekStreak(walks,30);
                if (streakList.length >= 30) {
                  badges.add("1 month streak");
                } else {
                  streakList = checkWeekStreak(walks,7);
                  if(streakList.length>=7){
                    badges.add("1 week streak");
                  }
                  for (var element in controller.badges) {
                    badges.add(element);
                  }
                  return Expanded(
                    child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 125,
                                childAspectRatio: 3 / 2,
                                crossAxisSpacing: 0,
                                mainAxisSpacing: 15),
                        itemCount: badges.length,
                        itemBuilder: (BuildContext ctx, index) {
                          return item(badges[index]);
                        }),
                  );
                }
              }
              return SizedBox();
            }),
      ],
    );
  }

  Widget item(String text) {
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
        text,
        style:const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Constants.redBorder),
      )),
    );
  }
  List<WalkModel> checkWeekStreak(List walks,int days){
    List<WalkModel> streakList = [];
    DateTime currentDate = DateTime.now().add(Duration(days: 15));
    for (var i = 0; i <= days; i++) {
      WalkModel? foundModel = walks.firstWhere(
              (model) =>
          model.dateTime.day ==
              currentDate.subtract(Duration(days: i)).day,orElse:()=> null);
      if(foundModel !=null){
        streakList.add(foundModel);}
  }
  return streakList;}
}

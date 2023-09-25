import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smartx_flutter_app/models/achievement_model.dart';
import 'package:smartx_flutter_app/models/walk_model.dart';
import 'package:smartx_flutter_app/ui/main/notifications/notification_screen.dart';
import 'package:smartx_flutter_app/ui/map-walk/map_walk_controller.dart';
import 'package:smartx_flutter_app/util/constants.dart';

class AchievementScreen extends StatefulWidget {
    AchievementScreen({super.key,required this.userId});
   String userId;
  @override
  State<AchievementScreen> createState() => _AchievementScreenState();
}

class _AchievementScreenState extends State<AchievementScreen> {
  late double width, height;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MapWalkController(uid: widget.userId));
    controller.getAchievement(uid:widget.userId);
    // controller.achievements = <AchievementModel>[].obs;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return GetX<MapWalkController>(
      builder: (DisposableInterface con) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          if(controller.achievements.isEmpty)...[
            const Expanded(
              child: Center(
                child: Text("No Achievement Yet",style:TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
              ),
            ),
          ]else...[
          Expanded(
            child: GridView.builder(
                gridDelegate:
                const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 125,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 15),
                itemCount: controller.achievements.length,
                itemBuilder: (BuildContext ctx, index) {
                  return item(controller.achievements[index].title);
                }),
          )]
          // StreamBuilder(
          //     stream: controller.stream,
          //     builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          //       if (snapshot.hasData) {
          //         // List<WalkModel> streakList = [];
          //         DateTime currentDate = DateTime.now();
          //         List<String> badges = [];
          //         final achievements = snapshot.data!.docs
          //             .map((e) =>
          //                 AchievementModel.fromJson(e.data() as Map<String, dynamic>))
          //             .toList();
          //         double totalDistance = 0.0;
          //         badges.clear();
          //         // for(var e in walks){
          //         //   if(e.dateTime.day == DateTime.now().day){
          //         //     if(e.dateTime.hour<11 && e.dateTime.hour > 6){
          //         //       var f = DateFormat.jm().format(e.dateTime);
          //         //       if(f.contains("PM")){
          //         //         badges.add("Night Owl");
          //         //       }else{
          //         //         badges.add("Early Bird");
          //         //       }
          //         //     }
          //         //   }
          //         //   totalDistance = totalDistance + e.distance;
          //         // }
          //         if(totalDistance*100 >=10000){
          //           badges.add("10k walked");
          //         }
          //         // List<WalkModel> streakList = checkWeekStreak(walks,30);
          //         if (achievements.length >=1) {
          //         //   badges.add("1 month streak");
          //         // } else {
          //         //   streakList = checkWeekStreak(walks,7);
          //         //   if(streakList.length>=7){
          //         //     badges.add("1 week streak");
          //         //   }
          //           // for (var element in controller.badges) {
          //           //   badges.add(element);
          //           // }
          //           return Expanded(
          //             child: GridView.builder(
          //                 gridDelegate:
          //                     const SliverGridDelegateWithMaxCrossAxisExtent(
          //                         maxCrossAxisExtent: 125,
          //                         childAspectRatio: 3 / 2,
          //                         crossAxisSpacing: 0,
          //                         mainAxisSpacing: 15),
          //                 itemCount: achievements.length,
          //                 itemBuilder: (BuildContext ctx, index) {
          //                   return item(achievements[index].title);
          //                 }),
          //           );
          //         }
          //       }
          //       return SizedBox();
          //     }),
        ],
      );}
    );
  }

  Widget item(String text) {
    String imagePath = "";
    if(text == "1 week streak"){
    imagePath = "assets/1_week.png";
    }else if(text == "Night Owl"){
      imagePath = "assets/night_owl.png";
    }else if(text == "Early Bird"){
      imagePath = "assets/early_bird.png";
    }else if(text == "Rainy Walk"){
      imagePath = "assets/badges/rainy_walk.png";
    }else if(text == "New Bie"){
      imagePath = "assets/new_bie.png";
    }else if(text == "First Walk"){
      imagePath = "assets/first_walk.png";
    }
    return (imagePath != "")?Image(image: AssetImage(imagePath))
      :Container(
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
    DateTime currentDate = DateTime.now().add(const Duration(days: 15));
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

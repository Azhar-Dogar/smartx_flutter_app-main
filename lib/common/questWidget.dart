import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:smartx_flutter_app/extension/context_extension.dart';
import 'package:smartx_flutter_app/models/achievement_model.dart';
import 'package:smartx_flutter_app/models/quest_model.dart';

import '../ui/map-walk/map_walk_controller.dart';
import '../util/constants.dart';
import 'app_button.dart';

class QuestWidget extends StatelessWidget {
  QuestWidget({super.key, required this.model});
  QuestModel model;
  @override
  Widget build(BuildContext context) {
    final mapWalkController = Get.put(MapWalkController());
    late Size size;
    size = context.screenSize;
    bool isComplete = false;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("user")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("achievements")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            final achievements = snapshot.data!.docs
                .map((e) =>
                    AchievementModel.fromJson(e.data() as Map<String, dynamic>))
                .toList();
            var e = achievements.where((p0) => p0.title==model.title).toList();
            if(e.isNotEmpty){
              isComplete = true;
            }
            print("length");
            print(achievements.length);
            return Container(
              height: 250,
              width: size.width - 50,
              decoration: BoxDecoration(
                  color: Constants.colorOnBackground,
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image(
                            image: NetworkImage(model.groupImage),
                            height: 40,
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        model.title,
                        style: const TextStyle(
                            fontFamily: Constants.workSansBold,
                            fontSize: 16,
                            color: Constants.colorSecondary),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    model.description,
                    style: const TextStyle(
                        fontFamily: Constants.workSansRegular,
                        color: Constants.colorSecondary),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Image.asset(
                        'assets/time.png',
                        width: 20,
                        // color: Constants.colorTextField,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "${model.duration} days",
                        style: const TextStyle(
                          fontFamily: Constants.workSansLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: 55,
                          width: size.width / 1.6,
                          child: AppButton(
                              onClick: () {
                                if (!isComplete) {
                                  mapWalkController.addQuestStreak(model);
                                }
                              },
                              text:
                                  isComplete ? "Completed" : 'Mark as complete',
                              fontFamily: Constants.workSansRegular,
                              textColor: Constants.colorTextWhite,
                              borderRadius: 10.0,
                              fontSize: 16,
                              color: Constants.buttonColor)),
                    ],
                  ),
                ],
              ),
            );
          }
          return SizedBox();
        });
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartx_flutter_app/models/achievement_model.dart';

import '../../../util/constants.dart';

class AchievementDetails extends StatefulWidget {
  AchievementDetails({super.key, required this.streak, this.imagePath});
  AchievementModel streak;
  String? imagePath;

  @override
  State<AchievementDetails> createState() => _AchievementDetailsState();
}

late double width, height;

class _AchievementDetailsState extends State<AchievementDetails> {
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    final DateFormat formatter = DateFormat('d MMMM yyyy', 'en_US');
    String streakDate = formatter.format(DateTime.fromMillisecondsSinceEpoch(widget.streak.dateTime));
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.streak.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 70,),
            if (widget.imagePath != null && widget.imagePath != "") ...[
              Image(
                image: AssetImage(widget.imagePath!),
                height: 120,
              )
            ] else ...[
              Container(
                // width: width * 0.5,
                height: height * 0.11,
                decoration: BoxDecoration(
                    color: Constants.colorSecondaryVariant,
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                          color: Constants.redShadow, offset: Offset(4, 4))
                    ],
                    border: Border.all(color: Constants.redBorder)),
                child: Center(
                    child: Text(
                  widget.streak.title,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Constants.redBorder),
                )),
              )
            ],
            const SizedBox(
              height: 30,
            ),
            Text(widget.streak.description,style: const TextStyle(fontWeight: FontWeight.bold),),
            const SizedBox(
              height: 20,
            ),
            Text(streakDate),
            const SizedBox(
              height: 20,
            ),
            // ElevatedButton(onPressed: (){}, child: const Text("Share"))
          ],
        ),
      ),
    );
  }
}

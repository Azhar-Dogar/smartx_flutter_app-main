import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartx_flutter_app/common/app_button.dart';
import 'package:smartx_flutter_app/common/app_text_field.dart';
import 'package:smartx_flutter_app/dialogues/dogs_alert.dart';
import 'package:smartx_flutter_app/extension/context_extension.dart';
import 'package:smartx_flutter_app/models/dog_model.dart';
import 'package:smartx_flutter_app/util/constants.dart';

import '../../util/functions.dart';
import 'map_walk_controller.dart';

class StopWalkScreen extends StatelessWidget {
  static const String route = '/stop_Walk_screen';
  const StopWalkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MapWalkController());
    final size = context.screenSize;
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20, top: 30),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset('assets/Timer.png', width: 25),
                const SizedBox(width: 10),
                const Text('Duration',
                    style: TextStyle(
                        fontFamily: Constants.workSansMedium,
                        fontSize: 16,
                        color: Constants.colorSecondary)),
                const SizedBox(width: 10),
                const DottedLineContainer(),
                const SizedBox(width: 10),
                Text(
                  '${controller.hours.value}:${controller.minutes.value}:${controller.seconds.value}',
                  style: const TextStyle(color: Constants.colorOnSurface),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Image.asset('assets/Distance.png', width: 25),
                const SizedBox(width: 10),
                const Text('Distance',
                    style: TextStyle(
                        fontFamily: Constants.workSansMedium,
                        fontSize: 16,
                        color: Constants.colorSecondary)),
                const SizedBox(width: 10),
                const DottedLineContainer(),
                const SizedBox(width: 10),
                Text(
                  '${controller.totalDistance}',
                  style: const TextStyle(color: Constants.colorOnSurface),
                ),
              ],
            ),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                width: 100,
                height: 2,
                color: Constants.colorTextField),
            Row(
              children: [
                Image.asset('assets/Dog.png', width: 25),
                const SizedBox(width: 10),
                const Text('Dogs',
                    style: TextStyle(
                        fontFamily: Constants.workSansMedium,
                        fontSize: 16,
                        color: Constants.colorSecondary)),
                const SizedBox(width: 10),
                const DottedLineContainer(),
                const SizedBox(width: 10),
                DottedBorder(
                  color: Constants.colorSecondary,
                  borderType: BorderType.Circle,
                  child: IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) => const DogsAlert()).then((value) {
                        if (value != null) {
                          controller.selectedDogs =
                              value["list"] as List<DogModel>;
                        }
                        print(controller.selectedDogs.length);
                      });
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Constants.colorOnSurface,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 30),
                width: 100,
                height: 2,
                color: Constants.colorTextField),
            const SizedBox(height: 30),
            SizedBox(
                height: 50,
                child: DottedBorderAppTextField(
                    hint: 'Set title',
                    radius: 10,
                    controller: controller.titleController,
                    textInputType: TextInputType.text,
                    isError: false)),
            const Spacer(),
            Row(
              children: [
                Expanded(
                    child: Container(
                  margin: const EdgeInsets.only(right: 20),
                  alignment: Alignment.center,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Constants.colorTextField)),
                  child: const Text(
                    'Discard',
                    style: TextStyle(color: Constants.colorTextField),
                  ),
                )),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: SizedBox(
                      height: 60,
                      child: AppButton(
                          borderRadius: 10,
                          color: Constants.colorOnSurface,
                          fontFamily: Constants.workSansRegular,
                          text: 'Save',
                          onClick: () {
                            Functions.showLoaderDialog(context);
                            controller.addWalk();
                            Get.back();
                            shareDialogue();
                          }),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }

  Future shareDialogue() {
    return Get.defaultDialog(
        title: '',
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        content: const Text(
          'Your route has been successfully saved  you can also share it in your Activities',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: Constants.workSansRegular),
        ),
        backgroundColor: Colors.white,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Get.back();
                  Get.back();
                },
                child: Container(
                    margin: const EdgeInsets.only(right: 20),
                    alignment: Alignment.center,
                    height: 50,
                    width: Get.width / 4,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Constants.colorSecondary)),
                    child: const Text('Close',
                        style: TextStyle(color: Constants.colorSecondary))),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: SizedBox(
                  height: 60,
                  width: Get.width / 4,
                  child: AppButton(
                      borderRadius: 10,
                      color: Constants.colorOnSurface,
                      fontFamily: Constants.workSansRegular,
                      text: 'Share',
                      onClick: () {}),
                ),
              ),
            ],
          ),
        ]);
  }
}

class DottedLineContainer extends StatelessWidget {
  const DottedLineContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 3,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Constants.colorLight.withOpacity(0.5)),
        ),
        Container(
            width: 30, height: 1, color: Constants.colorLight.withOpacity(0.5)),
        Container(
          width: 3,
          height: 3,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Constants.colorLight.withOpacity(0.5)),
        ),
      ],
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smartx_flutter_app/common/app_button.dart';
import 'package:smartx_flutter_app/common/app_text_field.dart';
import 'package:smartx_flutter_app/dialogues/dogs_alert.dart';
import 'package:smartx_flutter_app/extension/context_extension.dart';
import 'package:smartx_flutter_app/models/dog_model.dart';
import 'package:smartx_flutter_app/models/user_model.dart';
import 'package:smartx_flutter_app/util/constants.dart';

import '../../helper/firestore_database_helper.dart';
import '../../models/post_model.dart';
import '../../models/walk_model.dart';
import '../../util/functions.dart';
import 'map_walk_controller.dart';

class StopWalkScreen extends StatefulWidget {
  static const String route = '/stop_Walk_screen';

  const StopWalkScreen({super.key, this.walk});

  final WalkModel? walk;
  @override
  State<StopWalkScreen> createState() => _StopWalkScreenState();
}

class _StopWalkScreenState extends State<StopWalkScreen> {
  var imagePath;

  final controller = Get.put(MapWalkController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imagePath = Get.arguments;
    print("Image Path");
    print(imagePath.value);
  }

  @override
  Widget build(BuildContext context) {
    final size = context.screenSize;
    print("These are selected dogs");
    print(controller.selectedDogs.length);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
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
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height * 0.9,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
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
                Obx(
                  () => Row(
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
                      if (controller.selectedDogs.isNotEmpty) ...[
                        Expanded(child: dogImages(controller.selectedDogs))
                      ],
                      DottedBorder(
                        color: Constants.colorSecondary,
                        borderType: BorderType.Circle,
                        child: IconButton(
                          onPressed: () {
                            showDialog(
                                    context: context,
                                    builder: (_) => const DogsAlert())
                                .then((value) {
                              if (value != null) {
                                controller.addSelectedDogs(
                                    value["list"] as List<DogModel>);
                              }
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
                      child: InkWell(
                        onTap: () {
                          controller.clearValues();
                          Get.back();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 20),
                          alignment: Alignment.center,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Constants.buttonColor)),
                          child: const Text(
                            'Discard',
                            style: TextStyle(color: Constants.buttonColor),
                          ),
                        ),
                      ),
                    ),
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
                              onClick: () async {
                                if (controller.titleController.text
                                    .trim()
                                    .isEmpty) {
                                  Functions.showSnackBar(
                                      context, "Please add title of walk");
                                  return;
                                }
                                Functions.showLoaderDialog(context);
                                await controller.addWalk();
                                Get.back();
                                await shareDialogue();
                                controller.clearValues();
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
        ),
      ),
    );
  }

  Future shareDialogue() {
    return Get.defaultDialog(
      title: '',
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                controller.clearValues();
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
                    onClick: () {
                      Share.shareXFiles([XFile(imagePath.value)],
                          subject: controller.titleController.text,
                          text:
                              "Title: ${controller.titleController.text}\nDistance Covered:${controller.totalDistance} km");
                      controller.clearValues();
                    }),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: SizedBox(
            height: 60,
            width: Get.width / 3,
            child: AppButton(
              borderRadius: 10,
              color: Constants.colorOnSurface,
              fontFamily: Constants.workSansRegular,
              text: 'Share In Feed',
              onClick: () async {
                try {
                  Functions.showLoaderDialog(context);
                  var snapshot = await FirebaseFirestore.instance
                      .collection("user")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .get();

                  var user = UserModel.fromJson(snapshot.data()!);


                  var walk = WalkModel(
                      title: controller.titleController.text,
                      dogs: controller.selectedDogs,
                      paths: controller.pathPoints,
                      dateTime: DateTime.now(),
                      duration: controller.hours.value * 3600 +
                          controller.minutes.value * 60 +
                          controller.seconds.value,
                      distance: controller.totalDistance.value / 1000,
                      id: "");
                  final post = PostModel(
                    text: "",
                    username:
                        '${user.firstName} ${user.lastName}',
                    userImage: user.imagePath ?? '',
                    created: DateTime.now(),
                    groupId: '',
                    likedUsers: [],
                    userid: FirebaseAuth.instance.currentUser!.uid,
                    id: '',
                    walk: walk,
                  );
                  final res = await _firestoreDatabaseHelper.addPost(post);


                  print(res?.id);
                  Get.back();
                  Get.back();
                  Get.back();
                } catch (_, t) {
                  print(t);

                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget dogImages(List<DogModel> dogs) {
    return Stack(
      children: [
        avatar(dogs[0].imagePath!),
        if (dogs.length > 1)
          Positioned(left: 30, child: avatar(dogs[1].imagePath!)),
        if (dogs.length > 2)
          Positioned(
            left: 70,
            child: Stack(children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.6),
                ),
                child: Opacity(opacity: 0.6, child: avatar(dogs[2].imagePath!)),
              ),
              if (dogs.length > 3)
                Positioned(
                  left: 15,
                  top: 10,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      '+${(dogs.length - 3)}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    ),
                  ),
                )
            ]),
          ),
      ],
    );
  }

  final FirestoreDatabaseHelper _firestoreDatabaseHelper =
      FirestoreDatabaseHelper.instance();

  Widget avatar(String imagePath) {
    return CircleAvatar(
      backgroundImage: NetworkImage(imagePath),
      radius: 25,
    );
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:smartx_flutter_app/common/dog_checkbox.dart';
import 'package:smartx_flutter_app/common/margin_widget.dart';
import 'package:smartx_flutter_app/ui/main/main_screen_controller.dart';
import 'package:smartx_flutter_app/ui/user-detail/user_detail_controller.dart';

import '../helper/meta_data.dart';
import '../models/dog_model.dart';
import '../ui/map-walk/map_walk_controller.dart';

class DogsAlert extends StatefulWidget {
  const DogsAlert({super.key});

  @override
  State<DogsAlert> createState() => _DogsAlertState();
}

class _DogsAlertState extends State<DogsAlert> {
  final _controller = Get.find<MainScreenController>();
  late double width, height;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    final controller = Get.put(
        UserDetailController(mapEntry: MapEntry(true, _controller.user)));
    List<DogModel> list = [];
    return GetX<UserDetailController>(builder: (DisposableInterface con) {
      final event = controller.userDogEvents.value;
      if (event is Data) {
        list = event.data as List<DogModel>;
      }
      return AlertDialog(
        scrollable: true,
        title: const Center(child: Text("Select Dogs")),
        content: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            if (controller.userDogEvents.value is Loading) ...[
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator.adaptive(),
                ],
              )
            ],
            if (controller.userDogEvents.value is Empty) ...[
              const Center(child: Text('no dog profile added yet'))
            ],
            if (controller.userDogEvents.value is Data) ...[
              SizedBox(
                height: 300,
                width: double.infinity,
                child: ListView.builder(
                    // padding: const EdgeInsets.symmetric(horizontal: 3),
                    itemCount: list.length,
                    // shrinkWrap: true,
                    itemBuilder: (_, i) {
                      return
                          // Text("data");
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: DogCheckBox(
                                check: list[i].isSelected,
                                onChanged: (v) {
                                  setState(() {
                                    list[i].isSelected = !list[i].isSelected;
                                  });
                                },
                                model: list[i]),
                          );
                    }),
              )
            ],
            // return const SizedBox();
          ],
        ),
        actions: [
          TextButton(onPressed: () {
            Get.back();
          }, child: const Text("cancel")),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop({
                  "list": list
                      .where((element) => element.isSelected == true)
                      .toList(),
                });
              },
              child: const Text("ok"))
        ],
      );
    });
  }

  //   );
  // }
  Widget dogWidget(DogModel model) {
    // bool check = true;
    // if(model.isSelected != null){
    //   check = model.isSelected!;
    // }
    return InkWell(
      onTap: () {
        setState(() {
          model.isSelected != model.isSelected;
        });
        print(model.isSelected);
      },
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(model.imagePath ??
                "https://hips.hearstapps.com/hmg-prod/images/dog-puppy-on-garden-royalty-free-image-1586966191.jpg?crop=0.752xw:1.00xh;0.175xw,0&resize=1200:*"),
          ),
          const MarginWidget(
            factor: 1,
            isHorizontal: true,
          ),
          Expanded(child: Text(model.name)),
          Checkbox(value: model.isSelected ?? false, onChanged: (v) {})
        ],
      ),
    );
  }
}

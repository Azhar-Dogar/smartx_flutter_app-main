import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartx_flutter_app/extension/context_extension.dart';
import 'package:smartx_flutter_app/ui/main/main_screen_controller.dart';
import 'package:smartx_flutter_app/ui/map-walk/map_walk_screen.dart';
import 'package:smartx_flutter_app/util/constants.dart';

import '../../common/bottom_navigation-class.dart';

class MainScreen extends StatefulWidget {
  static const String route = '/main_screen_route';
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;
  final controller = Get.find<MainScreenController>();
  @override
  Widget build(BuildContext context) {
    final size = context.screenSize;
    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: Constants.colorSecondaryVariant,
        bottomNavigationBar:
            bottomNavigation(), // Obx(() => BottomNavigationBar(
        floatingActionButton: GetX<MainScreenController>(builder: (_) {
          if (controller.indexState.value == 3) {
            return FloatingActionButton(
              backgroundColor: Constants.buttonColor,
              onPressed: () {
                controller.changeIndex(0);
              },
              child: const Icon(
                Icons.add,
                color: Constants.colorOnBackground,
              ),
            );
          }
          return const SizedBox();
        }),
        body: GetX<MainScreenController>(
            builder: (_) => IndexedStack(
                index: controller.indexState.value,
                children: controller.mainNavigationScreenMap.values.toList())),
      ),
    );
  }

  Widget bottomNavigation() {
    return BottomNavigationClass(
      items: [
        BottomNavItem(
            isFirst: true,
            index: 0,
            image: '',
            isSelected: controller.indexState.value == 0),
        BottomNavItem(
            index: 1,
            image: 'assets/Home.png',
            isSelected: controller.indexState.value == 1),
        BottomNavItem(
            index: 2,
            image: 'assets/people.png',
            isSelected: controller.indexState.value == 2),
        BottomNavItem(
            image: 'assets/location.png',
            index: 3,
            isSelected: controller.indexState.value == 3),
        BottomNavItem(
            index: 4,
            isProfile: (controller.user != null)
                ? (controller.user!.imagePath != "")
                    ? true
                    : false
                : false,
            image: (controller.user != null)
                ? (controller.user!.imagePath != "")
                    ? controller.user!.imagePath!
                    : "assets/profile.png"
                : "assets/profile.png",
            isSelected: controller.indexState.value == 4),
      ],
      onSelect: (index) {
        setState(() {
          Get.find<MainScreenController>().handleNavigationIndex(index);
        });
      },
    );
  }
}

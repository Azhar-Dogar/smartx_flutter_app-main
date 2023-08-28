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
        //     key: Get.find<MainScreenController>().globalKey,
        //     backgroundColor: Constants.colorOnBackground,
        //     // key: controller.keyWall,
        //     type: BottomNavigationBarType.shifting,
        //     showSelectedLabels: true,
        //     elevation: 0,
        //     unselectedLabelStyle: const TextStyle(
        //         fontSize: 10,
        //         height: 1.5,
        //         fontWeight: FontWeight.w500,
        //         fontFamily: Constants.workSansRegular),
        //     showUnselectedLabels: true,
        //     selectedLabelStyle: const TextStyle(
        //         fontSize: 10,
        //         height: 1.5,
        //         fontWeight: FontWeight.w500,
        //         fontFamily: Constants.workSansRegular),
        //     selectedItemColor: Colors.red,
        //     items: <BottomNavigationBarItem>[
        //       BottomNavigationBarItem(
        //         // backgroundColor: Colors.yellow,
        //           icon: Padding(
        //             padding: const EdgeInsets.all(2.0),
        //             child: GestureDetector(
        //                 child: Image.asset('assets/Home.png',
        //                     width: 25, height: 25, color: Colors.grey)),
        //           ),
        //           activeIcon: Container(
        //               padding: const EdgeInsets.symmetric(
        //                   horizontal: 23, vertical: 10),
        //               decoration: BoxDecoration(
        //                   boxShadow: [
        //                     BoxShadow(
        //                       color: Colors.grey.withOpacity(0.7),
        //                       offset: const Offset(0.0, 1.0), //(x,y)
        //                       blurRadius: 3.0,
        //                     ),
        //                   ],
        //                   color: Constants.buttonColor,
        //                   borderRadius: BorderRadius.circular(30)),
        //               child: Image.asset('assets/Home.png',
        //                   width: 25, height: 25)),
        //           label: ''),
        //       BottomNavigationBarItem(
        //           icon: GestureDetector(
        //               child: Image.asset('assets/people.png',
        //                   width: 25, height: 25)),
        //           activeIcon: Container(
        //               padding: const EdgeInsets.symmetric(
        //                   horizontal: 23, vertical: 10),
        //               decoration: BoxDecoration(
        //                   boxShadow: [
        //                     BoxShadow(
        //                       color: Colors.grey.withOpacity(0.7),
        //                       offset: const Offset(0.0, 1.0), //(x,y)
        //                       blurRadius: 3.0,
        //                     ),
        //                   ],
        //                   color: Constants.colorSecondary,
        //                   borderRadius: BorderRadius.circular(30)),
        //               child: Image.asset('assets/people.png',
        //                   width: 25,
        //                   height: 25,
        //                   color: Constants.colorOnBackground)),
        //           label: ''),
        //       BottomNavigationBarItem(
        //           icon: GestureDetector(
        //               child: Image.asset('assets/location.png',
        //                   width: 25, height: 25)),
        //           activeIcon: Container(
        //               padding: const EdgeInsets.symmetric(
        //                   horizontal: 23, vertical: 10),
        //               decoration: BoxDecoration(
        //                   boxShadow: [
        //                     BoxShadow(
        //                         color: Colors.grey.withOpacity(0.7),
        //                         offset: const Offset(0.0, 1.0), //(x,y)
        //                         blurRadius: 3.0)
        //                   ],
        //                   color: Constants.colorSecondary,
        //                   borderRadius: BorderRadius.circular(20)),
        //               child: Image.asset('assets/location.png',
        //                   width: 25,
        //                   height: 25,
        //                   color: Constants.colorOnBackground)),
        //           label: ''),
        //       BottomNavigationBarItem(
        //           icon: GestureDetector(
        //               child: Image.asset('assets/profile.png',
        //                   width: 25, height: 25)),
        //           activeIcon: Container(
        //               padding: const EdgeInsets.symmetric(
        //                   horizontal: 23, vertical: 10),
        //               decoration: BoxDecoration(
        //                   boxShadow: [
        //                     BoxShadow(
        //                       color: Colors.grey.withOpacity(0.7),
        //                       offset: const Offset(0.0, 1.0), //(x,y)
        //                       blurRadius: 3.0,
        //                     ),
        //                   ],
        //                   color: Constants.colorSecondary,
        //                   borderRadius: BorderRadius.circular(20)),
        //               child: Image.asset('assets/profile.png',
        //                   width: 25, height: 25)),
        //           label: ''),
        //     ],
        //     currentIndex: Get.find<MainScreenController>().indexState.value,
        //     onTap: (int index) async {
        //       Get.find<MainScreenController>().handleNavigationIndex(index);
        //     })),
        floatingActionButton: GetX<MainScreenController>(builder: (_) {
          if (controller.indexState.value == 3) {
             return FloatingActionButton(
              backgroundColor: Constants.buttonColor,
              onPressed: () => Get.toNamed(MapWalkScreen.route),
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
            image: 'assets/profile.png',
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

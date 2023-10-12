import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartx_flutter_app/backend/server_response.dart';
import 'package:smartx_flutter_app/common/app_button.dart';
import 'package:smartx_flutter_app/extension/context_extension.dart';
import 'package:smartx_flutter_app/helper/meta_data.dart';
import 'package:smartx_flutter_app/ui/group-detail/group_detail_screen.dart';
import 'package:smartx_flutter_app/ui/main/main_screen_controller.dart';
import 'package:smartx_flutter_app/util/constants.dart';

import '../../../models/group_model.dart';

class GroupsScreen extends StatelessWidget {
  static const String key_title = '/groups_screen_title';

  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = context.screenSize;
    final mainController = Get.find<MainScreenController>();
    return GetX<MainScreenController>(
      builder: (logic) {
        final event = logic.groupsEvents.value;
        if (event is Loading) {
          return Center(child: CircularProgressIndicator.adaptive());
        }
        if (event is Error) {
          return Center(child: Text('SomeThing went wrong'));
        }
        if (event is Data) {
          final list = event.data as List<GroupModel>;
          List userGroups = list.where((element) => element.users.contains(mainController.user!.id)).toList();
          List recommendedGroups = list.where((element) => !element.users.contains(mainController.user!.id)).toList();
          return SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 30),
            child: Column(
              children: [
                Container(
                  height: size.height * 0.6,
                  width: size.width,
                  color: Constants.colorOnBackground,
                  child: (userGroups.isEmpty)?Center(child: Text("No user group"),):Stack(
                    children: [
                      SizedBox(
                          height: size.height * 0.2,
                          width: size.width,
                          child: Image.network(
                              list[mainController.selectedSliderIndex.value]
                                  .coverImage ??
                                  "https://cdn.pixabay.com/photo/2016/12/13/05/15/puppy-1903313_1280.jpg",
                              fit: BoxFit.cover)),
                      Positioned(
                        top: size.height * 0.1,
                        child: SizedBox(
                            height: 150,
                            width: size.width,
                            child: ListView.builder(
                                itemCount: userGroups.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (_, i) {
                                  return GetX<MainScreenController>(
                                      builder: (_) {
                                        if (i ==
                                            mainController
                                                .selectedSliderIndex.value) {
                                          return InkWell(
                                              onTap: () => mainController
                                                  .selectedSliderIndex(i),
                                              child: Container(
                                                  margin: const EdgeInsets.all(8.0),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 3,
                                                          color: Constants
                                                              .colorOnBackground),
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          14)),
                                                  child: ClipRRect(
                                                      borderRadius:
                                                      BorderRadius.circular(10),
                                                      child: Image.network(
                                                          userGroups[i].profileImage,
                                                          fit: BoxFit.cover,
                                                          width: 130))));
                                        }
                                        return InkWell(
                                          onTap: () =>
                                              mainController.selectedSliderIndex(i),
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                left: 8.0,
                                                right: 8.0,
                                                bottom: 22,
                                                top: 22),
                                            child: ClipRRect(
                                              borderRadius:
                                              BorderRadius.circular(10),
                                              child: Stack(
                                                children: [
                                                  Image.network(
                                                    userGroups[i].profileImage,
                                                    fit: BoxFit.cover,
                                                    height: 150,
                                                    width: 100,
                                                  ),
                                                  Container(
                                                    height: 150,
                                                    width: 100,
                                                    color: Constants
                                                        .colorOnBackground
                                                        .withOpacity(0.5),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                })),
                      ),
                      Positioned(
                        top: size.height * 0.32,
                        left: 10,
                        right: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              userGroups[mainController.selectedSliderIndex.value]
                                  .title ??
                                  'A Dog Lovers\nCommunity',
                              style: TextStyle(
                                  fontFamily: Constants.workSansBold,
                                  fontSize: 22),
                            ),
                            SizedBox(height: 5),
                            Text(
                              userGroups[mainController.selectedSliderIndex.value]
                                  .description ??
                                  'Welcome to our dog loving community! this social media group is a haven for passionate dog lovers from all walks of life. Join us to connect with fellow dog enthusiasts, share heartwarming stories, exchange training tips, and showcase adorable pictures of our furry friends. ',
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontFamily: Constants.workSansRegular,
                                  fontSize: 11),
                            ),
                            SizedBox(height: 10),
                            SizedBox(
                                height: 65,
                                width: size.width,
                                child: AppButton(
                                    onClick: () {
                                      if (userGroups[mainController
                                          .selectedSliderIndex.value]
                                          .isJoined) {
                                        Get.toNamed(GroupDetailScreen.route,
                                            arguments: userGroups[mainController
                                                .selectedSliderIndex.value]);
                                      } else {
                                        Get.find<MainScreenController>()
                                            .joinGroup(
                                            mainController
                                                .selectedSliderIndex.value,
                                            userGroups[mainController
                                                .selectedSliderIndex
                                                .value]);
                                      }
                                    },
                                    text:
                                    // userGroups[mainController
                                    //             .selectedSliderIndex.value]
                                    //         .isJoined ?
                                    'Explore',
                                    // : 'Join Now',
                                    fontFamily: Constants.workSansRegular,
                                    textColor: Constants.colorTextWhite,
                                    borderRadius: 10.0,
                                    fontSize: 16,
                                    color: Constants.buttonColor)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Recommended groups',
                        style: TextStyle(
                            fontFamily: Constants.workSansBold, fontSize: 18),
                      ),
                    ],
                  ),
                ),
                if(recommendedGroups.isEmpty)...[
                  Text("No Group to show")
                ]else...[
                  SizedBox(
                    height: 220,
                    width: size.width,
                    child: ListView.builder(
                        itemCount: recommendedGroups.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (_, i) => SingleGroupCardWidget(
                            index: i, size: size, groupModel: recommendedGroups[i])),
                  )]
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 30),
          child: Column(
            children: [
              Container(
                height: size.height * 0.6,
                width: size.width,
                color: Constants.colorOnBackground,
                child: Stack(
                  children: [
                    SizedBox(
                        height: size.height * 0.2,
                        width: size.width,
                        child: Image.network(
                            "https://cdn.pixabay.com/photo/2016/12/13/05/15/puppy-1903313_1280.jpg",
                            fit: BoxFit.cover)),
                    Positioned(
                      top: size.height * 0.1,
                      child: SizedBox(
                          height: 150,
                          width: size.width,
                          child: ListView.builder(
                              itemCount: mainController.imageUrlList.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (_, i) {
                                return GetX<MainScreenController>(builder: (_) {
                                  if (i ==
                                      mainController
                                          .selectedSliderIndex.value) {
                                    return InkWell(
                                        onTap: () => mainController
                                            .selectedSliderIndex(i),
                                        child: Container(
                                            margin: const EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 3,
                                                    color: Constants
                                                        .colorOnBackground),
                                                borderRadius:
                                                BorderRadius.circular(10)),
                                            child: ClipRRect(
                                                borderRadius:
                                                BorderRadius.circular(10),
                                                child: Image.network(
                                                    mainController
                                                        .imageUrlList[i],
                                                    fit: BoxFit.cover,
                                                    width: 130))));
                                  }
                                  return InkWell(
                                    onTap: () =>
                                        mainController.selectedSliderIndex(i),
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 8.0,
                                          right: 8.0,
                                          bottom: 22,
                                          top: 22),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Stack(
                                          children: [
                                            Image.network(
                                              mainController.imageUrlList[i],
                                              fit: BoxFit.cover,
                                              height: 150,
                                              width: 100,
                                            ),
                                            Container(
                                              height: 150,
                                              width: 100,
                                              color: Constants.colorOnBackground
                                                  .withOpacity(0.5),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                              })),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 10,
                      right: 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'A Dog Lovers\nCommunity',
                            style: TextStyle(
                                fontFamily: Constants.workSansBold,
                                fontSize: 22),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Welcome to our dog loving community! this social media group is a haven for passionate dog lovers from all walks of life. Join us to connect with fellow dog enthusiasts, share heartwarming stories, exchange training tips, and showcase adorable pictures of our furry friends. ',
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontFamily: Constants.workSansRegular,
                                fontSize: 11),
                          ),
                          SizedBox(
                              height: 65,
                              width: size.width,
                              child: AppButton(
                                  onClick: () =>
                                      Get.toNamed(GroupDetailScreen.route),
                                  text: 'Explore',
                                  fontFamily: Constants.workSansRegular,
                                  textColor: Constants.colorTextWhite,
                                  borderRadius: 10.0,
                                  fontSize: 16,
                                  color: Constants.colorSecondary)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Recommended groups',
                      style: TextStyle(
                          fontFamily: Constants.workSansBold, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class SingleGroupCardWidget extends StatelessWidget {
  const SingleGroupCardWidget(
      {super.key,
        required this.size,
        required this.index,
        required this.groupModel});

  final GroupModel groupModel;
  final int index;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      height: 200,
      width: size.width * 0.85,
      decoration: BoxDecoration(
          color: Constants.colorOnBackground,
          borderRadius: BorderRadius.circular(15)),
      child: Stack(
        children: [
          SizedBox(
            height: size.height * 0.1,
            width: size.width,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              child: Image.network(
                groupModel.coverImage ??
                    "https://cdn.pixabay.com/photo/2016/12/13/05/15/puppy-1903313_1280.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: size.height * 0.05,
            child: Container(
              height: 90,
              width: 80,
              decoration: BoxDecoration(
                border:
                Border.all(color: Constants.colorOnBackground, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  groupModel.profileImage ??
                      "https://cdn.pixabay.com/photo/2016/12/13/05/15/puppy-1903313_1280.jpg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            right: 10,
            top: size.height * 0.11,
            child: SizedBox(
              width: size.width - 200,
              child: Text(
                groupModel.title ?? 'Pawfect Pups: For Passionate Dog Owners',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:
                TextStyle(fontFamily: Constants.workSansBold, fontSize: 17),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: size.width / 7,
            child: SizedBox(
                height: 55,
                width: size.width / 1.8,
                child: AppButton(
                    onClick: () {
                      // if (groupModel.isJoined) {
                      // } else {
                      Get.find<MainScreenController>()
                          .joinGroup(index, groupModel);
                      // }
                    },
                    text: 'Join Now',
                    fontFamily: Constants.workSansRegular,
                    textColor: Constants.colorTextWhite,
                    borderRadius: 10.0,
                    fontSize: 16,
                    color: Constants.buttonColor)),
          )
        ],
      ),
    );
  }
}
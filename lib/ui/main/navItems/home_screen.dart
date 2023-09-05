import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartx_flutter_app/backend/server_response.dart';
import 'package:smartx_flutter_app/common/app_button.dart';
import 'package:smartx_flutter_app/common/app_text_field.dart';
import 'package:smartx_flutter_app/extension/context_extension.dart';
import 'package:smartx_flutter_app/helper/meta_data.dart';
import 'package:smartx_flutter_app/notification_screen.dart';
import 'package:smartx_flutter_app/ui/auth/dog-profile/dog_profile_screen.dart';
import 'package:smartx_flutter_app/ui/group-detail/group_detail_screen.dart';
import 'package:smartx_flutter_app/ui/main/main_screen_controller.dart';
import 'package:smartx_flutter_app/util/constants.dart';

import '../../../models/post_model.dart';

class HomeScreen extends StatelessWidget {
  static const String key_title = '/home_screen_title';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = context.screenSize;
    final controller = Get.find<MainScreenController>();

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        width: size.width,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                offset: const Offset(0.0, 1.0), //(x,y)
                blurRadius: 3.0,
              ),
            ],
            color: Constants.colorSecondary,
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10))),
        child: Row(children: [
          const Expanded(
            child: AppTextField(
                hint: 'Search',
                height: 50,
                color: Constants.colorOnBackground,
                radius: 10,
                textInputType: TextInputType.text,
                isError: false),
          ),
          InkWell(
              onTap: () => Get.toNamed(NotificationScreen.route),
              child: Container(
                  margin: const EdgeInsets.only(left: 5),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                      color: Constants.colorOnBackground,
                      borderRadius: BorderRadius.circular(10)),
                  child: Image.asset('assets/Notification.png', height: 25)))
        ]),
      ),
      Expanded(
          child: CustomScrollView(slivers: [
        const SliverToBoxAdapter(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Challenges',
                      style: TextStyle(
                          fontFamily: Constants.workSansBold, fontSize: 16),
                    ),
                    Text('SEE ALL',
                        style: TextStyle(
                            fontFamily: Constants.workSansRegular,
                            color: Constants.colorPrimary,
                            fontSize: 16))
                  ])),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 250,
            width: size.width,
            child: ListView.builder(
              itemCount: 3,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, i) => Container(
                height: 250,
                width: size.width - 50,
                decoration: BoxDecoration(
                    color: Constants.colorOnBackground,
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.asset(
                              'assets/1.png',
                              height: 40,
                            )),
                        const Text(
                          'Daily Walk Challenge',
                          style: TextStyle(
                              fontFamily: Constants.workSansBold,
                              fontSize: 16,
                              color: Constants.colorSecondary),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Commit to taking your dog for a daily walk, exploring different routes and parks to keep things interesting for both of you..',
                      style: TextStyle(
                          fontFamily: Constants.workSansRegular,
                          color: Constants.colorSecondary),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Image.asset(
                          'assets/time.png',
                          width: 20,
                          color: Constants.colorTextField,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'July 1, 2023 to July 31, 2023',
                          style: TextStyle(
                              fontFamily: Constants.workSansLight,
                              color: Constants.colorTextField),
                        ),
                      ],
                    ),
                    SizedBox(
                        height: 55,
                        width: size.width / 1.6,
                        child: AppButton(
                            onClick: () {},
                            text: 'Mark as complete',
                            fontFamily: Constants.workSansRegular,
                            textColor: Constants.colorTextWhite,
                            borderRadius: 10.0,
                            fontSize: 16,
                            color: Constants.buttonColor)),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              'News Feed',
              style:
                  TextStyle(fontFamily: Constants.workSansBold, fontSize: 16),
            ),
          ),
        ),
        // const SizedBox(height: 10),
        SliverToBoxAdapter(
          child: GetX<MainScreenController>(
              builder: (_) {
          final state = controller.postDataEvent.value;
          print(state);
          if (state is Loading) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (state is Data) {
            final allIds = state.data as List<String>;
            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("posts")
                  .where('userid', whereIn: allIds)
                  .orderBy("created", descending: true)
                  .snapshots(includeMetadataChanges: true),
              builder: (_, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (snapshot.data == null) {
                  return const Text('Something went wrong');
                }
                if (snapshot.hasData) {
                  final posts = snapshot.data!.docs
                      .map((e) => PostModel.fromJson(
                          e.data() as Map<String, dynamic>))
                      .toList();
                  return
                    ListView.builder(
                      itemCount: posts.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (_, i) {
                        final isLiked = posts[i].likedUsers.contains(
                            FirebaseAuth.instance.currentUser?.uid);

                        return SinglePostWidget(
                          postModel: posts[i].copyWith(isLiked: isLiked),
                          isLiked: isLiked,
                          onLikedTap: () {
                            controller.toggleLike(posts[i], isLiked);
                          },
                        );
                      });
                }
                return const SizedBox();
              },
            );
          }

          return const SizedBox();
              },
            ),
        )
      ]))
    ]);
  }
}

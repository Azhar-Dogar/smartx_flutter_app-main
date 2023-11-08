import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartx_flutter_app/common/app_text_field.dart';
import 'package:smartx_flutter_app/common/questWidget.dart';
import 'package:smartx_flutter_app/extension/context_extension.dart';
import 'package:smartx_flutter_app/ui/main/notifications/notification_screen.dart';
import 'package:smartx_flutter_app/ui/group-detail/group_detail_screen.dart';
import 'package:smartx_flutter_app/ui/main/main_screen_controller.dart';
import 'package:smartx_flutter_app/util/constants.dart';

import '../../../models/post_model.dart';
import '../../../models/quest_model.dart';
import '../../map-walk/map_walk_controller.dart';

class HomeScreen extends StatefulWidget {
  static const String key_title = '/home_screen_title';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final mapWalkController = Get.put(MapWalkController());
  late Size size;
  @override
  Widget build(BuildContext context) {
    size = context.screenSize;
    final controller = Get.put(MainScreenController());
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
      GetX<MainScreenController>(builder: (DisposableInterface con) {
        return Expanded(
          child: CustomScrollView(slivers: [
            SliverToBoxAdapter(
              child: StreamBuilder(
                  stream: controller.questStream,
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      final quests = snapshot.data!.docs
                          .map((e) => QuestModel.fromJson(
                              e.data() as Map<String, dynamic>))
                          .toList();
                      if (quests.isNotEmpty) {
                        return Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Challenges',
                                      style: TextStyle(
                                          fontFamily: Constants.workSansBold,
                                          fontSize: 16),
                                    ),
                                  ]),
                            ),
                            SizedBox(
                              height: 250,
                              width: size.width,
                              child: ListView.builder(
                                  itemCount: quests.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (_, i) {
                                    return QuestWidget(model: quests[i]);
                                  }),
                            )
                          ],
                        );
                      }
                    }
                    return const SizedBox();
                  }),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'News Feed',
                  style: TextStyle(
                      fontFamily: Constants.workSansBold, fontSize: 16),
                ),
              ),
            ),
            if (controller.followingUserIds.isEmpty) ...[

            ] else ...[
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("posts")
                    .where('userid', whereIn: controller.followingUserIds)
                    .where("groupId", isEqualTo: "")
                    .snapshots(includeMetadataChanges: true),
                builder: (_, snapshot) {
                  if (snapshot.hasError) {
                    return SliverToBoxAdapter(
                        child: Text('Error: ${snapshot.error}'));
                  }
                  if (snapshot.data == null) {
                    return const SliverToBoxAdapter(
                        child: Text('Something went wrong'));
                  }
                  if (snapshot.hasData) {
                    final posts = snapshot.data!.docs
                        .map((e) => PostModel.fromJson(
                            e.data() as Map<String, dynamic>))
                        .toList();
                    return (posts.isEmpty)
                            ? const SliverToBoxAdapter(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 100.0),
                                  child: Center(child: Text("No News Feed")),
                                ),
                              )
                            : SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int i) {
                                    final isLiked = posts[i]
                                        .likedUsers
                                        .contains(FirebaseAuth
                                            .instance.currentUser?.uid);

                                    return SinglePostWidget(
                                      postModel:
                                          posts[i].copyWith(isLiked: isLiked),
                                      isLiked: isLiked,
                                      onLikedTap: () {
                                        controller.toggleLike(
                                            posts[i], isLiked);
                                      },
                                    );
                                  },
                                  childCount: posts.length,
                                ),
                              );
                  }
                  return const SliverToBoxAdapter(child: SizedBox());
                },
              )
            ]
          ]),
        );
      })
    ]);
  }
}

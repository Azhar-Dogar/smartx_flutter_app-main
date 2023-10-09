import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smartx_flutter_app/backend/server_response.dart';
import 'package:smartx_flutter_app/common/app_button.dart';
import 'package:smartx_flutter_app/extension/context_extension.dart';
import 'package:smartx_flutter_app/helper/meta_data.dart';
import 'package:smartx_flutter_app/models/group_model.dart';
import 'package:smartx_flutter_app/models/quest_model.dart';
import 'package:smartx_flutter_app/ui/add-post/add_post_screen.dart';
import 'package:smartx_flutter_app/ui/group-detail/group_detail_controller.dart';
import 'package:smartx_flutter_app/ui/main/notifications/notification_screen.dart';
import 'package:smartx_flutter_app/ui/post-detail/post_detail_screen.dart';
import 'package:smartx_flutter_app/ui/user-detail/user_detail_controller.dart';
import 'package:smartx_flutter_app/util/constants.dart';

import '../../helper/firestore_database_helper.dart';
import '../../models/post_model.dart';
import '../../models/user_model.dart';

class GroupDetailScreen extends StatelessWidget {
  static const String route = '/group_detai_screen_route';

  const GroupDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GroupDetailController>();
    final size = context.screenSize;
    return SafeArea(
      bottom: false,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Constants.colorSecondaryVariant,
          body: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  CachedNetworkImage(
                    imageUrl: controller.groupModel.coverImage,
                    height: 140,
                    width: size.width,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        const SizedBox(width: 40),
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: Constants.colorOnBackground,
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: controller.groupModel.profileImage,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                            child: Text(
                              controller.groupModel.title ?? 'Dogs all the way',
                              style: const TextStyle(
                                  color: Constants.colorOnBackground,
                                  fontFamily: Constants.workSansBold,
                                  fontSize: 28),
                            ))
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                color: Constants.colorOnBackground,
                child: const TabBar(
                  indicatorColor: Constants.colorSecondary,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Constants.colorSecondary,
                  unselectedLabelColor: Constants.colorSecondary,
                  tabs: [
                    Tab(text: "Feed"),
                    Tab(text: 'Quests'),
                  ],
                ),
              ),
              Expanded(
                  child: TabBarView(
                    children: [
                      const FeedTabScreen(posts: []),
                      QuestsTabScreen(
                        size: size,
                        group: controller.groupModel,
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class QuestsTabScreen extends StatefulWidget {
  QuestsTabScreen({super.key, required this.size, required this.group});
  GroupModel group;
  final Size size;

  @override
  State<QuestsTabScreen> createState() => _QuestsTabScreenState();
}

class _QuestsTabScreenState extends State<QuestsTabScreen> {
  final controller = Get.find<GroupDetailController>();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("quests")
            .where("groupId", isEqualTo: widget.group.id)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            final quests = snapshot.data!.docs
                .map((e) =>
                QuestModel.fromJson(e.data() as Map<String, dynamic>))
                .toList();
            return ListView.builder(
                itemCount: quests.length,
                // shrinkWrap: true,
                itemBuilder: (_, i) {
                  bool isJoin = false;
                  if (quests[i]
                      .users
                      .contains(FirebaseAuth.instance.currentUser!.uid)) {
                    isJoin = true;
                  }
                  return Column(
                    children: [questWidget(quests[i], isJoin)],
                  );
                });
          }
          return const SizedBox();
        });
  }

  Widget questWidget(QuestModel quest, bool isJoin) {
    return Container(
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
                  borderRadius: BorderRadius.circular(8),
                  child: Image(
                    image: NetworkImage(widget.group.profileImage),
                    height: 40,
                  )),
              const SizedBox(
                width: 10,
              ),
              Text(
                quest.title,
                style: const TextStyle(
                    fontFamily: Constants.workSansBold,
                    fontSize: 16,
                    color: Constants.colorSecondary),
              )
            ],
          ),
          const SizedBox(height: 10),
          Text(
            quest.description,
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
              ),
              const SizedBox(width: 10),
              Text(
                "${quest.duration} days",
                style: const TextStyle(
                    fontFamily: Constants.workSansLight,
                    color: Constants.colorSecondary),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: 55,
                  width: widget.size.width / 1.6,
                  child: AppButton(
                      onClick: () async {
                        if (!isJoin) {
                          await controller.joinQuest(quest);
                        }
                      },
                      text: isJoin ? "Joined" : 'Join Now',
                      fontFamily: Constants.workSansRegular,
                      textColor: Constants.colorTextWhite,
                      borderRadius: 10.0,
                      fontSize: 16,
                      color: Constants.colorSecondary)),
            ],
          ),
        ],
      ),
    );
  }
}

class FeedTabScreen extends StatelessWidget {
  final bool canPost;
  final Color color;
  final List<PostModel> posts;

  const FeedTabScreen(
      {this.canPost = true,
        this.color = Constants.colorSecondary,
        required this.posts,
        super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GroupDetailController>();
    return Column(
      children: [
        if (canPost)
          Container(
              color: Constants.colorOnBackground,
              margin: const EdgeInsets.only(top: 5),
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 15, bottom: 15),
              child: Row(children: [
                Container(
                    margin: const EdgeInsets.only(right: 10),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset('assets/4.png', height: 25)),
                Expanded(
                    child: InkWell(
                        onTap: () async {
                          final res = await Get.toNamed(
                            AddPostScreen.route,
                            arguments:
                            Get.find<GroupDetailController>().groupModel.id,
                          );

                          if (res is PostModel) {
                            Get.find<GroupDetailController>()
                                .updateTempPost(res);
                          }
                        },
                        child: Text('Have something to say?',
                            style: TextStyle(
                                fontFamily: Constants.workSansLight,
                                color: color))))
              ])),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("posts")
              .where("groupId", isEqualTo: controller.groupModel.id)
              .snapshots(includeMetadataChanges: true),
          builder: (_, snapshot) {
            if (snapshot.hasError) {
              return const Expanded(
                  child: Center(child: Text("Something went wrong")));
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            if (snapshot.hasData) {
              final posts = snapshot.data!.docs
                  .map((e) =>
                  PostModel.fromJson(e.data() as Map<String, dynamic>))
                  .toList();
              return Expanded(
                child: ListView.builder(
                    itemCount: posts.length,
                    // shrinkWrap: true,
                    // physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (_, i) {
                      final isLiked = posts[i]
                          .likedUsers
                          .contains(FirebaseAuth.instance.currentUser?.uid);

                      return SinglePostWidget(
                        postModel: posts[i].copyWith(isLiked: isLiked),
                        isLiked: isLiked,
                        onLikedTap: () {
                          controller.toggleLike(posts[i], isLiked);
                        },
                      );
                    }),
              );
            }
            return const SizedBox();
          },
        )
        // GetX<GroupDetailController>(
        //     autoRemove: false,
        //     builder: (con) {
        //       final event = con.groupPostEvents.value;
        //       if (event is Loading) {
        //         return const Expanded(
        //           child: Column(
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             crossAxisAlignment: CrossAxisAlignment.center,
        //             children: [
        //               CircularProgressIndicator.adaptive(),
        //             ],
        //           ),
        //         );
        //       }
        //
        //       if (event is Empty) {
        //         return const Expanded(
        //           child:Center(child: Text("No Post Yet",style: TextStyle(fontWeight: FontWeight.w500),)),
        //           // ListView.builder(
        //           //     padding: const EdgeInsets.symmetric(horizontal: 3),
        //           //     itemCount: 2,
        //           //     shrinkWrap: true,
        //           //     itemBuilder: (_, i) {
        //           //       return SinglePostWidget(
        //           //         postModel: PostModel(
        //           //             text: 'First Dog',
        //           //             username: 'Tester',
        //           //             userImage:
        //           //                 'https://firebasestorage.googleapis.com/v0/b/stroll-b2e07.appspot.com/o/profile%2F1690963975633?alt=media&token=04d7ace0-742f-4793-9684-a4447c5c6330',
        //           //             imagePath:
        //           //                 'https://images.unsplash.com/photo-1611003228941-98852ba62227?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=3348&q=80',
        //           //             userid: '1',
        //           //             id: '2',
        //           //             created: DateTime.now(),
        //           //             likedUsers: []),
        //           //         onLikedTap: () {},
        //           //       );
        //           //     }),
        //         );
        //       }
        //       if (event is Data) {
        //         final list = event.data as List<PostModel>;
        //         return Expanded(
        //           child: ListView.builder(
        //               padding: const EdgeInsets.symmetric(horizontal: 3),
        //               itemCount: list.length,
        //               shrinkWrap: true,
        //               itemBuilder: (_, i) {
        //                 final isLiked = list[i].likedUsers.contains(
        //                     FirebaseAuth.instance.currentUser?.uid);
        //                 return SinglePostWidget(
        //                   isLiked: isLiked,
        //                   postModel: list[i].copyWith(isLiked: isLiked),
        //                   onLikedTap: () {
        //                     print("i press like button");
        //                     controller.toggleLike(list[i], isLiked);
        //                   },
        //                 );
        //               }),
        //         );
        //       }
        //       return const SizedBox();
        //     }),
      ],
    );
  }
}

class SinglePostWidget extends StatelessWidget {
  final PostModel postModel;
  final bool isLiked;
  bool? isGroup;
  final VoidCallback onLikedTap;
  String? userImagePath;
  SinglePostWidget(
      {super.key,
        required this.postModel,
        this.isGroup,
        this.userImagePath,
        required this.onLikedTap,
        this.isLiked = false});

  @override
  Widget build(BuildContext context) {
    String userName = "";
    return Container(
      color: Constants.colorOnBackground,
      margin: const EdgeInsets.only(top: 5),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("user")
                      .doc(postModel.userid)
                      .snapshots(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      UserModel user =
                      UserModel.fromJson(snapshot.data!.data()!);
                      return Container(
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50)),
                          child: (user.imagePath.toString() == null ||
                              user.imagePath.toString() == '')
                              ? Image.asset('assets/4.png', height: 60)
                              : ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: CachedNetworkImage(
                                imageUrl: user.imagePath!,
                                height: 60,
                                width: 60,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                const Center(
                                    child: CircularProgressIndicator
                                        .adaptive())),
                          ));
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    postModel.groupId.toString() != ''
                        ? 'Group Post'
                        : postModel.username ?? 'Stella Andrew',
                    style: const TextStyle(
                        fontFamily: Constants.workSansMedium,
                        color: Constants.colorSecondary),
                  ),
                  Text(
                    DateFormat('MMMM dd, yyyy').format(postModel.created),
                    style: const TextStyle(
                        fontFamily: Constants.workSansLight,
                        color: Constants.colorSecondary),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 10),
          Text(
            postModel.text ?? 'Unleashing pure happiness, one wag at a time.',
            style: const TextStyle(
                fontFamily: Constants.workSansRegular,
                color: Constants.colorSecondary),
          ),
          const SizedBox(height: 10),
          (postModel.imagePath == null || postModel.imagePath.toString() == '')
              ? Image.asset('assets/2.png')
              : GestureDetector(
              onTap: () =>
                  Get.toNamed(PostDetailScreen.route, arguments: postModel),
              child: CachedNetworkImage(
                  imageUrl: postModel.imagePath!,
                  placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator.adaptive()))),
          const SizedBox(height: 10),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  onLikedTap.call();
                  print(isLiked);
                  if (FirebaseAuth.instance.currentUser!.uid !=
                      postModel.userid &&
                      !isLiked) {
                    FirestoreDatabaseHelper.instance()
                        .sendNotification(postModel, false);
                  }
                },
                child: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border_outlined,
                  color: isLiked
                      ? Constants.colorPrimaryVariant
                      : Colors.grey.withOpacity(0.6),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                  onTap: () =>
                      Get.toNamed(PostDetailScreen.route, arguments: postModel),
                  child: Image.asset('assets/Chat.png', height: 20)),
              const Spacer(),
              Text(
                '${postModel.totalLikes ?? 0} Likes',
                style: const TextStyle(
                    fontFamily: Constants.workSansLight,
                    color: Constants.colorSecondary),
              ), //
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () =>
                    Get.toNamed(PostDetailScreen.route, arguments: postModel),
                child: Text(
                  '${postModel.commentsCount ?? 0} comments',
                  style: const TextStyle(
                      fontFamily: Constants.workSansLight,
                      color: Constants.colorSecondary),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
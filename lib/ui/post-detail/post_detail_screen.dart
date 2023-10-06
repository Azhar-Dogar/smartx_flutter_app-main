import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartx_flutter_app/backend/server_response.dart';
import 'package:smartx_flutter_app/common/app_text_field.dart';
import 'package:smartx_flutter_app/common/stream_comments_wrapper.dart';
import 'package:smartx_flutter_app/extension/context_extension.dart';
import 'package:smartx_flutter_app/models/achievement_model.dart';
import 'package:smartx_flutter_app/models/post_model.dart';
import 'package:smartx_flutter_app/models/user_model.dart';
import 'package:smartx_flutter_app/ui/group-detail/group_detail_screen.dart';
import 'package:smartx_flutter_app/ui/map-walk/map_walk_controller.dart';
import 'package:smartx_flutter_app/ui/post-detail/post_detail_controller.dart';
import 'package:smartx_flutter_app/util/constants.dart';
import 'package:smartx_flutter_app/util/functions.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../helper/firestore_database_helper.dart';
import '../../models/comment_model.dart';

class PostDetailScreen extends StatelessWidget {
  static const String route = '/post_detail_screen_route';

  const PostDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PostDetailController>();
    final mapWalkController = Get.find<MapWalkController>();
    final size = context.screenSize;
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Constants.colorSecondary,
          automaticallyImplyLeading: false,
          title: GestureDetector(
              onTap: () => Get.back(),
              child: const Row(children: [
                Icon(
                  Icons.arrow_back,
                  color: Constants.colorOnBackground,
                ),
                Text(
                  'Back',
                  style: TextStyle(
                      fontFamily: Constants.workSansSemibold,
                      color: Constants.colorOnBackground,
                      fontSize: 16),
                )
              ]))),
      body: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
                  controller: controller.commentScroll,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GetBuilder<PostDetailController>(builder: (con) {
                          final isLiked = controller.postModel.likedUsers
                              .contains(FirebaseAuth.instance.currentUser?.uid);
                          print("comments");
                          print(controller.postModel.commentsCount);
                          return SinglePostWidget(
                            postModel: controller.postModel,
                            isLiked: isLiked,
                            onLikedTap: () {
                              controller.toggleLike(
                                  controller.postModel, isLiked);
                              if (FirebaseAuth.instance.currentUser!.uid !=
                                      controller.postModel.userid &&
                                  !isLiked) {
                                FirestoreDatabaseHelper.instance()
                                    .sendNotification(
                                        controller.postModel, false);
                              }
                            },
                          );
                        }),
                        const Padding(
                            padding: EdgeInsets.only(
                                left: 20.0, right: 20, bottom: 10),
                            child: Divider()),
                        CommentsStreamWrapper(
                            shrinkWrap: true,
                            scrollController: controller.commentScroll,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            stream: FirebaseFirestore.instance
                                .collection('comments')
                                .doc(controller.postModel.id)
                                .collection('comments')
                                .orderBy('timestamp', descending: true)
                                .snapshots(),
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (_, DocumentSnapshot snapshot) {
                              if (snapshot.data() != null) {
                                CommentModel comments = CommentModel.fromJson(
                                    snapshot.data() as Map<String, dynamic>);
                                final isLiked = comments.likedUsers.contains(
                                    FirebaseAuth.instance.currentUser!.uid);
                                return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, right: 20, bottom: 10),
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          (comments.userDp.toString() ==
                                                      'null' ||
                                                  comments.userDp.toString() ==
                                                      '')
                                              ? Image.asset('assets/4.png',
                                                  height: 40)
                                              : ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  child: CachedNetworkImage(
                                                      imageUrl:
                                                          comments.userDp ?? '',
                                                      height: 40,
                                                      width: 40,
                                                      fit: BoxFit.cover,
                                                      placeholder: (context,
                                                              url) =>
                                                          const Center(
                                                              child: CircularProgressIndicator
                                                                  .adaptive())),
                                                ),
                                          const SizedBox(width: 5),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                      color: Constants
                                                          .colorBackground,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              comments.username,
                                                              style: const TextStyle(
                                                                  fontFamily:
                                                                      Constants
                                                                          .workSansMedium,
                                                                  fontSize: 16,
                                                                  color: Constants
                                                                      .colorSecondary)),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                                timeago.format(
                                                                    comments
                                                                        .timestamp
                                                                        .toDate()),
                                                                style: const TextStyle(
                                                                    fontFamily:
                                                                        Constants
                                                                            .workSansLight,
                                                                    fontSize:
                                                                        12,
                                                                    color: Constants
                                                                        .colorSecondary)),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        comments.comment ??
                                                            'Such a cutie! 🐾❤️ Dogs truly are the best companions. Sending lots of belly rubs and ear scratches your way!',
                                                        style: const TextStyle(
                                                            fontFamily: Constants
                                                                .workSansRegular,
                                                            color: Constants
                                                                .colorSecondary),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    if (comments.likedUsers
                                                        .isNotEmpty) ...[
                                                      Text(
                                                          comments
                                                              .likedUsers.length
                                                              .toString(),
                                                          style: const TextStyle(
                                                              fontFamily: Constants
                                                                  .workSansLight,
                                                              fontSize: 16,
                                                              color: Constants
                                                                  .colorSecondary))
                                                    ],
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    GestureDetector(
                                                      child: Text('Like',
                                                          style: TextStyle(
                                                              fontFamily: Constants
                                                                  .workSansLight,
                                                              fontSize: 14,
                                                              color: (isLiked)
                                                                  ? Colors.blue
                                                                  : Constants
                                                                      .colorSecondary)),
                                                      onTap: () {
                                                        controller
                                                            .commentToggleLike(
                                                                comments,
                                                                isLiked);
                                                      },
                                                    ),
                                                    const SizedBox(width: 10)
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          if (comments.userId ==
                                              FirebaseAuth.instance.currentUser!
                                                  .uid) ...[
                                            IconButton(
                                              onPressed: () {
                                                final RenderBox button =
                                                    context.findRenderObject()
                                                        as RenderBox;
                                                final RenderBox overlay =
                                                    Overlay.of(context)!
                                                            .context
                                                            .findRenderObject()
                                                        as RenderBox;
                                                final Offset position = button
                                                    .localToGlobal(Offset.zero,
                                                        ancestor: overlay);
                                                showMenu(
                                                  context: context,
                                                  position:
                                                      RelativeRect.fromLTRB(
                                                    position.dx +
                                                        button.size.width,
                                                    position.dy +
                                                        button.size.height,
                                                    position.dx,
                                                    position.dy +
                                                        button.size.height,
                                                  ),
                                                  items: <PopupMenuEntry>[
                                                    PopupMenuItem(
                                                      child:
                                                          const Text('Delete'),
                                                      onTap: () {
                                                        Functions
                                                            .showLoaderDialog(
                                                                context);
                                                        controller
                                                            .deleteComment(
                                                                comments,);

                                                        Functions.showSnackBar(
                                                            context,
                                                            "comment deleted");
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                              icon: const Icon(Icons.more_horiz,
                                                  color: Constants
                                                      .colorPrimaryVariant),
                                            )
                                          ]
                                        ]));
                              }
                              return const SizedBox();
                            })
                      ]))),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("user")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  UserModel user = UserModel.fromJson(snapshot.data.data());
                  return Container(
                      margin: const EdgeInsets.only(top: 10),
                      color: Constants.colorSecondaryVariant,
                      child: AppTextField(
                        height: 40,
                        controller: controller.commentsTECController,
                        hint: 'write comment',
                        textInputType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        isError: false,
                        hasBorder: false,
                        onSuffixClick: () async {
                          await controller.uploadComment();
                          await controller.updateUser();
                          if (user.userComments! >= 20) {
                            List<AchievementModel> tempModel = mapWalkController.achievements
                                .where((p0) => p0.title == "20 comments").toList();
                            if(tempModel.isEmpty){
                            await mapWalkController
                                .addAchievement("20 comments","You have make 20 comments",DateTime.now().millisecondsSinceEpoch,1);
                          }else{
                              if(user.userComments! % 2 == 0){
                              await mapWalkController.updateAchievement(tempModel.first.id, tempModel.first.count + 1);
                              mapWalkController.getAchievement();
                            }}}
                          if (FirebaseAuth.instance.currentUser!.uid !=
                              controller.postModel.userid) {
                            await FirestoreDatabaseHelper.instance()
                                .sendNotification(controller.postModel, true);
                          }
                        },
                        suffixIcon: const Icon(Icons.send_rounded,
                            color: Constants.colorSecondary),
                        // prefixIcon: Image.asset('assets/attachment.png',
                        //     color: Constants.colorSecondary, width: 20)
                      ));
                }
                return const SizedBox();
              })
        ],
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartx_flutter_app/backend/server_response.dart';
import 'package:smartx_flutter_app/common/app_text_field.dart';
import 'package:smartx_flutter_app/common/stream_comments_wrapper.dart';
import 'package:smartx_flutter_app/extension/context_extension.dart';
import 'package:smartx_flutter_app/ui/group-detail/group_detail_screen.dart';
import 'package:smartx_flutter_app/ui/post-detail/post_detail_controller.dart';
import 'package:smartx_flutter_app/util/constants.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostDetailScreen extends StatelessWidget {
  static const String route = '/post_detail_screen_route';

  const PostDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PostDetailController>();
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
                          return SinglePostWidget(
                            postModel: controller.postModel,
                            isLiked: controller.postModel.isLiked,
                            onLikedTap: () {
                              controller.toggleLike(controller.postModel,
                                  controller.postModel.isLiked);
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
                              CommentModel comments = CommentModel.fromJson(
                                  snapshot.data() as Map<String, dynamic>);

                              return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 20, bottom: 10),
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        (comments.userDp.toString() == 'null' ||
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
                                                            child:
                                                                CircularProgressIndicator
                                                                    .adaptive())),
                                              ),
                                        const SizedBox(width: 5),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                margin: const EdgeInsets.only(
                                                    bottom: 5),
                                                decoration: BoxDecoration(
                                                    color: Constants
                                                        .colorBackground,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(comments.username,
                                                            style: const TextStyle(
                                                                fontFamily:
                                                                    Constants
                                                                        .workSansMedium,
                                                                fontSize: 16,
                                                                color: Constants
                                                                    .colorSecondary)),
                                                        Text(
                                                            timeago.format(
                                                                comments
                                                                    .timestamp
                                                                    .toDate()),
                                                            style: const TextStyle(
                                                                fontFamily:
                                                                    Constants
                                                                        .workSansLight,
                                                                fontSize: 12,
                                                                color: Constants
                                                                    .colorSecondary)),
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
                                              const Row(
                                                children: [
                                                  Text('Like',
                                                      style: TextStyle(
                                                          fontFamily: Constants
                                                              .workSansLight,
                                                          fontSize: 12,
                                                          color: Constants
                                                              .colorSecondary)),
                                                  SizedBox(width: 10)
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        const Icon(Icons.more_horiz,
                                            color:
                                                Constants.colorPrimaryVariant)
                                      ]));
                            })
                      ]))),
          Container(
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
                onSuffixClick: () => controller.uploadComment(),
                suffixIcon: const Icon(Icons.send_rounded,
                    color: Constants.colorSecondary),
                // prefixIcon: Image.asset('assets/attachment.png',
                //     color: Constants.colorSecondary, width: 20)
              ))
        ],
      ),
    );
  }
}

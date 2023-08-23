import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smartx_flutter_app/backend/server_response.dart';
import 'package:smartx_flutter_app/common/app_button.dart';
import 'package:smartx_flutter_app/extension/context_extension.dart';
import 'package:smartx_flutter_app/helper/meta_data.dart';
import 'package:smartx_flutter_app/ui/add-post/add_post_screen.dart';
import 'package:smartx_flutter_app/ui/group-detail/group_detail_controller.dart';
import 'package:smartx_flutter_app/ui/post-detail/post_detail_screen.dart';
import 'package:smartx_flutter_app/util/constants.dart';

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
                        CachedNetworkImage(
                          imageUrl: controller.groupModel.profileImage,
                          height: 100,
                          width: 100,
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
                  FeedTabScreen(posts: [
                    PostModel(
                        text: 'First Dog',
                        username: 'Tester',
                        userImage:
                            'https://firebasestorage.googleapis.com/v0/b/stroll-b2e07.appspot.com/o/profile%2F1690963975633?alt=media&token=04d7ace0-742f-4793-9684-a4447c5c6330',
                        imagePath:
                            'https://images.unsplash.com/photo-1611003228941-98852ba62227?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=3348&q=80',
                        userid: '1',
                        id: '2',
                        created: DateTime.now(),
                        likedUsers: []),
                    PostModel(
                        text: 'Second Dog',
                        username: 'Tester',
                        userImage:
                            'https://firebasestorage.googleapis.com/v0/b/stroll-b2e07.appspot.com/o/profile%2F1690963975633?alt=media&token=04d7ace0-742f-4793-9684-a4447c5c6330',
                        imagePath:
                            'https://images.unsplash.com/photo-1611003228941-98852ba62227?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=3348&q=80',
                        userid: '1',
                        id: '2',
                        created: DateTime.now(),
                        likedUsers: [])
                  ]),
                  QuestsTabScreen(size: size)
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}

class QuestsTabScreen extends StatelessWidget {
  const QuestsTabScreen({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 3,
        shrinkWrap: true,
        itemBuilder: (_, i) {
          return Column(
            children: [
              Container(
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
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'July 1, 2023 to July 31, 2023',
                          style: TextStyle(
                              fontFamily: Constants.workSansLight,
                              color: Constants.colorSecondary),
                        ),
                      ],
                    ),
                    SizedBox(
                        height: 55,
                        width: size.width / 1.6,
                        child: AppButton(
                            onClick: () {},
                            text: 'Join Now',
                            fontFamily: Constants.workSansRegular,
                            textColor: Constants.colorTextWhite,
                            borderRadius: 10.0,
                            fontSize: 16,
                            color: Constants.colorSecondary)),
                  ],
                ),
              ),
            ],
          );
        });
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
                          final res = await Get.toNamed(AddPostScreen.route,
                              arguments: Get.find<GroupDetailController>()
                                  .groupModel
                                  .id);

                          if (res is PostModel) {
                            Get.find<GroupDetailController>()
                                .updateTempPost(res);
                          }
                        },
                        child: Text('Have Something to share?',
                            style: TextStyle(
                                fontFamily: Constants.workSansLight,
                                color: color))))
              ])),
        GetX<GroupDetailController>(
            autoRemove: false,
            builder: (con) {
              final event = con.groupPostEvents.value;
              if (event is Loading) {
                return const Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator.adaptive(),
                    ],
                  ),
                );
              }

              if (event is Empty) {
                return Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      itemCount: 2,
                      shrinkWrap: true,
                      itemBuilder: (_, i) {
                        return SinglePostWidget(
                          postModel: PostModel(
                              text: 'First Dog',
                              username: 'Tester',
                              userImage:
                                  'https://firebasestorage.googleapis.com/v0/b/stroll-b2e07.appspot.com/o/profile%2F1690963975633?alt=media&token=04d7ace0-742f-4793-9684-a4447c5c6330',
                              imagePath:
                                  'https://images.unsplash.com/photo-1611003228941-98852ba62227?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=3348&q=80',
                              userid: '1',
                              id: '2',
                              created: DateTime.now(),
                              likedUsers: []),
                          onLikedTap: () {},
                        );
                      }),
                );
              }
              if (event is Data) {
                final list = event.data as List<PostModel>;
                return Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      itemCount: list.length,
                      shrinkWrap: true,
                      itemBuilder: (_, i) {
                        return SinglePostWidget(
                          postModel: list[i],
                          onLikedTap: () {},
                        );
                      }),
                );
              }
              return const SizedBox();
            }),
      ],
    );
  }
}

class SinglePostWidget extends StatelessWidget {
  final PostModel? postModel;
  final bool isLiked;
  final VoidCallback onLikedTap;

  const SinglePostWidget(
      {this.postModel, required this.onLikedTap, this.isLiked = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Constants.colorOnBackground,
      margin: const EdgeInsets.only(top: 5),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                  margin: const EdgeInsets.only(right: 10),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(50)),
                  child: (postModel?.userImage.toString() == 'null' ||
                          postModel?.userImage.toString() == '')
                      ? Image.asset('assets/4.png', height: 60)
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: CachedNetworkImage(
                              imageUrl: postModel?.userImage ?? '',
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator.adaptive())),
                        )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    postModel?.groupId.toString() != ''
                        ? 'Group Post'
                        : postModel?.username ?? 'Stella Andrew',
                    style: const TextStyle(
                        fontFamily: Constants.workSansMedium,
                        color: Constants.colorSecondary),
                  ),
                  Text(
                    postModel == null
                        ? ' June 30, 2023'
                        : DateFormat('MMMM dd, yyyy')
                            .format(postModel?.created ?? DateTime.now()),
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
            postModel?.text ?? 'Unleashing pure happiness, one wag at a time.',
            style: const TextStyle(
                fontFamily: Constants.workSansRegular,
                color: Constants.colorSecondary),
          ),
          const SizedBox(height: 10),
          (postModel?.imagePath.toString() == 'null' ||
                  postModel?.imagePath.toString() == '')
              ? Image.asset('assets/2.png')
              : GestureDetector(
                  onTap: () =>
                      Get.toNamed(PostDetailScreen.route, arguments: postModel),
                  child: CachedNetworkImage(
                      imageUrl: postModel?.imagePath ?? '',
                      placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator.adaptive()))),
          const SizedBox(height: 10),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  onLikedTap.call();
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
                '${postModel?.totalLikes ?? 0} Likes',
                style: const TextStyle(
                    fontFamily: Constants.workSansLight,
                    color: Constants.colorSecondary),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () =>
                    Get.toNamed(PostDetailScreen.route, arguments: postModel),
                child: Text(
                  '${postModel?.commentsCount ?? 0} comments',
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

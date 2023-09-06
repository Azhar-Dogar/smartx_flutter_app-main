import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartx_flutter_app/common/app_button.dart';
import 'package:smartx_flutter_app/extension/context_extension.dart';
import 'package:smartx_flutter_app/helper/meta_data.dart';
import 'package:smartx_flutter_app/helper/shared_preference_helpert.dart';
import 'package:smartx_flutter_app/ui/add-post/add_post_screen.dart';
import 'package:smartx_flutter_app/ui/auth/dog-profile/dog_profile_screen.dart';
import 'package:smartx_flutter_app/ui/auth/user-profile/user_profile_screen.dart';
import 'package:smartx_flutter_app/ui/group-detail/group_detail_screen.dart';
import 'package:smartx_flutter_app/ui/post-detail/post_detail_screen.dart';
import 'package:smartx_flutter_app/ui/user-detail/user_detail_controller.dart';
import 'package:smartx_flutter_app/util/constants.dart';

import '../../backend/server_response.dart';
import '../../models/dog_model.dart';
import '../../models/post_model.dart';
import '../../models/user_model.dart';

class UserDetailScreen extends StatelessWidget {
  static const String route = '/user_detai_screen_route';

  const UserDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = context.screenSize;
    final controller = Get.find<UserDetailController>();
    String userImagePath = "";
    return SafeArea(
      bottom: false,
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          floatingActionButton: GetX<UserDetailController>(
            builder: (con) {
              if (con.tabIndex.value == 2) {
                return (controller.mapEntry.key as bool)
                    ? FloatingActionButton(
                        backgroundColor: Constants.colorOnSurface,
                        onPressed: () async {
                          final res = await Get.toNamed(DogProfileScreen.route,
                              arguments: const MapEntry(false, null));
                          if (res is DogModel) {
                            Get.find<UserDetailController>().updateTempDog(res);
                          }
                        },
                        child: const Icon(Icons.add,
                            color: Constants.colorBackground))
                    : const SizedBox();
              } else {
                return const SizedBox();
              }
            },
          ),
          backgroundColor: Constants.colorSecondaryVariant,
          body:  StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("user")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (_, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                }
                UserModel user =
                UserModel.fromJson(snapshot.data!.data()!);
                // final user = controller.mapEntry.value as UserModel;
                return Column(
              children: [
                Container(
                  color: Constants.colorSecondary,
                  padding: const EdgeInsets.only(top: 20.0, left: 30, right: 30),
                  child: Column(
                    children: [
                      InkWell(
                          onTap: () => Get.back(),
                          child: const Row(children: [
                            Icon(Icons.arrow_back,
                                color: Constants.colorOnBackground),
                            Text('Back',
                                style: TextStyle(
                                    fontFamily: Constants.workSansRegular,
                                    color: Constants.colorOnBackground,
                                    fontSize: 16))
                          ])),
                      Column(
                              children: [
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    (user.imagePath.toString() == 'null' ||
                                            user.imagePath.toString() == '')
                                        ? Image.asset('assets/3.png', height: 60)
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: CachedNetworkImage(
                                                imageUrl: user.imagePath ?? '',
                                                height: 60,
                                                width: 60,
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) =>
                                                    const Center(
                                                        child:
                                                            CircularProgressIndicator
                                                                .adaptive())),
                                          ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${user.firstName} ${user.lastName}',
                                          style: const TextStyle(
                                              color: Constants.colorOnBackground,
                                              fontFamily: Constants.workSansBold,
                                              fontSize: 20),
                                        ),
                                        Text(
                                          user.email ?? 'email@rmail.com',
                                          style: const TextStyle(
                                              color: Constants.colorOnBackground,
                                              fontFamily: Constants.workSansLight,
                                              fontSize: 12),
                                        ),
                                        const Text(
                                          '+1234567890',
                                          style: TextStyle(
                                              color: Constants.colorOnBackground,
                                              fontFamily: Constants.workSansLight,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ))
                                  ],
                                ),
                                SizedBox(
                                    height: 55,
                                    width: size.width,
                                    child: AppButton(
                                        onClick: () {
                                          if (controller.mapEntry.key as bool) {
                                            Get.toNamed(UserProfileScreen.route,
                                                arguments: MapEntry(false, user));
                                          }
                                        },
                                        text: (controller.mapEntry.key as bool)
                                            ? 'Edit Profile'
                                            : 'Following',
                                        fontFamily: Constants.workSansRegular,
                                        textColor: Constants.colorOnSurface,
                                        borderRadius: 10.0,
                                        fontSize: 16,
                                        color: Constants.colorOnBackground)),
                                const SizedBox(height: 20),
                              ],
                            )

                    ],
                  ),
          ),

                Expanded(
                  child: Column(
                    children: [
                      Container(
                        color: Constants.colorOnBackground,
                        child: TabBar(
                          indicatorColor: Constants.colorOnSurface,
                          onTap: (i) {
                            controller.tabIndex(i);
                          },
                          indicatorSize: TabBarIndicatorSize.tab,
                          labelColor: Constants.colorOnSurface,
                          unselectedLabelColor: Constants.colorOnSurface,
                          tabs: const [
                            Tab(text: "Activities"),
                            Tab(text: 'Achievements'),
                            Tab(text: 'Dogs'),
                          ],
                        ),
                      ),
                      Expanded(
                          child: TabBarView(
                            children: [
                              UserFeedTabScreen(

                                canPost: true,
                                userImage: user.imagePath??"",
                              ),
                              SizedBox(),
                              DogTabScreen()
                            ],
                          ))
                    ],
                  ),
                )
              // FutureBuilder<UserModel?>(
              //     future: SharedPreferenceHelper.instance.user,
              //     builder: (_, snapshot) {
              //       if (snapshot.hasData) {
              //         print("second path");
              //         print(userImagePath);
              //         return Expanded(
              //           child: Column(
              //             children: [
              //               Container(
              //                 color: Constants.colorOnBackground,
              //                 child: TabBar(
              //                   indicatorColor: Constants.colorOnSurface,
              //                   onTap: (i) {
              //                     controller.tabIndex(i);
              //                   },
              //                   indicatorSize: TabBarIndicatorSize.tab,
              //                   labelColor: Constants.colorOnSurface,
              //                   unselectedLabelColor: Constants.colorOnSurface,
              //                   tabs: const [
              //                     Tab(text: "Activities"),
              //                     Tab(text: 'Achievements'),
              //                     Tab(text: 'Dogs'),
              //                   ],
              //                 ),
              //               ),
              //               Expanded(
              //                   child: TabBarView(
              //                 children: [
              //                   UserFeedTabScreen(
              //
              //                     canPost: true,
              //                     userImage: userImagePath,
              //                   ),
              //                   SizedBox(),
              //                   DogTabScreen()
              //                 ],
              //               ))
              //             ],
              //           ),
              //         );
              //       }
              //       return const CircularProgressIndicator();
              //     }),
            ],
          );}
        ),
      ),
    ));
  }
}

class DogTabScreen extends StatelessWidget {
  const DogTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<UserDetailController>(
        autoRemove: false,
        builder: (con) {
          final event = con.userDogEvents.value;
          print(event);
          if (event is Loading) {
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator.adaptive(),
              ],
            );
          }
          if (event is Empty) {
            return const Center(child: Text('no dog profile added yet'));
          }
          if (event is Data) {
            final list = event.data as List<DogModel>;
            return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                itemCount: list.length,
                shrinkWrap: true,
                itemBuilder: (_, i) {
                  return SingleDogWidget(dogModel: list[i]);
                });
          }
          return const SizedBox();
        });
  }
}

class SingleDogWidget extends StatelessWidget {
  const SingleDogWidget({required this.dogModel, super.key});

  final DogModel dogModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
      decoration: BoxDecoration(
          color: Constants.colorOnBackground,
          borderRadius: BorderRadius.circular(10)),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border:
                      Border.all(color: Constants.colorSecondary, width: 2)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                    imageUrl: dogModel.imagePath ?? '',
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                    errorWidget: (_, s, d) => const Icon(Icons.error),
                    placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator.adaptive())),
              ),

              // Image.asset('assets/1.png', fit: BoxFit.cover, height: 80)
            ),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Text(dogModel.name,
                      style: const TextStyle(
                          fontFamily: Constants.workSansBold,
                          fontSize: 24,
                          color: Constants.colorSecondary)),
                  const Text('Mid size',
                      style: TextStyle(
                          fontFamily: Constants.workSansLight,
                          color: Constants.colorOnSurface))
                ]),
            const Spacer(),
            GestureDetector(
                onTap: () => Get.toNamed(DogProfileScreen.route,
                    arguments: MapEntry(false, dogModel)),
                child: const Icon(Icons.edit_outlined,
                    color: Constants.colorOnSurface))
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Wrap(direction: Axis.horizontal, children: [
              if (dogModel.isGoodWithKids)
                const _SingleRow(title: 'Good with kids'),
              if (dogModel.isGoodWithKids) const SizedBox(width: 5),
              if (dogModel.isGoodWithDogs)
                const _SingleRow(title: 'Good with Dogs'),
              if (dogModel.isGoodWithDogs) const SizedBox(width: 5),
              if (dogModel.isNeutered) const _SingleRow(title: 'Neutered')
            ]))
      ]),
    );
  }
}

class _SingleRow extends StatelessWidget {
  const _SingleRow({
    required this.title,
    super.key,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 5),
          height: 10,
          width: 10,
          decoration: const BoxDecoration(
              shape: BoxShape.circle, color: Constants.colorOnSurface),
        ),
        Text(
          title,
          style: const TextStyle(
              fontFamily: Constants.workSansRegular,
              color: Constants.colorSecondary),
        )
      ],
    );
  }
}

class UserFeedTabScreen extends StatelessWidget {
  final bool canPost;
  final Color color;
  String userImage;
  UserFeedTabScreen(
      {this.canPost = true,
      required this.userImage,
      this.color = Constants.colorSecondary,
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
                    child: (userImage == "")
                        ? Image.asset(
                            "assets/3.png",
                            height: 25,
                          )
                        : CircleAvatar(
                            radius: 15,
                            backgroundImage: NetworkImage(userImage),
                          )),
                Expanded(
                    child: InkWell(
                        onTap: () async {
                          final res = await Get.toNamed(AddPostScreen.route);

                          if (res is PostModel) {
                            Get.find<UserDetailController>()
                                .updateTempPost(res);
                          }
                        },
                        child: Text('Have Something to share?',
                            style: TextStyle(
                                fontFamily: Constants.workSansLight,
                                color: color))))
              ])),
        GetX<UserDetailController>(
            autoRemove: false,
            builder: (con) {
              final event = con.userPostEvents.value;
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
                return const Expanded(
                  child: Center(
                    child: Text("No Post Yet",style:TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                  ),
                );
              }
              if (event is Data) {
                final list = event.data as List<PostModel>;
                return Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      itemCount: list.length,
                      // shrinkWrap: true,
                      itemBuilder: (_, i) {
                        final isLiked = list[i].likedUsers.contains(
                            FirebaseAuth.instance.currentUser?.uid);
                        return SinglePostWidget(
                          userImagePath: userImage,
                          postModel: list[i],
                          isLiked: isLiked,
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

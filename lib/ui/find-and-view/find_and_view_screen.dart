import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smartx_flutter_app/common/app_text_field.dart';
import 'package:smartx_flutter_app/helper/meta_data.dart';
import 'package:smartx_flutter_app/ui/find-and-view/find_view_controller.dart';
import 'package:smartx_flutter_app/util/constants.dart';

import '../../models/user_model.dart';
import '../user-detail/user_detail_screen.dart';

class FindAndViewScreen extends StatefulWidget {
  static const String route = '/find_and_view_route';

  const FindAndViewScreen({super.key});

  @override
  State<FindAndViewScreen> createState() => _FindAndViewScreenState();
}

class _FindAndViewScreenState extends State<FindAndViewScreen> {
  String searchValue = "";
  TextEditingController search = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FindAndViewController>();
    List<UserModel> users = [];
    List<UserModel> searchUsers = [];
    return Scaffold(
      backgroundColor: Constants.colorSecondaryVariant,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Constants.colorSecondary,
        // titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: InkWell(
          onTap: () => Get.back(),
          child: const Row(
            children: [
              Icon(Icons.arrow_back, color: Constants.colorOnBackground),
              Text(
                'Back',
                style: TextStyle(
                    fontFamily: Constants.workSansRegular,
                    color: Constants.colorOnBackground,
                    fontSize: 16),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
        child: Column(
          children: [
            AppTextField(
                prefixIcon: const Icon(Icons.search),
                hint: 'Search',
                controller: search,
                onChanged: (v) {
                  setState(() {
                    searchValue = v;
                  });
                },
                textInputType: TextInputType.text,
                radius: 10,
                isError: false,
                color: Colors.white),
            const SizedBox(height: 10),
            Expanded(child: GetX<FindAndViewController>(
              builder: (_) {
                final state = controller.userDataEvent.value;
                if (state is Loading) {
                  return const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator.adaptive(),
                    ],
                  );
                }
                if (state is Empty) {
                  return const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('No users found..'),
                    ],
                  );
                }
                if (state is Data) {
                  users = state.data as List<UserModel>;
                  if (searchValue != "") {
                    searchUsers = users
                        .where((element) => element.firstName
                            .toLowerCase()
                            .contains(searchValue))
                        .toList();
                  }
                  List finalList = [];
                  if (searchUsers.isNotEmpty) {
                    finalList = [];
                    finalList = searchUsers;
                  } else if (searchValue == "") {
                    finalList = [];
                    finalList = users;
                  }
                  if (finalList.isEmpty && searchValue != "") {
                    return const Center(child: Text("No user Found"));
                  }
                  return ListView.builder(
                      itemCount: finalList.length,
                      itemBuilder: (_, i) {
                        return _SingleRowCard(user: finalList[i], index: i);
                      });
                }

                return const SizedBox();
              },
            ))

            // _SingleRowCard(),
          ],
        ),
      ),
    );
  }
}

class _SingleRowCard extends StatelessWidget {
  final UserModel user;
  final int index;

  const _SingleRowCard({
    required this.user,
    required this.index,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FindAndViewController>();
    RegExp regExp = RegExp(r'seconds=(\d+), nanoseconds=(\d+)');
    Match match = regExp.firstMatch(user.created!) as Match;
    int seconds = int.parse(match.group(1)!);
    int nanoseconds = int.parse(match.group(2)!);
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(seconds * 1000, isUtc: true)
            .add(Duration(microseconds: nanoseconds ~/ 1000));
    String formattedDate = DateFormat.yMMMMd().format(dateTime);
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            controller.updateIndex(index);
            Get.toNamed(UserDetailScreen.route,
                arguments: MapEntry(false, user));
          },
          child: Row(
            children: [
              Container(
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          color: Constants.colorOnSurface, width: 2)),
                  child: (user.imagePath.toString() == '')
                      ? Image.asset('assets/5.png', height: 50)
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: CachedNetworkImage(
                              imageUrl: user.imagePath ?? '',
                              height: 50,
                              width: 50))),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(user.firstName,
                    style: const TextStyle(
                        fontFamily: Constants.workSansMedium,
                        fontSize: 16,
                        color: Constants.colorSecondary)),
                Text(formattedDate,
                    style: const TextStyle(
                        fontFamily: Constants.workSansLight,
                        color: Constants.colorSecondary))
              ]),
              const Spacer(),
              GestureDetector(
                onTap: () => controller.followUnfollowUser(index, user),
                child: Text(user.isFollowing ? 'Following' : 'Follow',
                    style: TextStyle(
                        fontFamily: Constants.workSansMedium,
                        fontSize: 16,
                        color: user.isFollowing
                            ? Constants.colorTextField
                            : Constants.colorOnSurface)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Divider(),
      ],
    );
  }
}

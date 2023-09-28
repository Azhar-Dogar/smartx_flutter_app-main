import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:smartx_flutter_app/backend/server_response.dart';
import 'package:smartx_flutter_app/helper/firebase_auth_helper.dart';
import 'package:smartx_flutter_app/helper/meta_data.dart';
import 'package:smartx_flutter_app/helper/shared_preference_helpert.dart';
import 'package:smartx_flutter_app/models/quest_model.dart';
import 'package:smartx_flutter_app/ui/main/navItems/add_screen.dart';
import 'package:smartx_flutter_app/ui/main/navItems/groups_screen.dart';
import 'package:smartx_flutter_app/ui/main/navItems/home_screen.dart';
import 'package:smartx_flutter_app/ui/main/navItems/location_screen.dart';
import 'package:smartx_flutter_app/ui/main/navItems/profile_screen.dart';

import '../../helper/firestore_database_helper.dart';
import '../../models/group_model.dart';
import '../../models/post_model.dart';
import '../../models/user_model.dart';
import '../map-walk/map_walk_screen.dart';

class MainScreenController extends GetxController {
  UserModel? user;
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late final FirebaseMessaging _messaging;
  final FirestoreDatabaseHelper _firestoreDatabaseHelper =
      FirestoreDatabaseHelper.instance();
  final bottomNavigationMap = <PageStorageKey<String>, Widget>{};
  final GlobalKey globalKey = GlobalKey(debugLabel: 'btm_app_bar');
  List posts = [].obs;
  RxList<QuestModel> userQuests = <QuestModel>[].obs;

  ///INDEXED STACK SETUP
  static const _mainAddNavigationItemScreenKey =
      PageStorageKey(MapWalkScreen.key_title);
  static const _mainhomeNavigationItemScreenKey =
      PageStorageKey(HomeScreen.key_title);
  static const _mainGroupsNavigationItemScreenKey =
      PageStorageKey(GroupsScreen.key_title);
  static const _mainLocationNavigationItemScreenKey =
      PageStorageKey(LocationScreen.key_title);
  static const _mainProfileNavigationItemScreenKey =
      PageStorageKey(ProfileScreen.key_title);
  final Map<PageStorageKey<String>, Widget> mainNavigationScreenMap = {};

  MainScreenController() {
    initData();
    mainNavigationScreenMap[_mainAddNavigationItemScreenKey] = const MapWalkScreen();
    mainNavigationScreenMap[_mainhomeNavigationItemScreenKey] =
        const HomeScreen(
      key: _mainhomeNavigationItemScreenKey,
    );
    mainNavigationScreenMap[_mainGroupsNavigationItemScreenKey] =
        const SizedBox();
    mainNavigationScreenMap[_mainLocationNavigationItemScreenKey] =
        const SizedBox();
    mainNavigationScreenMap[_mainProfileNavigationItemScreenKey] =
        const SizedBox();
  }

  initData() async {
    channel = const AndroidNotificationChannel(
        'notifications', // id
        'High Importance Notifications', // title
        description: 'This channel is used for important notifications.',
        enableVibration: true,
        playSound: true,
        importance: Importance.high);

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    registerNotification();
    user = await SharedPreferenceHelper.instance.user;
    await Future.wait([getAllPost(), getGroups()]);

    print('---->user ${user.toString()}');
  }

  void handleNavigationIndex(int index) {
    final PageStorageKey<String> key =
        mainNavigationScreenMap.keys.elementAt(index);
    final navigationItem = mainNavigationScreenMap[key];
    if (navigationItem == null || navigationItem is SizedBox) {
      mainNavigationScreenMap[key] = _navigationItemIndex(index);
    }
    indexState(index);
  }

  Widget _navigationItemIndex(int index) {
    switch (index) {
      case 0:
        return const MapWalkScreen(key: _mainAddNavigationItemScreenKey);
      case 1:
        return const HomeScreen(key: _mainhomeNavigationItemScreenKey);
      case 2:
        return const GroupsScreen(key: _mainGroupsNavigationItemScreenKey);
      case 3:
        return const LocationScreen(key: _mainLocationNavigationItemScreenKey);
      case 4:
        return const ProfileScreen(key: _mainProfileNavigationItemScreenKey);
      // case 4:
      //   return const MoreScreenTab(key: _mainMoreNavigationItemScreenKey);

      default:
        return const SizedBox();
    }
  }

  Rx<int> indexState = 1.obs;
  Rx<int> selectedSliderIndex = Rx(0);

  Rx<DataEvent> postDataEvent = Rx<DataEvent>(const Initial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Rx<bool> isLoadingMore = Rx<bool>(false);
  Rx<List<QueryDocumentSnapshot>> documentSnapshots =
      Rx<List<QueryDocumentSnapshot>>([]);
  Rx<DataEvent> groupsEvents = Rx<DataEvent>(const Initial());

  final int batchSize = 10; // Number of documents to fetch per page
 changeIndex(int val){
   indexState.value = val;
 }
  void loadMoreData() {
    if (isLoadingMore.value) return;

    isLoadingMore(true);

    final lastDocument = documentSnapshots.value.last;
    final lastDocumentIndex = int.parse(lastDocument.id);
  }
  static String uid = FirebaseAuth.instance.currentUser!.uid;
  Stream<QuerySnapshot<Map<String, dynamic>>> questStream =  FirebaseFirestore.instance
     .collection("quests")
     .where("users", arrayContains: uid)
     .snapshots();
  getUserQuest() {
    FirebaseFirestore.instance
        .collection("quests")
        .where("users", arrayContains: uid)
        .snapshots()
        .listen((event) {
          userQuests = <QuestModel>[].obs;
      event.docs.forEach((element) {
        userQuests.value.add(QuestModel.fromJson(element.data()));
      });
      print("these are quests");
      print(userQuests.value.length);
    });
  }

  Future<void> getGroups() async {
    groupsEvents(const Loading());
    try {
      final res = await FirestoreDatabaseHelper.instance().getGroups();
      if (res == null) {
        groupsEvents(const Empty(message: ''));
        return;
      }
      if (res.isEmpty) {
        groupsEvents(const Empty(message: ''));
        return;
      }

      if (res == null) {
        groupsEvents(Error(exception: Exception()));
        return;
      }
      final userid = FirebaseAuthHelper.instance().currentUser?.uid ?? '';

      final list = res.map((e) {
        final isJoined = e.users.contains(userid);
        return e.copyWith(isJoined: isJoined);
      }).toList();

      groupsEvents(Data(data: list));
    } catch (_) {
      groupsEvents(Error(exception: Exception()));
    }
  }

  joinGroup(index, GroupModel group) async {
    final appUser = await SharedPreferenceHelper.instance.user;
    final state = groupsEvents.value;
    if (state is Data) {
      final list = state.data as List<GroupModel>;
      list[index] = list[index].copyWith(isJoined: !list[index].isJoined);
      groupsEvents(Data(data: list));

      if (group.isJoined) {
      } else {
        group.users.add(appUser?.id ?? '');
        final listUser = group.users;
        await _firestoreDatabaseHelper
            .updateGroupJoined(group.copyWith(users: listUser));
      }
    }
  }

  Stream<QuerySnapshot> getPaginatedData(
      int startAfterIndex, List<String> ids) {
    Query query = _firestore
        .collection('posts')
        .where('userid', whereIn: ids)
        .orderBy('created');

    final startAfterDoc =
        _firestore.collection('posts').doc(startAfterIndex.toString());
    query =
        query.startAfterDocument(startAfterDoc as DocumentSnapshot<Object?>);

    query = query.limit(batchSize);

    return query.snapshots();
  }

// Implement _toggleLike function
  void toggleLike(PostModel post, bool isLiked) async {
    final user = FirebaseAuth.instance.currentUser;

    List<String> likes = post.likedUsers;

    if (isLiked) {
      likes.remove(user?.uid);
    } else {
      likes.add(user!.uid);
    }

    await FirebaseFirestore.instance.collection('posts').doc(post.id).update({
      'likedUsers': likes,
      'totalLikes': likes.length,
    });
  }

  Future<void> getAllPost() async {
    postDataEvent(const Loading());
    try {
      final res = await _firestoreDatabaseHelper.getFollowingUserIds();

      if (res.isEmpty) {
        postDataEvent(const Empty(message: 'No Post yet'));
        return;
      }

      postDataEvent(Data(data: res));
    } catch (_) {
      postDataEvent(Error(exception: Exception()));
    }
  }

  var imageUrlList = [
    "https://cdn.pixabay.com/photo/2016/12/13/05/15/puppy-1903313_1280.jpg",
    "https://cdn.pixabay.com/photo/2016/02/18/18/37/puppy-1207816_1280.jpg",
    "https://cdn.pixabay.com/photo/2017/09/25/13/14/dog-2785077_1280.jpg",
    "https://cdn.pixabay.com/photo/2016/01/29/20/54/dog-1168663_1280.jpg"
  ];

  Future<void> _showNotification(RemoteNotification room) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        room.hashCode, room.title, room.body, notificationDetails,
        payload: jsonEncode(room));
  }

  void registerNotification() async {
    _messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);
    _messaging.getToken().then((token) async {
      final user = await SharedPreferenceHelper.instance.user;
      if (user == null) return;
      _firestoreDatabaseHelper.updateUser(user.copyWith(fcmToken: token));
      print("token is $token");
    });

    _messaging.setForegroundNotificationPresentationOptions(
        alert: true, badge: false, sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        RemoteNotification? notification = message.notification;

        _showNotification(notification!);
      });

      RemoteMessage? initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();

      if (initialMessage != null) {}

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});
      //
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      final DarwinInitializationSettings initializationSettingsDarwin =
          DarwinInitializationSettings(
        defaultPresentAlert: true,
        defaultPresentSound: true,
        onDidReceiveLocalNotification:
            (int? id, String? title, String? body, String? payload) async {
          Map<String, dynamic> message = jsonDecode(payload!);
        },
      );
      final InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
      );

      await flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onDidReceiveNotificationResponse: onSelectNotification,
          onDidReceiveBackgroundNotificationResponse: onSelectNotification);
    } else {
      print('message declined or has not accepted permission');
    }
  }

  static onSelectNotification(
      NotificationResponse notificationResponse) async {}
}

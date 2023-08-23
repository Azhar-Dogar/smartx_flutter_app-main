import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:smartx_flutter_app/helper/shared_preference_helpert.dart';
import 'package:smartx_flutter_app/notification_screen.dart';
import 'package:smartx_flutter_app/ui/add-post/add_post_controller.dart';
import 'package:smartx_flutter_app/ui/add-post/add_post_screen.dart';
import 'package:smartx_flutter_app/ui/auth/dog-profile/dog_profile_controller.dart';
import 'package:smartx_flutter_app/ui/auth/login_controller.dart';
import 'package:smartx_flutter_app/ui/auth/login_screen.dart';
import 'package:smartx_flutter_app/ui/auth/password_reset_controller.dart';
import 'package:smartx_flutter_app/ui/auth/password_reset_screen.dart';
import 'package:smartx_flutter_app/ui/auth/sign-up/signup_controller.dart';
import 'package:smartx_flutter_app/ui/auth/sign-up/signup_screen.dart';
import 'package:smartx_flutter_app/ui/auth/user-profile/user_profile_controller.dart';
import 'package:smartx_flutter_app/ui/auth/user-profile/user_profile_screen.dart';
import 'package:smartx_flutter_app/ui/find-and-view/find_and_view_screen.dart';
import 'package:smartx_flutter_app/ui/find-and-view/find_view_controller.dart';
import 'package:smartx_flutter_app/ui/get_started_screen.dart';
import 'package:smartx_flutter_app/ui/group-detail/group_detail_controller.dart';
import 'package:smartx_flutter_app/ui/group-detail/group_detail_screen.dart';
import 'package:smartx_flutter_app/ui/main/main_screen.dart';
import 'package:smartx_flutter_app/ui/main/main_screen_controller.dart';
import 'package:smartx_flutter_app/ui/map-walk/map_walk_controller.dart';
import 'package:smartx_flutter_app/ui/map-walk/map_walk_screen.dart';
import 'package:smartx_flutter_app/ui/map-walk/stop_walk_screen.dart';
import 'package:smartx_flutter_app/ui/post-detail/post_detail_controller.dart';
import 'package:smartx_flutter_app/ui/post-detail/post_detail_screen.dart';
import 'package:smartx_flutter_app/ui/user-detail/user_detail_controller.dart';
import 'package:smartx_flutter_app/ui/user-detail/user_detail_screen.dart';
import 'package:smartx_flutter_app/ui/welcome_screen.dart';

import 'firebase_options.dart';
import 'ui/auth/dog-profile/dog_profile_screen.dart';

late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
late final FirebaseMessaging _messaging;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
        'notifications', // id
        'High Importance Notifications', // title
        description: 'This channel is used for important notifications.',
        enableVibration: true,
        playSound: true,
        importance: Importance.high);
  }
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await SharedPreferenceHelper.initializeSharedPreferences();
  final SharedPreferenceHelper sharedPrefHelper =
      SharedPreferenceHelper.instance;
  bool isUserLogin = sharedPrefHelper.isUserLoggedIn;

  runApp(GetMaterialApp(
      title: 'Stroll App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true),
      getPages: _pages,
      initialRoute: isUserLogin ? MainScreen.route : WelcomeScreen.route));
}

final List<GetPage<dynamic>> _pages = [
  GetPage(
      name: LoginScreen.route,
      page: () =>  LoginScreen(),
      binding: BindingsBuilder(() {
        return Get.lazyPut(() => LoginController());
      })),
  GetPage(
      name: PasswordResetScreen.route,
      page: () => const PasswordResetScreen(),
      binding: BindingsBuilder(() {
        return Get.lazyPut(() => PasswordResetController());
      })),
  GetPage(
      name: SignUpScreen.route,
      page: () => const SignUpScreen(),
      binding: BindingsBuilder(() {
        return Get.lazyPut(() => SignUpController());
      })),
  GetPage(
      name: UserProfileScreen.route,
      page: () => const UserProfileScreen(),
      binding: BindingsBuilder(() {
        final args = Get.arguments;
        if (args is MapEntry) {
          return Get.lazyPut(() =>
              UserProfileController(isFromStart: args.key, user: args.value));
        } else {
          return Get.lazyPut(() => UserProfileController());
        }
      })),
  GetPage(
      name: MainScreen.route,
      page: () => const MainScreen(),
      binding: BindingsBuilder(() {
        return Get.lazyPut(() => MainScreenController());
      })),
  GetPage(
      name: DogProfileScreen.route,
      page: () => const DogProfileScreen(),
      binding: BindingsBuilder(() {
        final args = Get.arguments;
        if (args is MapEntry) {
          return Get.lazyPut(() => DogProfileController(
              dogModel: args.value, isFromStart: args.key));
        }
        return Get.lazyPut(() => DogProfileController(dogModel: args));
      })),
  GetPage(
      name: GroupDetailScreen.route,
      page: () => const GroupDetailScreen(),
      binding: BindingsBuilder(() {
        final args = Get.arguments;
        return Get.lazyPut(() => GroupDetailController(groupModel: args));
      })),
  GetPage(
      name: MapWalkScreen.route,
      page: () => const MapWalkScreen(),
      binding: BindingsBuilder(() {
        return Get.lazyPut(() => MapWalkController());
      })),
  GetPage(
      name: StopWalkScreen.route,
      page: () => const StopWalkScreen(),
      binding: BindingsBuilder(() {
        return Get.lazyPut(() => MapWalkController());
      })),
  GetPage(
      name: AddPostScreen.route,
      page: () {
        return AddPostScreen();
      },
      binding: BindingsBuilder(() {
        final res = Get.arguments;

        return Get.lazyPut(() => AddPostController(groupId: res));
      })),
  GetPage(
      name: PostDetailScreen.route,
      page: () => const PostDetailScreen(),
      binding: BindingsBuilder(() {
        final post = Get.arguments;
        return Get.lazyPut(() => PostDetailController(postModel: post));
      })),
  GetPage(
      name: UserDetailScreen.route,
      page: () {
        return const UserDetailScreen();
      },
      binding: BindingsBuilder(() {
        final args = Get.arguments;
        return Get.lazyPut(
            () => UserDetailController(mapEntry: args as MapEntry));
      })),
  GetPage(name: WelcomeScreen.route, page: () => const WelcomeScreen()),
  GetPage(
      name: NotificationScreen.route, page: () => const NotificationScreen()),
  GetPage(name: GetStartedScreen.route, page: () => const GetStartedScreen()),
  GetPage(
      name: FindAndViewScreen.route,
      page: () => const FindAndViewScreen(),
      binding: BindingsBuilder(() {
        return Get.lazyPut(() => FindAndViewController());
      })),
];

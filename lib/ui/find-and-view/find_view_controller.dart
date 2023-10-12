import 'package:get/get.dart';
import 'package:smartx_flutter_app/backend/shared_web_service.dart';
import 'package:smartx_flutter_app/helper/firestore_database_helper.dart';
import 'package:smartx_flutter_app/helper/meta_data.dart';
import 'package:smartx_flutter_app/helper/shared_preference_helpert.dart';

import '../../models/user_model.dart';

class FindAndViewController extends GetxController {
  Rx<DataEvent> userDataEvent = Rx<DataEvent>(const Initial());
  RxBool isFollow = RxBool(false);
  RxInt index = 0.obs;
  updateIndex(int _index){
    index.value = _index;
  }
  final FirestoreDatabaseHelper _firestoreDatabaseHelper =
      FirestoreDatabaseHelper.instance();

  FindAndViewController() {
    initData();
  }

  initData() async {
    userDataEvent(const Loading());

    try {
      final user = await SharedPreferenceHelper.instance.user;
      final res = await _firestoreDatabaseHelper.getAllUsers(user?.id ?? '');
      if (res == null) {
        userDataEvent(Error(exception: Exception()));
        return;
      }

      if (res.isEmpty) {
        userDataEvent(const Empty(message: ''));
        return;
      }
      res.removeWhere((s) => s.id == (user?.id ?? ''));
      final updatedList = await Future.wait(res.map((e) async {
        final isFollow =
            await _firestoreDatabaseHelper.checkIsFollow(user?.id ?? '', e.id);
        return e.copyWith(isFollowing: isFollow);
      }));
      userDataEvent(Data(data: updatedList));
    } catch (_) {
      userDataEvent(Error(exception: Exception()));
    }
  }

  followUnfollowUser(index, UserModel user) async {
    final appUser = await SharedPreferenceHelper.instance.user;

    final state = userDataEvent.value;
    if (state is Data) {
      final list = state.data as List<UserModel>;
      list[index] = list[index].copyWith(isFollowing: !list[index].isFollowing);
      userDataEvent(Data(data: list));

      if (user.isFollowing) {
        await _firestoreDatabaseHelper.unFollowUser(appUser?.id ?? '', user.id);
      } else {
        await _firestoreDatabaseHelper.followUserID(appUser?.id ?? '', user.id);
        if (user.fcmToken.isEmpty) return;

        SharedWebService.instance().sendNotification('', {
          "to": user.fcmToken,
          "notification": {
            "title": "SmartX",
            "body": "${appUser?.firstName ?? ''} is Started following you."
          },
          'priority': 'high',
        });
      }
    }
  }
}

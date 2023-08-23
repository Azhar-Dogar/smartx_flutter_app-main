import 'package:get/get.dart';
import 'package:smartx_flutter_app/backend/server_response.dart';
import 'package:smartx_flutter_app/helper/firebase_auth_helper.dart';
import 'package:smartx_flutter_app/helper/firestore_database_helper.dart';
import 'package:smartx_flutter_app/helper/meta_data.dart';

class UserDetailController extends GetxController {
  Rx<DataEvent> userPostEvents = Rx<DataEvent>(const Initial());
  Rx<DataEvent> userDogEvents = Rx<DataEvent>(const Initial());
  final MapEntry mapEntry;

  UserDetailController({required this.mapEntry}) {
    getUserPosts();
    getUserDogs();
  }

  Rx<int> tabIndex = Rx<int>(0);

  updateTempPost(PostModel model) {
    if (userPostEvents.value is Data) {
      final list = (userPostEvents.value as Data).data as List<PostModel>;
      list.insert(0, model);
      userPostEvents(Data(data: list));
    } else {
      userPostEvents(Data(data: [model]));
    }
  }

  updateTempDog(DogModel model) {
    if (userDogEvents.value is Data) {
      final list = (userDogEvents.value as Data).data as List<DogModel>;
      list.insert(0, model);
      userDogEvents(Data(data: list));
    } else {
      userDogEvents(Data(data: [model]));
    }
  }

  getUserPosts() async {
    userPostEvents(const Loading());
    try {
      final res = await FirestoreDatabaseHelper.instance()
          .getUserPosts((mapEntry.value as UserModel).id);
      if (res == null) {
        userPostEvents(const Empty(message: ''));
        return;
      }
      if (res.isEmpty) {
        userPostEvents(const Empty(message: ''));
        return;
      }
      userPostEvents(Data(data: res));
    } catch (_) {
      userPostEvents(Error(exception: Exception()));
    }
  }

  getUserDogs() async {
    userDogEvents(const Loading());
    try {
      final res = await FirestoreDatabaseHelper.instance()
          .getUserDogs((mapEntry.value as UserModel).id);
      if (res == null) {
        userDogEvents(const Empty(message: ''));
        return;
      }
      if (res.isEmpty) {
        userDogEvents(const Empty(message: ''));
        return;
      }
      userDogEvents(Data(data: res));
    } catch (_) {
      userDogEvents(Error(exception: Exception()));
    }
  }
}

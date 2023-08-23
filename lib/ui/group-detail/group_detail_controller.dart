import 'package:get/get.dart';
import 'package:smartx_flutter_app/backend/server_response.dart';
import 'package:smartx_flutter_app/helper/firestore_database_helper.dart';
import 'package:smartx_flutter_app/helper/meta_data.dart';

class GroupDetailController extends GetxController {
  final GroupModel groupModel;
  Rx<DataEvent> groupPostEvents = Rx<DataEvent>(const Initial());

  GroupDetailController({required this.groupModel}){
    getGroupPosts();
  }


  updateTempPost(PostModel model) {
    if (groupPostEvents.value is Data) {
      final list = (groupPostEvents.value as Data).data as List<PostModel>;
      list.insert(0, model);
      groupPostEvents(Data(data: list));
    } else {
      groupPostEvents(Data(data: [model]));
    }
  }

  getGroupPosts() async {
    groupPostEvents(const Loading());
    try {
      final res =
          await FirestoreDatabaseHelper.instance().getGroupPosts(groupModel.id);
      if (res == null) {
        groupPostEvents(const Empty(message: ''));
        return;
      }
      if (res.isEmpty) {
        groupPostEvents(const Empty(message: ''));
        return;
      }
      groupPostEvents(Data(data: res));
    } catch (_) {
      groupPostEvents(Error(exception: Exception()));
    }
  }
}

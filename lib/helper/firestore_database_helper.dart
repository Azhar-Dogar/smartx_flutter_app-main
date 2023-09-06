import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartx_flutter_app/backend/server_response.dart';
import 'package:smartx_flutter_app/models/notification_model.dart';

import '../models/dog_model.dart';
import '../models/group_model.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';

class FirestoreDatabaseHelper {
  static const String _USER = 'user';
  static const String _POSTS = 'posts';
  static const String _DOGS = 'dogs';
  static const String _GROUPS = 'groups';
  static const String _NOTIFICATIONS = 'notifications';
  static const String _USER_FOLLOWING = 'following';

  static FirestoreDatabaseHelper? _instance;

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final _timeoutDuration = const Duration(seconds: 15);

  FirestoreDatabaseHelper._() {
    if (_firebaseFirestore.settings.persistenceEnabled == null ||
        !_firebaseFirestore.settings.persistenceEnabled!) {
      _firebaseFirestore.settings = const Settings(persistenceEnabled: true);
    }
  }
    sendNotification(PostModel post)async{
    String uid = FirebaseAuth.instance.currentUser!.uid;
    var doc  = _firebaseFirestore.collection(_USER).doc(post.userid).collection(_NOTIFICATIONS).doc();
    await doc.set({
      "id": doc.id,
      "userId": uid,
      "postId": post.id,
      "dateTime" : DateTime.now(),
    });
   }
  static FirestoreDatabaseHelper instance() {
    _instance ??= FirestoreDatabaseHelper._();
    return _instance!;
  }
   
  Future<UserModel?> addUser(UserModel user) async {
    await _firebaseFirestore
        .collection(_USER)
        .doc(user.id)
        .set(user.toJson())
        .timeout(_timeoutDuration);
    return user.copyWith(id: user.id);
  }

  Future<PostModel?> addPost(PostModel post) async {
    String docId = _firebaseFirestore.collection(_POSTS).doc().id;

    await _firebaseFirestore
        .collection(_POSTS)
        .doc(docId)
        .set(post.copyWith(id: docId).toJson())
        .timeout(_timeoutDuration);
    return post.copyWith(id: post.id);
  }

  Future<DogModel?> addDogProfile(DogModel dog) async {
    String docId = _firebaseFirestore.collection(_POSTS).doc().id;

    await _firebaseFirestore
        .collection(_DOGS)
        .doc(docId)
        .set(dog.copyWith(id: docId).toJson())
        .timeout(_timeoutDuration);
    return dog.copyWith(id: dog.id);
  }

  Future<void> followUserID(appUser, userid) async {
    await _firebaseFirestore
        .collection(_USER)
        .doc(appUser)
        .collection(_USER_FOLLOWING)
        .doc(userid)
        .set({'id': userid}).timeout(_timeoutDuration);
  }

  Future<void> unFollowUser(String user, String otherUserId) async {
    await _firebaseFirestore
        .collection(_USER)
        .doc(user)
        .collection(_USER_FOLLOWING)
        .doc(otherUserId)
        .delete()
        .whenComplete(() => print('-----unFollowed------'));
  }

  Future<bool> checkIsFollow(String userId, String otherUserId) async {
    final res = await _firebaseFirestore
        .collection(_USER)
        .doc(userId)
        .collection(_USER_FOLLOWING)
        .doc(otherUserId)
        .get();
    return res.exists;
  }

  Future<UserModel?> getUser(String id) async {
    try {
      final documentReference = await _firebaseFirestore
          .collection(_USER)
          .doc(id)
          .get()
          .timeout(_timeoutDuration);
      if (documentReference.data() == null) return null;
      return UserModel.fromJson(documentReference.data()!);
    } catch (_) {
      return null;
    }
  }

  Future<String?> getUserToken(String id) async {
    try {
      final documentReference = await _firebaseFirestore
          .collection(_USER)
          .doc(id)
          .get()
          .timeout(_timeoutDuration);

      if (documentReference.data() == null) return null;
      return (documentReference.data() as Map<String, dynamic>)['fcmToken'];
    } catch (_) {
      return null;
    }
  }

  Future<List<String>> getFollowingUserIds() async {
    final currentUserID = FirebaseAuth.instance.currentUser?.uid;

    // Get a reference to the Firestore collection of posts
    final postCollection = FirebaseFirestore.instance.collection(_POSTS);

// Fetch posts from followed users
    final QuerySnapshot followingSnapshot = await FirebaseFirestore.instance
        .collection(_USER) // Replace with your user collection name
        .doc(currentUserID)
        .collection(_USER_FOLLOWING)
        .get();
    final List<String> documentIds =
        followingSnapshot.docs.map((doc) => doc.id).toList();
    return documentIds;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getALlPostt(documentIds) {
    return FirebaseFirestore.instance
        .collection("posts")
        .where('userid', whereIn: documentIds)
        .orderBy("created", descending: true)
        .snapshots(includeMetadataChanges: true);
  }

  Future<List<UserModel>?> getAllUsers(String id) async {
    final documentReference = await _firebaseFirestore
        .collection(_USER)
        .get()
        .timeout(_timeoutDuration);
    if (documentReference.docs.isEmpty) return null;
    return documentReference.docs.map((e) {
      final user = UserModel.fromJson(e.data());
      return user;
    }).toList();
  }

  Future<List<PostModel>?> getAllPosts() async {
    final documentReference = await _firebaseFirestore
        .collection(_POSTS)
        .get()
        .timeout(_timeoutDuration);
    if (documentReference.docs.isEmpty) return null;
    return documentReference.docs.map((e) {
      final post = PostModel.fromJson(e.data());
      return post;
    }).toList();
  }

  Future<List<PostModel>?> getUserPosts(id) async {
    final documentReference = await _firebaseFirestore
        .collection(_POSTS)
        .where('userid', isEqualTo: id).where('groupId', isEqualTo: "")
        .get()
        .timeout(_timeoutDuration);
    if (documentReference.docs.isEmpty) return null;
    return documentReference.docs.map((e) {
      final post = PostModel.fromJson(e.data());
      return post;
    }).toList();
  }

  Future<List<PostModel>?> getGroupPosts(id) async {
    final documentReference = await _firebaseFirestore
        .collection(_POSTS)
         .where('groupId', isEqualTo: id)
        .get()
        .timeout(_timeoutDuration);
    print("document");
    print(documentReference.docs.length);
    if (documentReference.docs.isEmpty) return null;
    return documentReference.docs.map((e) {
      final post = PostModel.fromJson(e.data());
      return post;
    }).toList();
  }

  Future<List<DogModel>?> getUserDogs(id) async {
    final documentReference = await _firebaseFirestore
        .collection(_DOGS)
        .where('userId', isEqualTo: id)
        .get()
        .timeout(_timeoutDuration);
    if (documentReference.docs.isEmpty) return null;
    return documentReference.docs.map((e) {
      final post = DogModel.fromJson(e.data());
      return post;
    }).toList();
  }

  Future<List<GroupModel>?> getGroups() async {
    final documentReference = await _firebaseFirestore
        .collection(_GROUPS)
        .get()
        .timeout(_timeoutDuration);
    if (documentReference.docs.isEmpty) return null;
    return documentReference.docs.map((e) {
      final post = GroupModel.fromMap(e.data());
      return post;
    }).toList();
  }

  Future<void> deleteUserData(String id) async {
    await _firebaseFirestore
        .collection(_USER)
        .doc(id)
        .delete()
        .timeout(_timeoutDuration);
  }

  Future<void> updateUser(UserModel user) => _firebaseFirestore
      .collection(_USER)
      .doc(user.id)
      .update(user.toWithoutDateJson())
      .timeout(_timeoutDuration);

  Future<void> updateGroupJoined(GroupModel group) => _firebaseFirestore
      .collection(_GROUPS)
      .doc(group.id)
      .update({'users': group.users}).timeout(_timeoutDuration);

  Future<void> updateDogProfile(DogModel dog) => _firebaseFirestore
      .collection(_DOGS)
      .doc(dog.id)
      .update(dog.toJson())
      .timeout(_timeoutDuration);

  Future<void> updateUserToken(UserModel user) => _firebaseFirestore
      .collection(_USER)
      .doc(user.id)
      .update(user.toJson())
      .timeout(_timeoutDuration);

  Future<void> emptyToken(id) => _firebaseFirestore
      .collection(_USER)
      .doc(id)
      .update({'fcmToken': ''}).timeout(_timeoutDuration);
}

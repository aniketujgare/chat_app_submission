import 'package:hive/hive.dart';

import '../models/message_model.dart';
import '../models/user_model.dart';

class UserOperations {
  void createUser(UserModel user) {
    try {
      final box = Hive.box<UserModel>('user');
      box.add(user);
    } catch (e) {
      print(e);
    }
  }

  UserModel? getUser() {
    final box = Hive.box<UserModel>('user');
    if (box.isNotEmpty) {
      final user = box.values.first;
      return user;
    } else {
      return null;
    }
  }

  void updateUser(UserModel updatedUser) async {
    final box = Hive.box<UserModel>('user');
    final user = getUser();
    if (user != null) {
      final index = box.keys.toList().indexOf(updatedUser.userId);
      await box.putAt(index, updatedUser);
    }
  }

  void deleteUser() async {
    final box = Hive.box<UserModel>('user');
    final msgBox = Hive.box<MessageModel>('messages');
    msgBox.clear();
    box.clear();
  }
}

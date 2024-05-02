import 'dart:convert';

import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel {
  @HiveField(1)
  String userId;
  @HiveField(2)
  String email;

  UserModel({
    required this.userId,
    required this.email,
  });
}

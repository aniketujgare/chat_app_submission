import 'package:hive/hive.dart';

part 'message_model.g.dart';

@HiveType(typeId: 1)
class MessageModel {
  @HiveField(1)
  String userId;
  @HiveField(2)
  List<String> message;
  @HiveField(3)
  int messageCount;

  MessageModel(
      {required this.userId,
      required this.message,
      required this.messageCount});
}

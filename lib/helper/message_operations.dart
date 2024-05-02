import 'package:hive_flutter/hive_flutter.dart';

import '../models/message_model.dart';

class MessageOperations {
  static void addMessage(MessageModel message) {
    final box = Hive.box<MessageModel>('messages');
    box.add(message);
  }

  static List<MessageModel> getAllMessages() {
    final box = Hive.box<MessageModel>('messages');
    if (box.isEmpty) {
      updateMessage('Start the chat');
    }
    return box.values.toList();
  }

  static void updateMessage(String newMessage) {
    final box = Hive.box<MessageModel>('messages');
    if (box.isEmpty) {
      final updatedMessage = MessageModel(
        userId: 'some_user_id',
        message: [newMessage],
        messageCount: 1,
      );
      box.add(updatedMessage);
    } else {
      final int messageCount = box.length;
      final int index = messageCount - 1;
      final lastMessage = box.getAt(index)!;

      lastMessage.message.add(newMessage);
      lastMessage.messageCount += 1;
      box.putAt(index, lastMessage);
    }
  }

  static void deleteMessage(int index) {
    final box = Hive.box<MessageModel>('messages');
    box.deleteAt(index);
  }
}

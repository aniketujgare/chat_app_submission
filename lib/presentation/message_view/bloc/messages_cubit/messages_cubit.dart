import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../helper/message_operations.dart';
import '../../../../models/message_model.dart';

part 'messages_cubit.freezed.dart';
part 'messages_state.dart';

class MessagesCubit extends Cubit<MessagesState> {
  MessagesCubit() : super(MessagesState.initial());

  void loadMessages() {
    try {
      List<MessageModel> messages = MessageOperations.getAllMessages();
      emit(state.copyWith(
          message: messages.isEmpty ? null : messages.first,
          status: MessagesStatus.loaded));
    } catch (e) {
      emit(state.copyWith(status: MessagesStatus.error));
    }
  }

  void addNewMessage(String newMessage) {
    try {
      emit(state.copyWith(status: MessagesStatus.loading));

      MessageOperations.updateMessage(newMessage);
      MessageModel? oldMessages = state.message;
      // if (oldMessages != null) {
      //   oldMessages.message.insert(state.message!.messageCount, newMessage);
      //   oldMessages.messageCount = oldMessages.messageCount + 1;
      // }
      emit(state.copyWith(message: oldMessages, status: MessagesStatus.loaded));
    } catch (e) {
      emit(state.copyWith(status: MessagesStatus.error));
    }
  }
}

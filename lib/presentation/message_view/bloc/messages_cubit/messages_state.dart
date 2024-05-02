part of 'messages_cubit.dart';

enum MessagesStatus { initial, loading, loaded, error }

@freezed
class MessagesState with _$MessagesState {
  const factory MessagesState.initial({
    @Default(MessagesStatus.initial) MessagesStatus status,
    @Default(null) MessageModel? message,
  }) = _Initial;
}

part of 'chat_bloc.dart';

class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class SendMessage extends ChatEvent {
  final String message;
  const SendMessage(this.message);
}

class StartNewChat extends ChatEvent {
  final String uid;
  const StartNewChat(this.uid);

  @override
  List<Object> get props => [uid];
}

class LoadChat extends ChatEvent {
  final History history;
  const LoadChat(this.history);
}

class LoadHistories extends ChatEvent {
  final String uid;
  const LoadHistories(this.uid);

  @override
  List<Object> get props => [uid];
}

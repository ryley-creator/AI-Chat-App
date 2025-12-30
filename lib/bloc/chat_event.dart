part of 'chat_bloc.dart';

class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class SendImageMessage extends ChatEvent {
  final String uid;
  final String propmt;
  final XFile image;

  const SendImageMessage(this.image, this.propmt, this.uid);
}

class AttachImage extends ChatEvent {
  final XFile image;
  const AttachImage(this.image);
}

class ClearAttachedImage extends ChatEvent {}

// class SendUserInput extends ChatEvent {
//   final String text;
//   final String uid;

//   const SendUserInput(this.text, this.uid);
// }

class SendMessage extends ChatEvent {
  final String message;
  final String uid;
  const SendMessage(this.message, this.uid);

  @override
  List<Object> get props => [message, uid];
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

  @override
  List<Object> get props => [history];
}

class LoadUserHistory extends ChatEvent {
  final String uid;
  const LoadUserHistory(this.uid);

  @override
  List<Object> get props => [uid];
}

class LogoutChat extends ChatEvent {
  @override
  List<Object> get props => [];
}

class DeleteChat extends ChatEvent {
  final String chatId;
  final String uid;

  const DeleteChat(this.chatId, this.uid);
}

part of 'chat_bloc.dart';

enum ChatStatus { initial, loading, loaded, error }

class ChatState extends Equatable {
  const ChatState({
    this.messages = const [],
    this.status = ChatStatus.initial,
    this.history = const [],
    this.sessionId,
  });

  final List<Message> messages;
  final List<History> history;
  final ChatStatus status;
  final String? sessionId;

  ChatState copyWith({
    List<Message>? messages,
    ChatStatus? status,
    List<History>? history,
    bool? openedFromHistory,
    String? sessionId,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      status: status ?? this.status,
      history: history ?? this.history,
      sessionId: sessionId ?? this.sessionId,
    );
  }

  @override
  List<Object?> get props => [messages, status, history, sessionId];
}

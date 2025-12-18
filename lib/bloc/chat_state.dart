part of 'chat_bloc.dart';

enum ChatStatus { initial, loading, loaded, error }

class ChatState extends Equatable {
  const ChatState({
    this.messages = const [],
    this.status = ChatStatus.initial,
    this.history = const [],
    this.openedFromHistory = false,
  });

  final List<Message> messages;
  final List<History> history;
  final ChatStatus status;
  final bool openedFromHistory;

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
      openedFromHistory: openedFromHistory ?? this.openedFromHistory,
    );
  }

  @override
  List<Object?> get props => [messages, status, history, openedFromHistory];
}

part of 'chat_bloc.dart';

enum ChatStatus { initial, loading, loaded, error }

class ChatState extends Equatable {
  const ChatState({
    this.messages = const [],
    this.status = ChatStatus.initial,
    this.history = const [],
    this.activeSessionId,
    this.pendingImage,
  });

  final List<Message> messages;
  final List<History> history;
  final ChatStatus status;
  final String? activeSessionId;
  final XFile? pendingImage;

  ChatState copyWith({
    List<Message>? messages,
    ChatStatus? status,
    List<History>? history,
    String? activeSessionId,
    XFile? pendingImage,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      status: status ?? this.status,
      history: history ?? this.history,
      activeSessionId: activeSessionId ?? this.activeSessionId,
      pendingImage: pendingImage ?? this.pendingImage,
    );
  }

  @override
  List<Object?> get props => [
    messages,
    status,
    history,
    activeSessionId,
    pendingImage,
  ];
}

import 'package:bloc/bloc.dart';
import 'package:chat/models/history.dart';
import 'package:chat/models/message.dart';
import 'package:chat/tools/api_key.dart';
import 'package:chat/tools/gemini_service.dart';
import 'package:equatable/equatable.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc(this.geminiService) : super(ChatState()) {
    on<SendMessage>(onSendMessage);
    on<StartNewChat>(onStartNewChat);
    on<LoadChat>(onLoadChat);
  }
  final GeminiService geminiService;

  Future<void> onSendMessage(SendMessage event, Emitter<ChatState> emit) async {
    if (state.status == ChatStatus.loading) return;
    final userMessage = Message(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      isUser: true,
      text: event.message,
    );
    emit(
      state.copyWith(
        messages: [...state.messages, userMessage],
        status: ChatStatus.loading,
      ),
    );
    final response = await geminiService.sendMessage(event.message);
    final aiMessage = Message(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      isUser: false,
      text: response,
    );
    emit(
      state.copyWith(
        messages: [...state.messages, aiMessage],
        status: ChatStatus.loaded,
      ),
    );
  }

  void onStartNewChat(StartNewChat event, Emitter<ChatState> emit) async {
    if (state.messages.isNotEmpty && !state.openedFromHistory) {
      final newSession = History(
        createdAt: DateTime.now(),
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        messages: state.messages,
        title: 'Generating...',
      );
      final newHistory = [...state.history, newSession];
      emit(
        state.copyWith(
          messages: [],
          history: [...state.history, newSession],
          openedFromHistory: true,
        ),
      );
      final lastIndex = newHistory.length - 1;
      final summary = await generateTitle(newSession.messages);
      final updatedHistory = [...newHistory];
      updatedHistory[lastIndex] = History(
        createdAt: newSession.createdAt,
        id: newSession.id,
        messages: newSession.messages,
        title: summary,
      );
      emit(state.copyWith(history: updatedHistory));
    } else {
      emit(state.copyWith(messages: [], openedFromHistory: false));
    }
  }

  void onLoadChat(LoadChat event, Emitter<ChatState> emit) {
    emit(
      state.copyWith(
        messages: event.history.messages,
        status: ChatStatus.loaded,
        sessionId: event.history.id,
      ),
    );
  }

  Future<String> generateTitle(List<Message> messages) async {
    final lastMessageText = messages
        .map((m) => m.isUser ? "User: ${m.text}" : "AI: ${m.text}")
        .join("\n");
    final prompt =
        '''
        Summarize the following chat into a short title of 3 to 4 words.
        Return ONLY the title (no explanation, no punctuation, no quotes). Use title case.
        Chat: $lastMessageText
        ''';
    final apiCall = GeminiService(getApiKey(), getModel());
    final title = await apiCall.sendMessage(prompt);
    print(title);
    return title;
  }
}

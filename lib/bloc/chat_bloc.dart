import 'package:bloc/bloc.dart';
import 'package:chat/models/history.dart';
import 'package:chat/models/message.dart';
import 'package:chat/tools/ai_api_services.dart';
import 'package:chat/tools/history_service.dart';
import 'package:chat/tools/image.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc(this.geminiService, this.historyService, this.imageToTextService)
    : super(ChatState()) {
    on<AttachImage>((event, emit) {
      emit(state.copyWith(pendingImage: event.image));
    });
    on<ClearAttachedImage>((event, emit) {
      emit(state.copyWith(pendingImage: null));
    });
    on<SendMessage>(onSendMessage);
    on<StartNewChat>(onStartNewChat);
    on<LoadChat>(onLoadChat);
    on<LoadUserHistory>(onLoadUserHistory);
    on<LogoutChat>(onLogoutChat);
    on<DeleteChat>(onDeleteChat);
    on<SendImageMessage>(onSendImageMessage);
  }
  final ApiService geminiService;
  final HistoryService historyService;
  final ImageToTextService imageToTextService;

  void onLogoutChat(LogoutChat event, Emitter<ChatState> emit) {
    emit(const ChatState());
  }

  Future<void> onSendImageMessage(
    SendImageMessage event,
    Emitter<ChatState> emit,
  ) async {
    try {
      if (state.status == ChatStatus.loading) return;

      final userMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        isUser: true,
        text: event.propmt,
        imagePath: event.image.path,
      );

      List<Message> messages = [...state.messages, userMessage];
      emit(
        state.copyWith(
          messages: messages,
          status: ChatStatus.loading,
          pendingImage: null,
        ),
      );

      String? sessionId = state.activeSessionId;
      if (sessionId == null) {
        sessionId = await historyService.createChat(
          event.uid,
          messages,
          'Analyzing image...',
        );
        emit(
          state.copyWith(
            pendingImage: null,
            activeSessionId: sessionId,
            history: [
              ...state.history,
              History(
                createdAt: DateTime.now(),
                id: sessionId,
                messages: messages,
                title: 'Analyzing image...',
              ),
            ],
          ),
        );
      }
      final base64Image = await imageToBase64(event.image);
      final response = await imageToTextService.sendImageMessage(
        prompt: event.propmt,
        base64Image: base64Image,
      );
      final aiMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        isUser: false,
        text: response,
      );
      messages = [...state.messages, aiMessage];

      await historyService.updateChatMessages(
        uid: event.uid,
        chatId: sessionId,
        messages: messages,
      );

      if (messages.length == 2) {
        final title = await generateTitle(messages);

        await historyService.updateChatTitle(
          uid: event.uid,
          chatId: sessionId,
          title: title,
        );

        final updatedHistory = [...state.history];
        final index = updatedHistory.indexWhere((h) => h.id == sessionId);

        if (index != -1) {
          updatedHistory[index] = updatedHistory[index].copyWith(title: title);

          emit(state.copyWith(history: updatedHistory));
        }
      }
      emit(state.copyWith(messages: messages, status: ChatStatus.loaded));
    } on DioException catch (error) {
      if (error.response?.statusCode == 402) {
        emit(
          state.copyWith(
            status: ChatStatus.loaded,
            messages: [
              ...state.messages,
              Message(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                isUser: false,
                text:
                    '⚠️ Image analysis is currently unavailable. Please add credits to use this feature.',
              ),
            ],
          ),
        );
        return;
      }
    }
  }

  Future<void> onSendMessage(SendMessage event, Emitter<ChatState> emit) async {
    if (state.status == ChatStatus.loading) return;

    final userMessage = Message(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      isUser: true,
      text: event.message,
    );

    List<Message> messages = [...state.messages, userMessage];

    emit(state.copyWith(messages: messages, status: ChatStatus.loading));

    String? sessionId = state.activeSessionId;

    if (sessionId == null) {
      sessionId = await historyService.createChat(
        event.uid,
        messages,
        'Generating...',
      );

      final newHistoryItem = History(
        id: sessionId,
        messages: messages,
        createdAt: DateTime.now(),
        title: 'Generating...',
      );

      emit(
        state.copyWith(
          activeSessionId: sessionId,
          history: [...state.history, newHistoryItem],
        ),
      );
    }
    final contextMessages = buildAiMessages(messages).take(15).toList();
    final response = await geminiService.sendMessage(contextMessages);
    final aiMessage = Message(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      isUser: false,
      text: response,
    );

    messages = [...messages, aiMessage];

    await historyService.updateChatMessages(
      uid: event.uid,
      chatId: sessionId!,
      messages: messages,
    );

    final historyIndex = state.history.indexWhere((h) => h.id == sessionId);

    if (historyIndex != -1) {
      final updatedHistory = [...state.history];
      updatedHistory[historyIndex] = updatedHistory[historyIndex].copyWith(
        messages: messages,
      );

      emit(
        state.copyWith(
          messages: messages,
          history: updatedHistory,
          status: ChatStatus.loaded,
        ),
      );
    } else {
      emit(state.copyWith(messages: messages, status: ChatStatus.loaded));
    }

    if (messages.length == 2) {
      final title = await generateTitle(messages);

      await historyService.updateChatTitle(
        uid: event.uid,
        chatId: sessionId,
        title: title,
      );

      final updatedHistory = [...state.history];
      final index = updatedHistory.indexWhere((h) => h.id == sessionId);

      if (index != -1) {
        updatedHistory[index] = updatedHistory[index].copyWith(title: title);

        emit(state.copyWith(history: updatedHistory));
      }
    }
  }

  Future<void> onDeleteChat(DeleteChat event, Emitter<ChatState> emit) async {
    try {
      await historyService.deleteChat(uid: event.uid, chatId: event.chatId);
      final updatedHistory = state.history
          .where((t) => t.id != event.chatId)
          .toList();
      final isActiveDeleted = state.activeSessionId == event.chatId;
      emit(
        state.copyWith(
          history: updatedHistory,
          messages: isActiveDeleted ? [] : state.messages,
          activeSessionId: isActiveDeleted ? null : state.activeSessionId,
          status: ChatStatus.initial,
        ),
      );
    } catch (error) {
      print('Delete chat error: $error');
    }
  }

  List<Map<String, String>> buildAiMessages(List<Message> messages) {
    return messages.map((m) {
      return {"role": m.isUser ? "user" : "assistant", "content": m.text};
    }).toList();
  }

  void onStartNewChat(StartNewChat event, Emitter<ChatState> emit) async {
    emit(state.copyWith(messages: [], activeSessionId: null));
  }

  Future<void> onLoadUserHistory(
    LoadUserHistory event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(status: ChatStatus.loading));

    final history = await historyService.loadUserHistory(event.uid);

    emit(state.copyWith(history: history, status: ChatStatus.loaded));
  }

  void onLoadChat(LoadChat event, Emitter<ChatState> emit) {
    emit(
      state.copyWith(
        messages: event.history.messages,
        status: ChatStatus.loaded,
        activeSessionId: event.history.id,
      ),
    );
  }

  Future<String> generateTitle(List<Message> messages) async {
    // Build plain chat text (short, only first exchange)
    final chatText = messages
        .take(4) // safety: don't send too much
        .map((m) => m.isUser ? "User: ${m.text}" : "AI: ${m.text}")
        .join("\n");

    final prompt =
        '''
Summarize the following chat into a short title of 3 to 4 words.
Return ONLY the title.
No punctuation.
No quotes.
Use Title Case.

Chat:
$chatText
''';

    try {
      final title = await geminiService.sendMessage([
        {
          "role": "system",
          "content": "You generate short, clear chat titles only.",
        },
        {"role": "user", "content": prompt},
      ]);

      return title.trim();
    } catch (e) {
      // Fallback title (VERY important)
      return "New Chat";
    }
  }
}

import '../imports/imports.dart';

class HistoryService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String> createChat(
    String uid,
    List<Message> messages,
    String title,
  ) async {
    final doc = firestore
        .collection('users')
        .doc(uid)
        .collection('chats')
        .doc();
    await doc.set({
      'title': title,
      'createdAt': Timestamp.now(),
      'messages': messages.map((m) => m.toJson()).toList(),
    });
    return doc.id;
  }

  Future<void> deleteChat({required String uid, required String chatId}) async {
    await firestore
        .collection('users')
        .doc(uid)
        .collection('chats')
        .doc(chatId)
        .delete();
  }

  Future<void> updateChatMessages({
    required String uid,
    required String chatId,
    required List<Message> messages,
  }) async {
    await firestore
        .collection('users')
        .doc(uid)
        .collection('chats')
        .doc(chatId)
        .update({'messages': messages.map((m) => m.toJson()).toList()});
  }

  Future<void> updateChatTitle({
    required String uid,
    required String chatId,
    required String title,
  }) async {
    await firestore
        .collection('users')
        .doc(uid)
        .collection('chats')
        .doc(chatId)
        .update({'title': title});
  }

  Future<List<History>> loadUserHistory(String uid) async {
    final snapshot = await firestore
        .collection('users')
        .doc(uid)
        .collection('chats')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      return History.fromJson(doc.id, doc.data());
    }).toList();
  }

  // Future<History> loadChat(String uid, String chatId) async {
  //   final doc = await firestore
  //       .collection('users')
  //       .doc(uid)
  //       .collection('chats')
  //       .doc(chatId)
  //       .get();

  //   return History.fromJson(doc.id, doc.data()!);
  // }
}

import 'package:chat/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class History {
  final String id;
  final List<Message> messages;
  final DateTime createdAt;
  final String title;

  History({
    required this.createdAt,
    required this.id,
    required this.messages,
    required this.title,
  });

  History copyWith({
    String? id,
    List<Message>? messages,
    DateTime? createdAt,
    String? title,
  }) {
    return History(
      id: id ?? this.id,
      messages: messages ?? this.messages,
      createdAt: createdAt ?? this.createdAt,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'createdAt': createdAt,
      'messages': messages.map((m) => m.toMap()).toList(),
    };
  }

  factory History.fromMap(Map<String, dynamic> map) {
    return History(
      id: map['id'],
      title: map['title'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      messages: (map['messages'] as List<dynamic>)
          .map((m) => Message.fromMap(m))
          .toList(),
    );
  }
}

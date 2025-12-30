class Message {
  String text;
  final bool isUser;
  final String id;
  final String? imagePath;

  Message({
    required this.id,
    required this.isUser,
    required this.text,
    this.imagePath,
  });

  Map<String, dynamic> toJson() {
    return {'id': id, 'text': text, 'isUser': isUser, 'imagePath': imagePath};
  }

  factory Message.fromJson(Map<String, dynamic> map) {
    return Message(
      id: DateTime.now().microsecondsSinceEpoch.toString(), // локальный id
      text: map['text'] ?? '',
      isUser: map['isUser'] ?? false,
      imagePath: map['imagePath'],
    );
  }
}

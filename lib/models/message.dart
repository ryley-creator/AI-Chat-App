class Message {
  final String text;
  final bool isUser;
  final String id;

  Message({required this.id, required this.isUser, required this.text});

  Map<String, dynamic> toMap() {
    return {'text': text, 'isUser': isUser};
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(text: map['text'], isUser: map['isUser'], id: map['id']);
  }
}

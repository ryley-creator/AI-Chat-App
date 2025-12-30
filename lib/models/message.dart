import 'package:equatable/equatable.dart';

class Message extends Equatable {
  String? text;
  final bool isUser;
  final String id;
  final String? imagePath;
  final bool isLoading;
  final bool isImageRequest;

  Message({
    required this.id,
    required this.isUser,
    this.text,
    this.imagePath,
    this.isLoading = false,
    this.isImageRequest = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isUser': isUser,
      'imagePath': imagePath,
      'isLoading': isLoading,
      'isImageRequest': isImageRequest,
    };
  }

  Message copyWith({String? text, bool? isLoading, bool? isImageRequest}) {
    return Message(
      isImageRequest: isImageRequest ?? this.isImageRequest,
      id: id,
      isUser: isUser,
      text: text ?? this.text,
      imagePath: imagePath,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
    id,
    isUser,
    text,
    imagePath,
    isLoading,
    isImageRequest,
  ];

  factory Message.fromJson(Map<String, dynamic> map) {
    return Message(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      text: map['text'] ?? '',
      isUser: map['isUser'] ?? false,
      imagePath: map['imagePath'],
      isLoading: map['isLoading'] ?? false,
      isImageRequest: map['isImageRequest'] ?? false,
    );
  }
}

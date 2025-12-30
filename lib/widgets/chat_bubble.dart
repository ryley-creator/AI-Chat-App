import 'dart:io';

import '../imports/imports.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
  final String hola = 'String hello world i am going to say';
  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: message.imagePath != null
          ? Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(
                    File(message.imagePath!),
                    width: 150,
                    height: 200,
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: message.isUser
                        ? screenWidth * 0.5
                        : screenWidth * 0.95,
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    margin: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: message.isUser
                          ? Colors.grey.shade700
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      message.text,
                      style: TextStyle(
                        color: message.isUser
                            ? Colors.white
                            : (isDark ? Colors.white : Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: message.isUser
                    ? screenWidth * 0.5
                    : screenWidth * 0.95,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                margin: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: message.isUser
                      ? Colors.grey.shade700
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  message.text,
                  style: TextStyle(
                    color: message.isUser
                        ? Colors.white
                        : (isDark ? Colors.white : Colors.black),
                  ),
                ),
              ),
            ),
    );
  }
}

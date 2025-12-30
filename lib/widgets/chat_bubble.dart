import 'dart:io';

import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../imports/imports.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (message.isLoading) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Text('Thinking'),
            SizedBox(width: 5),
            LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.white,
              size: 22,
            ),
          ],
        ),
      );
    }
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
                    fit: BoxFit.cover,
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
                      message.text!,
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
                  message.text!,
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

import 'package:chat/bloc/chat/chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatTextField extends StatelessWidget {
  const ChatTextField({super.key, required this.controller});
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              label: Text('Ask anything...'),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            context.read<ChatBloc>().add(SendMessage(controller.text));
            FocusScope.of(context).unfocus();
            controller.clear();
          },
          icon: Icon(Icons.send_sharp, size: 40),
        ),
      ],
    );
  }
}

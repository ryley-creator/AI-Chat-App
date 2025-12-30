import 'package:flutter/material.dart';

class ImageTextfield extends StatelessWidget {
  const ImageTextfield({
    super.key,
    required this.controller,
    required this.onPressed,
  });
  final TextEditingController controller;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Describe the image...',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(width: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(60),
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(Icons.send_outlined, size: 40),
          ),
        ),
      ],
    );
  }
}

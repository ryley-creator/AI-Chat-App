import 'package:chat/models/image_model.dart';
import 'package:flutter/material.dart';

class ImageBubble extends StatelessWidget {
  final ImageItem item;

  const ImageBubble({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    switch (item.type) {
      case ImageItemType.userText:
        return Align(
          alignment: Alignment.centerRight,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade700,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              item.text!,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );

      case ImageItemType.loading:
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          height: 300,
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(16),
          ),
        );

      case ImageItemType.aiImage:
        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.memory(
            item.image!,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        );
    }
  }
}

import 'dart:typed_data';

enum ImageItemType { userText, aiImage, loading }

class ImageItem {
  final String id;
  final ImageItemType type;
  final String? text;
  final Uint8List? image;

  ImageItem({required this.id, required this.type, this.text, this.image});
}

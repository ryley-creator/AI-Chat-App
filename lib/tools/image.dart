import 'dart:convert';
import 'package:image_picker/image_picker.dart';

Future<String> imageToBase64(XFile image) async {
  final bytes = await image.readAsBytes();
  return base64Encode(bytes);
}

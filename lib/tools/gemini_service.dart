import 'dart:convert';

import 'package:dio/dio.dart';

class GeminiService {
  final String apiKey;
  final String model;
  static const String baseUrl =
      'https://router.huggingface.co/v1/chat/completions';
  GeminiService(this.apiKey, this.model);

  Future<String> sendMessage(String content) async {
    Dio dio = Dio();
    try {
      final response = await dio.post(
        '$baseUrl?key=$apiKey',
        data: getRequestBody(content),
        options: Options(headers: {"Authorization": "Bearer $apiKey"}),
      );
      if (response.statusCode == 200) {
        final text = response.data["choices"][0]["message"]["content"];
        print(text);
        return text;
      } else {
        throw Exception('Failed to load message!');
      }
    } catch (error) {
      print("Error: $error");
      return "Error sending request";
    }
  }

  String getRequestBody(String content) => jsonEncode({
    "model": model,
    "messages": [
      {"role": "user", "content": content},
    ],
  });
}

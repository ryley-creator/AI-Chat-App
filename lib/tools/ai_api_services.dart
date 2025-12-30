import 'dart:typed_data';
import 'package:chat/imports/imports.dart';
import 'package:dio/dio.dart';

class ApiService {
  final String apiKey = getApiKey();

  static const String baseUrl = 'https://openrouter.ai/api/v1/chat/completions';

  Future<String> sendMessage(List<Map<String, String>> messages) async {
    final dio = Dio();

    try {
      final response = await dio.post(
        baseUrl,
        data: {
          "model": "nex-agi/deepseek-v3.1-nex-n1:free",
          "messages": messages,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $apiKey",
            "Content-Type": "application/json",
            "HTTP-Referer": "https://your-app-name.com",
            "X-Title": "AI Chat App",
          },
        ),
      );

      return response.data["choices"][0]["message"]["content"];
    } catch (e) {
      print("OpenRouter API Error: $e");
      rethrow;
    }
  }
}

class ImageService {
  Future<Uint8List> generateImage(String text) async {
    final Dio dio = Dio();
    final response = await dio.post(
      'http://127.0.0.1:8000/generate-image',
      data: {'prompt': text},
      options: Options(
        responseType: ResponseType.bytes,
        sendTimeout: const Duration(minutes: 2),
        receiveTimeout: const Duration(minutes: 2),
      ),
    );
    return Uint8List.fromList(response.data);
  }
}

class ImageToTextService {
  final String apiKey = getApiKey();
  static const String baseUrl = 'https://openrouter.ai/api/v1/chat/completions';
  final Dio dio = Dio();

  Future<String> sendImageMessage({
    required String prompt,
    required String base64Image,
  }) async {
    final response = await dio.post(
      baseUrl,
      options: Options(
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
          'HTTP-Referer': 'https://yourapp.com',
          'X-Title': 'Chat App',
        },
      ),
      data: {
        'model': 'openai/gpt-4o-mini',
        'messages': [
          {
            'role': 'user',
            'content': [
              {
                'type': 'text',
                'text': prompt.isEmpty ? 'Describe the image' : prompt,
              },
              {
                'type': 'image_url',
                'image_url': {'url': 'data:image/jpeg;base64,$base64Image'},
              },
            ],
          },
        ],
      },
    );
    return response.data['choices'][0]['message']['content'];
  }
}

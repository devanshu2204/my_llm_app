import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GroqApiService {
  final String _apiKey;

  GroqApiService() : _apiKey = dotenv.env['GROQ_API_KEY'] ?? 'missing_key';

  Future<String> getResponse(String userInput) async {
    if (_apiKey == 'missing_key') {
      return 'Error: Groq API key is missing';
    }

    final url = Uri.parse('https://api.groq.com/openai/v1/chat/completions');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_apiKey',
    };
    final body = jsonEncode({
      "model": "llama3-8b-8192",
      "messages": [
        {"role": "user", "content": userInput}
      ],
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse['choices'][0]['message']['content'].trim();
      } else {
        return 'Error: ${response.statusCode} ${response.body}';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
}

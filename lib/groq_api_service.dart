import 'dart:convert';
import 'package:http/http.dart' as http;

class GroqApiService {
  Future<String> getResponse(String userInput) async {
    const backendUrl = 'https://my-llm-app.vercel.app/api/groq';
    final url = Uri.parse(backendUrl);
    final headers = {'Content-Type': 'application/json'};
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

import 'package:groq_sdk/groq_sdk.dart';

class GroqApiService {
  final Groq _groq;

  GroqApiService()
      : _groq = Groq(
          apiKey: dotenv.env['GROQ_API_KEY']!,
          model: "llama3-8b-8192",
        );

  Future<String> getResponse(String userInput) async {
    try {
      final response = await _groq.createChatCompletion(
        messages: [
          {"role": "user", "content": userInput}
        ],
      );
      return response.choices[0].message.content;
    } catch (e) {
      return "Error: $e";
    }
  }
}
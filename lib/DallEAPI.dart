import 'dart:convert';
import 'package:http/http.dart' as http;

class DallEAPI {
  final String apiKey;

  DallEAPI(this.apiKey);

  Future<String?> generateImage(String prompt) async {
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/images/generations'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode(
          {'model': 'dall-e-3', 'prompt': prompt, 'n': 1, 'size': '1024x1024'}),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['data'][0]
          ['url']; // Adjust based on actual API response structure
    } else {
      throw Exception('Failed to generate image: ${response.body}');
    }
  }
}

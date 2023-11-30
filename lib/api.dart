import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiKey =
      "1dz3Fjt8HrNNW8XsRzfnTO2LthIKnnsbqVDRgTvi4ygnTxa2xplTRCXJ";
  String? lastImageUrl;

  Future<String> getRandomImage({String category = 'nature'}) async {
    final response = await http.get(
      Uri.parse(
          'https://api.pexels.com/v1/search?query=$category&per_page=1&page=${Random().nextInt(100)}'),
      headers: {
        "Authorization": apiKey,
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      lastImageUrl = data['photos'][0]['src']['large'];
      return lastImageUrl!;
    } else {
      throw Exception('Failed to load image');
    }
  }
}

import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiKey =
      "1dz3Fjt8HrNNW8XsRzfnTO2LthIKnnsbqVDRgTvi4ygnTxa2xplTRCXJ";

  Future<String> getRandomImage() async {
    final response = await http.get(
      Uri.parse(
          'https://api.pexels.com/v1/search?query=nature&per_page=1&page=${Random().nextInt(100)}'),
      headers: {
        "Authorization": apiKey,
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['photos'][0]['src']['large'] +
          "?random=${Random().nextInt(100000)}";
    } else {
      throw Exception('Failed to load image');
    }
  }
}

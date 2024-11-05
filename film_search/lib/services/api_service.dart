import 'dart:convert';
import 'package:http/https.dart' as http;

class ApiService {
  final String apiKey = '000dbb4adbmsh028c68605343d72p119a27jsn4d78e9f77bab';
  final String apiHost = 'imdb188.p.rapidapi.com';

  Future<List<dynamic>> getPopularMovies() async {
    final url = Uri.parse('https://$apiHost/api/v1/getPopularMovies'); 
    print('Fetching popular movies from: $url');

    final response = await http.get(url, headers: {
      'X-RapidAPI-Key': apiKey,
      'X-RapidAPI-Host': apiHost,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("Popular Movies Data: $data");
      return data['movies'] ?? [];
    } else {
      print('Error ${response.statusCode}: ${response.reasonPhrase}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load popular movies');
    }
  }

  Future<List<dynamic>> searchMovies(String query) async {
    final url = Uri.parse('https://$apiHost/api/v1/search/$query');
    print('Searching movies from: $url');

    final response = await http.get(url, headers: {
      'X-RapidAPI-Key': apiKey,
      'X-RapidAPI-Host': apiHost,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("Search Results Data: $data");
      return data['results'] ?? [];
    } else {
      print('Error ${response.statusCode}: ${response.reasonPhrase}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load search results');
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;

class TMDbApiService {
  static const String _apiKey = '639158dc72ac63e33ac23b96e4a8ac49';
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  Future<List<dynamic>> fetchPopularMovies({int page = 1}) async {
    final url = Uri.parse('$_baseUrl/movie/popular?api_key=$_apiKey&language=tr-TR&page=$page');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['results'];
    } else {
      throw Exception('Film listesi alınamadı: ${response.statusCode}');
    }
  }
}


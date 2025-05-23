import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<List<dynamic>> fetchGames(String title) async {
    final url = Uri.parse(
      'https://www.cheapshark.com/api/1.0/games?title=$title',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load games');
    }
  }

  // NEW FEATURE: This should fetch a list of current deals
  static Future<List<dynamic>> fetchDeals() async {
    final url = Uri.parse('https://www.cheapshark.com/api/1.0/deals');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load deals');
    }
  }
}

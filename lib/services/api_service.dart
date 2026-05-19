import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/game_model.dart';

class ApiService {
  static const String _baseUrl = 'https://www.freetogame.com/api';

  static Future<List<Game>> fetchGames() async {
    final response = await http.get(Uri.parse('$_baseUrl/games'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Game.fromJson(e)).toList();
    }
    throw Exception('Gagal memuat daftar game');
  }

  static Future<GameDetail> fetchGameDetail(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/game?id=$id'));
    if (response.statusCode == 200) {
      return GameDetail.fromJson(json.decode(response.body));
    }
    throw Exception('Gagal memuat detail game');
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:anime_hub/models/anime.dart';

class JikanApiService {
  static const String baseUrl = 'https://api.jikan.moe/v4';

  Future<List<Anime>> getTrendingAnime() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/top/anime?filter=airing&limit=20'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> animeList = data['data'] ?? [];
        return animeList.map((json) => Anime.fromJson(json)).toList();
      } else {
        debugPrint('Error fetching trending anime: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('Error fetching trending anime: $e');
      return [];
    }
  }

  Future<List<Anime>> getUpcomingAnime() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/seasons/upcoming?limit=20'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> animeList = data['data'] ?? [];
        return animeList.map((json) => Anime.fromJson(json)).toList();
      } else {
        debugPrint('Error fetching upcoming anime: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('Error fetching upcoming anime: $e');
      return [];
    }
  }

  Future<Anime?> getRandomAnime() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/random/anime'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Anime.fromJson(data['data']);
      } else {
        debugPrint('Error fetching random anime: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching random anime: $e');
      return null;
    }
  }

  Future<List<Anime>> searchAnime(String query) async {
    if (query.isEmpty) return [];
    
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/anime?q=${Uri.encodeComponent(query)}&limit=20'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> animeList = data['data'] ?? [];
        return animeList.map((json) => Anime.fromJson(json)).toList();
      } else {
        debugPrint('Error searching anime: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('Error searching anime: $e');
      return [];
    }
  }

Future<Anime?> getAnimeDetails(int malId) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/anime/$malId/full'), // ✅ include /full
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final anime = Anime.fromJson(data['data']);

      debugPrint('Trailer URL: ${anime.trailerUrl}');
      debugPrint('YouTube ID: ${anime.trailerYoutubeId}');

      return anime;
    } else {
      debugPrint('Error fetching anime details: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    debugPrint('Error fetching anime details: $e');
    return null;
  }
}


}

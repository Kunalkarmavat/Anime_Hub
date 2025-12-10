import 'package:anime_hub/services/api._service.dart';
import 'package:flutter/material.dart';
import 'package:anime_hub/models/anime.dart';

class AnimeDetailProvider extends ChangeNotifier {
  Anime? currentAnime;
  bool isLoading = false;

  final JikanApiService _api = JikanApiService();

  void setCurrentAnime(Anime anime) {
    currentAnime = anime;
    notifyListeners();
  }

  Future<void> fetchAnimeDetails(int malId) async {
    isLoading = true;
    notifyListeners();

    final Anime? fullAnime = await _api.getAnimeDetails(malId);

    if (fullAnime != null) {
      currentAnime = fullAnime;
    }

    isLoading = false;
    notifyListeners();
  }
}

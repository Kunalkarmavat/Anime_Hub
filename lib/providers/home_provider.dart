import 'package:anime_hub/services/api._service.dart';
import 'package:flutter/foundation.dart';
import 'package:anime_hub/models/anime.dart';

class HomeProvider with ChangeNotifier {
  final JikanApiService _apiService = JikanApiService();

  Anime? _randomAnime;
  List<Anime> _trendingAnime = [];
  List<Anime> _upcomingAnime = [];
  
  bool _isLoadingRandom = false;
  bool _isLoadingTrending = false;
  bool _isLoadingUpcoming = false;

  Anime? get randomAnime => _randomAnime;
  List<Anime> get trendingAnime => _trendingAnime;
  List<Anime> get upcomingAnime => _upcomingAnime;
  
  bool get isLoadingRandom => _isLoadingRandom;
  bool get isLoadingTrending => _isLoadingTrending;
  bool get isLoadingUpcoming => _isLoadingUpcoming;

  Future<void> fetchRandomAnime() async {
    _isLoadingRandom = true;
    notifyListeners();

    _randomAnime = await _apiService.getRandomAnime();
    
    _isLoadingRandom = false;
    notifyListeners();
  }

  Future<void> fetchTrendingAnime() async {
    _isLoadingTrending = true;
    notifyListeners();

    _trendingAnime = await _apiService.getTrendingAnime();
    
    _isLoadingTrending = false;
    notifyListeners();
  }

  Future<void> fetchUpcomingAnime() async {
    _isLoadingUpcoming = true;
    notifyListeners();

    _upcomingAnime = await _apiService.getUpcomingAnime();
    
    _isLoadingUpcoming = false;
    notifyListeners();
  }

  Future<void> fetchAllHomeData() async {
    await Future.wait([
      fetchRandomAnime(),
      fetchTrendingAnime(),
      fetchUpcomingAnime(),
    ]);
  }
}

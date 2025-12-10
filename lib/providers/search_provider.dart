import 'package:anime_hub/services/api._service.dart';
import 'package:flutter/foundation.dart';
import 'package:anime_hub/models/anime.dart';

class SearchProvider with ChangeNotifier {
  final JikanApiService _apiService = JikanApiService();

  List<Anime> _searchResults = [];
  bool _isLoading = false;
  String _query = '';

  List<Anime> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String get query => _query;

  Future<void> searchAnime(String query) async {
    _query = query;
    
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    _searchResults = await _apiService.searchAnime(query);
    
    _isLoading = false;
    notifyListeners();
  }

  void clearSearch() {
    _query = '';
    _searchResults = [];
    notifyListeners();
  }
}

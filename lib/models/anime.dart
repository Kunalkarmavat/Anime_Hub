import 'package:flutter/material.dart';

class Anime {
  final int malId;
  final String title;
  final String? imageUrl;
  final String? synopsis;
  final double? score;
  final int? year;
  final List<String> genres;
  final String? trailerUrl;
  final String? trailerYoutubeId;
  final String? type;
  final int? episodes;
  final String? status;
  final String? aired;

  Anime({
    required this.malId,
    required this.title,
    this.imageUrl,
    this.synopsis,
    this.score,
    this.year,
    this.genres = const [],
    this.trailerUrl,
    this.trailerYoutubeId,
    this.type,
    this.episodes,
    this.status,
    this.aired,
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
    final List<String> genreList = [];
    if (json['genres'] != null) {
      for (var genre in json['genres']) {
        genreList.add(genre['name'] ?? '');
      }
    }

    String? trailerUrl;
    String? youtubeId;
    // if (json['trailer'] != null) {
    //   trailerUrl = json['trailer']['url'];
    //   youtubeId = json['trailer']['youtube_id'];
    // }
    if (json['trailer'] != null) {
    // If API provides youtube_id and url, use them
    trailerUrl = json['trailer']['url'];
    youtubeId = json['trailer']['youtube_id'];

    // If they are null, extract from embed_url
    if ((trailerUrl == null || trailerUrl.isEmpty) &&
        json['trailer']['embed_url'] != null) {
      final embedUrl = json['trailer']['embed_url'] as String;
      print('Embed URL: $embedUrl');

      // Extract YouTube ID from embed URL
      final regex = RegExp(r'/embed/([a-zA-Z0-9_-]+)');
      final match = regex.firstMatch(embedUrl);
      if (match != null && match.groupCount >= 1) {
        youtubeId = match.group(1);
        trailerUrl = 'https://www.youtube.com/watch?v=$youtubeId';
      }
      print('youtubeId: $youtubeId');
    }
    }

    return Anime(
      malId: json['mal_id'] ?? 0,
      title: json['title'] ?? json['title_english'] ?? 'Unknown',
      imageUrl: json['images']?['jpg']?['large_image_url'] ?? json['images']?['jpg']?['image_url'],
      synopsis: json['synopsis'],
      score: json['score']?.toDouble(),
      year: json['year'] ?? json['aired']?['prop']?['from']?['year'],
      genres: genreList,
      trailerUrl: trailerUrl,
      trailerYoutubeId: youtubeId,
      type: json['type'],
      episodes: json['episodes'],
      status: json['status'],
      aired: json['aired']?['string'],
    );
  }

  String get truncatedSynopsis {
    if (synopsis == null || synopsis!.isEmpty) return 'No description available.';
    return synopsis!.length > 150 ? '${synopsis!.substring(0, 150)}...' : synopsis!;
  }

  String get displayYear => year?.toString() ?? 'N/A';
  
  String get displayScore => score != null ? score!.toStringAsFixed(1) : 'N/A';
  
  String get trailerThumbnail => trailerYoutubeId != null ? 'https://img.youtube.com/vi/$trailerYoutubeId/maxresdefault.jpg' : '';
}

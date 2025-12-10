import 'package:anime_hub/theme/constant/anime_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:anime_hub/providers/anime_detail_provider.dart';
import 'package:anime_hub/providers/home_provider.dart';
import 'package:anime_hub/theme/theme.dart';

class AnimeDetailScreen extends StatefulWidget {
  const AnimeDetailScreen({super.key});

  @override
  State<AnimeDetailScreen> createState() => _AnimeDetailScreenState();
}

class _AnimeDetailScreenState extends State<AnimeDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final anime = context.read<AnimeDetailProvider>().currentAnime;
      if (anime != null) {
        context.read<AnimeDetailProvider>().fetchAnimeDetails(anime.malId);
      }
    });
  }

  // Future<void> _openTrailer(String? trailerUrl) async {
  //   if (trailerUrl == null) return;
    
  //   final Uri uri = Uri.parse(trailerUrl);
  //   if (await canLaunchUrl(uri)) {
  //     await launchUrl(uri, mode: LaunchMode.externalApplication);
  //   }
  // }


Future<void> _openTrailer(String youtubeId) async {
  debugPrint(youtubeId);
  final Uri uri = Uri.parse('https://www.youtube.com/watch?v=$youtubeId');
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}


  @override
  Widget build(BuildContext context) {
    final detailProvider = context.watch<AnimeDetailProvider>();
    final anime = detailProvider.currentAnime;

    if (anime == null) {
      return Scaffold(
        body: Center(
          child: Text(
            'No anime selected',
            style: context.textStyles.titleMedium?.copyWith(
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 420,
            pinned: true,
            backgroundColor: const Color(0xFF0A0A0A),
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (anime.trailerThumbnail.isNotEmpty)
                    CachedNetworkImage(
                      imageUrl: anime.trailerThumbnail,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => anime.imageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: anime.imageUrl!,
                            fit: BoxFit.cover,
                          )
                        : Container(color: const Color(0xFF1A1E3A)),
                    )
                  else if (anime.imageUrl != null)
                    CachedNetworkImage(
                      imageUrl: anime.imageUrl!,
                      fit: BoxFit.cover,
                    )
                  else
                    Container(color: const Color(0xFF1A1E3A)),
                   Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                           Colors.black.withValues(alpha: 0.0),
                           Colors.black.withValues(alpha: 0.6),
                           Colors.black.withValues(alpha: 0.95),
                        ],
                         stops: const [0.0, 0.7, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 24,
                    left: 24,
                    right: 24,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (anime.imageUrl != null)
                          Container(
                            width: 120,
                            height: 170,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl: anime.imageUrl!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                anime.title,
                                style: context.textStyles.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 12,
                                runSpacing: 8,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.calendar_today, size: 14, color: Colors.white),
                                      const SizedBox(width: 6),
                                      Text(
                                        anime.displayYear,
                                        style: context.textStyles.labelMedium?.copyWith(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  if (anime.score != null)
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.star, size: 16, color: Colors.white),
                                        const SizedBox(width: 6),
                                        Text(
                                          anime.displayScore,
                                          style: context.textStyles.labelMedium?.copyWith(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  if (anime.genres.isNotEmpty)
                                    Text(
                                      anime.genres.join(', '),
                                      style: context.textStyles.labelMedium?.copyWith(
                                        color: Colors.white.withValues(alpha: 0.85),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (anime.trailerYoutubeId != null && anime.trailerYoutubeId!.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: ElevatedButton.icon(
                          onPressed: () => _openTrailer(anime.trailerYoutubeId!),
                          icon: const Icon(Icons.play_arrow, color: Colors.white, size: 28),
                          label: Text(
                            'Play Trailer',
                            style: context.textStyles.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text(
                          'Trailer Not Available',
                          style: context.textStyles.titleMedium?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 32),
                  Text(
                    'Anime Synopsis',
                    style: context.textStyles.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    anime.synopsis ?? 'No synopsis available.',
                    style: context.textStyles.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Trending Anime',
                          style: context.textStyles.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'View All',
                          style: TextStyle(color: Color(0xFFE50914), fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const TrendingAnimeSectionInDetail(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TrendingAnimeSectionInDetail extends StatelessWidget {
  const TrendingAnimeSectionInDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();
    
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: homeProvider.trendingAnime.length,
        itemBuilder: (context, index) {
          final anime = homeProvider.trendingAnime[index];
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: AnimeCard(
              anime: anime,
              showTitleOverlay: false,
              showRatingBadge: true,
              onTap: () {
                context.read<AnimeDetailProvider>().setCurrentAnime(anime);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const AnimeDetailScreen()),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

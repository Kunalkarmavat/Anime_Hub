import 'package:anime_hub/presentation/anime_detail_screen.dart';
import 'package:anime_hub/presentation/new_releases_screen.dart';
import 'package:anime_hub/presentation/search_screen.dart';
import 'package:anime_hub/theme/constant/anime_card.dart';
import 'package:anime_hub/theme/constant/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:anime_hub/providers/home_provider.dart';
import 'package:anime_hub/providers/anime_detail_provider.dart';
import 'package:anime_hub/theme/theme.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().fetchAllHomeData();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: RefreshIndicator(
        onRefresh: () => context.read<HomeProvider>().fetchAllHomeData(),
        color: const Color(0xFFE50914),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const RandomAnimeSection(),
              const SizedBox(height: 40),
              const TrendingAnimeSection(),
              const SizedBox(height: 40),
              const UpcomingAnimeSection(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    ),
  );
}

class RandomAnimeSection extends StatelessWidget {
  const RandomAnimeSection({super.key});

  Future<void> _openTrailer(String? trailerUrl) async {
    if (trailerUrl == null) return;
    
    final Uri uri = Uri.parse(trailerUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();
    
    if (homeProvider.isLoadingRandom) {
      return const ShimmerRandomAnime();
    }

    final anime = homeProvider.randomAnime;
    if (anime == null) return const SizedBox.shrink();
    print('Random Anime Trailer URL: ${anime.malId}');
    return GestureDetector(
        onTap: () {
          context.read<AnimeDetailProvider>().setCurrentAnime(anime);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AnimeDetailScreen()),
          );
        },
        child: Container(
          height: 460,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
            boxShadow: [
              BoxShadow(
                 color: const Color.fromARGB(255, 10, 10, 10),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: anime.imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: anime.imageUrl!,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        fadeInDuration: const Duration(milliseconds: 350),
                        fadeOutDuration: const Duration(milliseconds: 200),
                      )
                    : Container(
                        color: const Color(0xFF111214),
                        child: const Icon(Icons.movie, color: Colors.grey, size: 80),
                      ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.0),
                      Colors.black.withValues(alpha: 0.7),
                      Colors.black.withValues(alpha: 0.95),
                    ],
                    stops: const [0.4, 0.75, 1.0],
                  ),
                ),
              ),
              // Top overlay icons
              Positioned(
                top: 12,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () {},
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.settings, color: Colors.white),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        anime.title,
                        style: context.textStyles.headlineLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                          
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        anime.truncatedSynopsis,
                        style: context.textStyles.bodyLarge?.copyWith(
                          
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                        
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (anime.trailerUrl != null)
                            ElevatedButton.icon(
                              onPressed: () => _openTrailer(anime.trailerUrl),
                              icon: const Icon(Icons.play_arrow, color: Colors.white),
                              label: Text(
                                'Play',
                                style: context.textStyles.labelLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          if (anime.trailerUrl == null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                              decoration: BoxDecoration(
                                color: Colors.grey.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                'No Trailer',
                                style: context.textStyles.labelLarge?.copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          const SizedBox(width: 12),
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.white),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Added to My List')),
                              );
                            },
                            icon: const Icon(Icons.add, color: Colors.white),
                            label: Text(
                              'My List',
                              style: context.textStyles.labelLarge?.copyWith(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}

class TrendingAnimeSection extends StatelessWidget {
  const TrendingAnimeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppSpacing.horizontalLg,
          child: Row(
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
                  // Navigate to Search to explore more
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SearchScreen()),
                  );
                },
                child: const Text(
                  'View All',
                  style: TextStyle(color: Color(0xFFE50914), fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: homeProvider.isLoadingTrending
            ? ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: AppSpacing.horizontalLg,
                itemCount: 5,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: const ShimmerAnimeCard(),
                ),
              )
            : ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: AppSpacing.horizontalLg,
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AnimeDetailScreen()),
                        );
                      },
                    ),
                  );
                },
              ),
        ),
      ],
    );
  }
}

class UpcomingAnimeSection extends StatelessWidget {
  const UpcomingAnimeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppSpacing.horizontalLg,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Upcoming Anime',
                  style: context.textStyles.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const NewReleasesScreen()),
                  );
                },
                child: const Text(
                  'View All',
                  style: TextStyle(color: Color(0xFFE50914), fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: homeProvider.isLoadingUpcoming
            ? ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: AppSpacing.horizontalLg,
                itemCount: 5,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: const ShimmerAnimeCard(),
                ),
              )
            : ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: AppSpacing.horizontalLg,
                itemCount: homeProvider.upcomingAnime.length,
                itemBuilder: (context, index) {
                  final anime = homeProvider.upcomingAnime[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: AnimeCard(
                      anime: anime,
                      showTitleOverlay: false,
                      showRatingBadge: true,
                      onTap: () {
                        context.read<AnimeDetailProvider>().setCurrentAnime(anime);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AnimeDetailScreen()),
                        );
                      },
                    ),
                  );
                },
              ),
        ),
      ],
    );
  }
}

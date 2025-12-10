import 'package:anime_hub/presentation/anime_detail_screen.dart';
import 'package:anime_hub/theme/constant/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:anime_hub/providers/home_provider.dart';
import 'package:anime_hub/providers/anime_detail_provider.dart';
import 'package:anime_hub/theme/theme.dart';

class NewReleasesScreen extends StatefulWidget {
  const NewReleasesScreen({super.key});

  @override
  State<NewReleasesScreen> createState() => _NewReleasesScreenState();
}

class _NewReleasesScreenState extends State<NewReleasesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().fetchUpcomingAnime();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Padding(
            padding: AppSpacing.horizontalLg,
            child: Text(
              'New Releases',
              style: context.textStyles.headlineLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Consumer<HomeProvider>(
              builder: (context, homeProvider, child) {
                if (homeProvider.isLoadingUpcoming) {
                  return const ShimmerUpcomingList();
                }

                if (homeProvider.upcomingAnime.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.movie_filter,
                          size: 80,
                          color: Colors.grey.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No upcoming anime found',
                          style: context.textStyles.titleMedium?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => homeProvider.fetchUpcomingAnime(),
                  color: const Color(0xFFE50914),
                  child: ListView.builder(
                    padding: AppSpacing.horizontalLg,
                    itemCount: homeProvider.upcomingAnime.length,
                    itemBuilder: (context, index) {
                      final anime = homeProvider.upcomingAnime[index];
                      return GestureDetector(
                        onTap: () {
                          context.read<AnimeDetailProvider>().setCurrentAnime(anime);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AnimeDetailScreen()),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: anime.imageUrl != null
                                    ? CachedNetworkImage(
                                        imageUrl: anime.imageUrl!,
                                        width: 110,
                                        height: 150,
                                        fit: BoxFit.cover,
                                        fadeInDuration: const Duration(milliseconds: 300),
                                        fadeOutDuration: const Duration(milliseconds: 200),
                                        placeholder: (context, url) => Container(
                                          width: 110,
                                          height: 150,
                                          color: const Color(0xFF0A0A0A),
                                          child: const Center(
                                            child: CircularProgressIndicator(
                                              color: Color(0xFFE50914),
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) => Container(
                                          width: 110,
                                          height: 150,
                                          color: const Color(0xFF0A0A0A),
                                          child: const Icon(Icons.movie, color: Colors.grey),
                                        ),
                                      )
                                    : Container(
                                        width: 110,
                                        height: 150,
                                        color: const Color(0xFF0A0A0A),
                                        child: const Icon(Icons.movie, color: Colors.grey),
                                      ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      anime.title,
                                      style: context.textStyles.titleMedium?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 6),
                                    if (anime.aired != null) ...[
                                      Text(
                                        'Release Date',
                                        style: context.textStyles.labelSmall?.copyWith(color: Colors.grey),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        anime.aired!,
                                        style: context.textStyles.bodySmall?.copyWith(color: Colors.white),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                    const SizedBox(height: 8),
                                    Text(
                                      anime.synopsis ?? 'No description available.',
                                      style: context.textStyles.bodySmall?.copyWith(
                                        color: Colors.white.withValues(alpha: 0.7),
                                        height: 1.4,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}

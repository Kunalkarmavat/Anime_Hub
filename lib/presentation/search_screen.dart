import 'package:anime_hub/presentation/anime_detail_screen.dart';
import 'package:anime_hub/theme/constant/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anime_hub/providers/search_provider.dart';
import 'package:anime_hub/providers/anime_detail_provider.dart';
import 'package:anime_hub/theme/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: AppSpacing.horizontalLg,
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                context.read<SearchProvider>().searchAnime(value);
              },
              style: context.textStyles.bodyLarge,
              decoration: InputDecoration(
                hintText: 'Search Anime',
                hintStyle: context.textStyles.bodyMedium?.copyWith(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        _searchController.clear();
                        context.read<SearchProvider>().clearSearch();
                      },
                    )
                  : null,
                filled: true,
                fillColor: const Color.fromARGB(255, 52, 52, 52),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Consumer<SearchProvider>(
              builder: (context, searchProvider, child) {
                if (searchProvider.query.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          size: 80,
                          color: Colors.grey.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Search for your favorite anime',
                          style: context.textStyles.titleMedium?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (searchProvider.isLoading) {
                  return const ShimmerSearchGrid();
                }

                if (searchProvider.searchResults.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 80,
                          color: Colors.grey.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No results found',
                          style: context.textStyles.titleMedium?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: AppSpacing.paddingLg,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.6,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: searchProvider.searchResults.length,
                  itemBuilder: (context, index) {
                    final anime = searchProvider.searchResults[index];
                    return GestureDetector(
                      onTap: () {
                        context.read<AnimeDetailProvider>().setCurrentAnime(anime);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AnimeDetailScreen()),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: anime.imageUrl != null
                                  ? CachedNetworkImage(
                                      imageUrl: anime.imageUrl!,
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                      fadeInDuration: const Duration(milliseconds: 300),
                                      fadeOutDuration: const Duration(milliseconds: 200),
                                      placeholder: (context, url) => Container(
                                        color: const Color(0xFF1A1E3A),
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            color: Color(0xFFE50914),
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) => Container(
                                        color: const Color(0xFF1A1E3A),
                                        child: const Icon(Icons.movie, color: Colors.grey, size: 48),
                                      ),
                                    )
                                  : Container(
                                      color: const Color(0xFF1A1E3A),
                                      child: const Icon(Icons.movie, color: Colors.grey, size: 48),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            anime.title,
                            style: context.textStyles.bodySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}

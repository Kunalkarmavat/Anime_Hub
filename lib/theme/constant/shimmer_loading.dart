import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerAnimeCard extends StatelessWidget {
  final double width;
  final double height;

  const ShimmerAnimeCard({
    super.key,
    this.width = 150,
    this.height = 220,
  });

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
    baseColor: const Color(0xFF1A1E3A),
    highlightColor: const Color(0xFF2A2E4A),
    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );
}

class ShimmerRandomAnime extends StatelessWidget {
  const ShimmerRandomAnime({super.key});

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
    baseColor: const Color(0xFF1A1E3A),
    highlightColor: const Color(0xFF2A2E4A),
    child: Container(
      height: 460,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.zero,
      ),
    ),
  );
}

class ShimmerSearchGrid extends StatelessWidget {
  const ShimmerSearchGrid({super.key});

  @override
  Widget build(BuildContext context) => GridView.builder(
    padding: const EdgeInsets.all(16),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 0.65,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
    ),
    itemCount: 10,
    itemBuilder: (context, index) => const ShimmerAnimeCard(
      width: double.infinity,
      height: double.infinity,
    ),
  );
}

class ShimmerUpcomingList extends StatelessWidget {
  const ShimmerUpcomingList({super.key});

  @override
  Widget build(BuildContext context) => ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: 5,
    itemBuilder: (context, index) => Shimmer.fromColors(
          baseColor: const Color(0xFF1A1E3A),
          highlightColor: const Color(0xFF2A2E4A),
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 110,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 18, width: double.infinity, color: Colors.white),
                      const SizedBox(height: 8),
                      Container(height: 12, width: 120, color: Colors.white),
                      const SizedBox(height: 8),
                      Container(height: 12, width: double.infinity, color: Colors.white),
                      const SizedBox(height: 6),
                      Container(height: 12, width: double.infinity, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
  );
}

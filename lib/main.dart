import 'package:anime_hub/presentation/main_navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anime_hub/theme/theme.dart';
import 'package:anime_hub/providers/home_provider.dart';
import 'package:anime_hub/providers/search_provider.dart';
import 'package:anime_hub/providers/anime_detail_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => HomeProvider()),
      ChangeNotifierProvider(create: (_) => SearchProvider()),
      ChangeNotifierProvider(create: (_) => AnimeDetailProvider()),
    ],
    child: MaterialApp(
      title: 'Anime Hub',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
      home: const MainNavigation(),
    ),
  );
}

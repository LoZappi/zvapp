import 'package:flutter/material.dart';

import 'data/requests_repo.dart';
import 'ui/screens/quick_start_screen.dart';
import 'ui/screens/requests_screen.dart';

void main() {
  runApp(const ZVApp());
}

class ZVApp extends StatelessWidget {
  const ZVApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = RequestsRepo();

    const zvYellow = Color(0xFFFFD200);
    const zvBlack = Color(0xFF111111);

    final theme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: zvYellow,
        brightness: Brightness.light,
      ).copyWith(
        primary: zvYellow,
        onPrimary: Colors.black,
        secondary: zvBlack,
        onSecondary: Colors.white,
      ),

      // opzionale ma utile: testo e AppBar più "decisi"
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      scaffoldBackgroundColor: const Color(0xFFF7F7FA),
      cardColor: Colors.white,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      routes: {
        '/': (_) => QuickStartScreen(repo: repo),
        '/requests': (_) => RequestsScreen(repo: repo),
      },
    );
  }
}

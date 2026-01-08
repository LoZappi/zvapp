import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'data/requests_repo.dart';
import 'ui/screens/shared/quick_start_screen.dart';
import 'ui/screens/anfragen/requests_screen.dart';

final RequestsRepo _globalRepo = RequestsRepo();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase init failed: $e');
  }
  
  runApp(const ZVApp());
}

class ZVApp extends StatelessWidget {
  const ZVApp({super.key});

  @override
  Widget build(BuildContext context) {
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
        '/': (_) => QuickStartScreen(repo: _globalRepo),
        '/requests': (_) => RequestsScreen(repo: _globalRepo),
      },
    );
  }
}

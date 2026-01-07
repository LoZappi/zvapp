import 'package:flutter/material.dart';
import 'ui/screens/home_shell_screen.dart';

class ZVColors {
  static const yellow = Color(0xFFFFD200);
  static const bg = Color(0xFFF3F4F6);
}

class ZVApp extends StatelessWidget {
  const ZVApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ZV Transport',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: ZVColors.bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: ZVColors.yellow,
        ),
      ),
      home: HomeShellScreen(), // <-- nessun parametro
    );
  }
}

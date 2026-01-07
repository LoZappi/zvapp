import 'package:flutter/material.dart';
import '../../data/requests_repo.dart';
import 'dashboard_screen.dart';

class HomeShellScreen extends StatelessWidget {
  final RequestsRepo repo;

  const HomeShellScreen({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    return DashboardScreen(repo: repo);
  }
}

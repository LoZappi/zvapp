import 'package:flutter/material.dart';

class ZVAppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? fab;

  /// routes
  final String homeRoute;
  final String requestsRoute;

  const ZVAppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.fab,
    this.homeRoute = '/home',
    this.requestsRoute = '/requests',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Home',
            icon: const Icon(Icons.home_rounded),
            onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(homeRoute, (r) => false),
          ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 10),
                child: Text(
                  'Z&V Transport',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
              ),
              const Divider(height: 1),

              ListTile(
                leading: const Icon(Icons.home_rounded),
                title: const Text('Home'),
                onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(homeRoute, (r) => false),
              ),
              ListTile(
                leading: const Icon(Icons.list_alt_rounded),
                title: const Text('Richieste'),
                onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(requestsRoute, (r) => false),
              ),

              const Divider(height: 1),

              ListTile(
                leading: const Icon(Icons.add_circle_outline),
                title: const Text('Nuova richiesta'),
                onTap: () {
                  Navigator.of(context).pop(); // close drawer
                  // se hai una route del wizard, mettila qui:
                  Navigator.of(context).pushNamed('/wizard');
                },
              ),
            ],
          ),
        ),
      ),
      body: body,
      floatingActionButton: fab,
    );
  }
}

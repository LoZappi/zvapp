import 'package:flutter/material.dart';
import '../../components/zv_card.dart';
import '../../components/zv_topbar.dart';

class AltrComingSoon extends StatelessWidget {
  const AltrComingSoon({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ZVTopBar(title: 'Altro', subtitle: 'Coming Soon'),
      body: Center(
        child: ZVCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.construction, size: 48, color: Color(0xFFFFD200)),
              SizedBox(height: 16),
              Text(
                'Coming Soon',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
              ),
              SizedBox(height: 8),
              Text(
                'Questa funzionalità sarà disponibile presto.',
                style: TextStyle(color: Color(0xFF666666)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

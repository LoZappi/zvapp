import 'package:flutter/material.dart';

import '../../data/requests_repo.dart';
import '../utils/request_ui_helpers.dart';

class RequestsScreen extends StatefulWidget {
  final RequestsRepo repo;
  const RequestsScreen({super.key, required this.repo});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  @override
  Widget build(BuildContext context) {
    final items = widget.repo.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Anfragen', style: TextStyle(fontWeight: FontWeight.w900)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: items.isEmpty
            ? const Center(child: Text('Nessun risultato.'))
            : ListView.separated(
                padding: const EdgeInsets.all(14),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final r = items[i];

                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0x11000000)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF3B0),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(color: const Color(0x33FFD200)),
                              ),
                              child: Text(
                                serviceLabel(r.service),
                                style: const TextStyle(fontWeight: FontWeight.w900),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              statusLabel(r.status),
                              style: const TextStyle(fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        if (r.name.trim().isNotEmpty)
                          Text(r.name, style: const TextStyle(fontWeight: FontWeight.w900)),

                        if (r.pickupAddress.trim().isNotEmpty || r.dropoffAddress.trim().isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              '${r.pickupAddress} → ${r.dropoffAddress}',
                              style: const TextStyle(color: Colors.black87),
                            ),
                          ),

                        const SizedBox(height: 8),

                        Text(
                          'Schätzung: ${r.estimateMin.toStringAsFixed(0)}–${r.estimateMax.toStringAsFixed(0)} €',
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.add),
        label: const Text('Neu', style: TextStyle(fontWeight: FontWeight.w900)),
      ),
    );
  }
}

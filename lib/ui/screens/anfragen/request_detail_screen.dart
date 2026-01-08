import 'package:flutter/material.dart';
import '../utils/request_ui_helpers.dart';
import '../../data/requests_repo.dart';
import '../../models/request.dart';
import '../components/zv_card.dart';
import '../components/zv_section_header.dart';
import '../components/zv_topbar.dart';

class RequestDetailScreen extends StatefulWidget {
  final RequestsRepo repo;
  final Request r;

  const RequestDetailScreen({super.key, required this.repo, required this.r});

  @override
  State<RequestDetailScreen> createState() => _RequestDetailScreenState();
}

class _RequestDetailScreenState extends State<RequestDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final r = widget.r;
    final extras = [
      if (r.disassembly) 'Demontage/Montage',
      if (r.packing) 'Verpackung',
      if (r.disposal) 'Entsorgung',
    ].join(' • ');

    return Scaffold(
      appBar: const ZVTopBar(title: 'Anfrage', subtitle: 'Details & Status'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ZVCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ZVBadge(text: serviceLabel(r.service)),
                const SizedBox(height: 10),
                Text(r.name.isEmpty ? '—' : r.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                Text(r.phone.isEmpty ? '—' : r.phone, style: const TextStyle(color: Color(0xFF6B7280))),
                if (r.email.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(r.email, style: const TextStyle(color: Color(0xFF6B7280))),
                ],
                const SizedBox(height: 10),
                Text(r.note.isEmpty ? '—' : r.note),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Text('Abholung: ${r.pickupAddress.isEmpty ? "—" : r.pickupAddress}'),
                Text('Ziel: ${r.dropoffAddress.isEmpty ? "—" : r.dropoffAddress}'),
                const SizedBox(height: 10),
                Text('Etage: ${r.pickupFloor} (Aufzug: ${r.pickupElevator ? "Ja" : "Nein"})  →  '
                    '${r.dropoffFloor} (Aufzug: ${r.dropoffElevator ? "Ja" : "Nein"})'),
                const SizedBox(height: 6),
                Text('Volumen: ${r.volumeM3.toStringAsFixed(1)} m³'),
                const SizedBox(height: 6),
                Text('Extras: ${extras.isEmpty ? "—" : extras}'),
                const SizedBox(height: 10),
                Text('Schätzung: ${r.estimateMin}–${r.estimateMax} €', style: const TextStyle(fontWeight: FontWeight.w900)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ZVCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Status', style: TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ZVStatus.values.map((s) {
                    final selected = r.status == s;
                    return ChoiceChip(
                      label: Text(statusLabel(s)),
                      selected: selected,
                      onSelected: (_) async {
                        setState(() => r.status = s);
                        await widget.repo.save();
                      },
                      selectedColor: const Color(0xFFFFD200),
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Color(0x1A111111)),
                      labelStyle: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF111111)),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ZVCard(
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await widget.repo.deleteById(r.id);
                      if (context.mounted) Navigator.pop(context);
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text('Löschen'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

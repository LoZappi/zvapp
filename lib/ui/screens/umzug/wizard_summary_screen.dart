import 'package:flutter/material.dart';

import '../../../models/request.dart';
import '../../theme/zv_colors.dart';
import '../../utils/request_ui_helpers.dart';
import '../../components/zv_card.dart';
import '../../components/zv_section_header.dart';
import '../../components/zv_step_bar.dart';
import '../../components/zv_topbar.dart';
import '../shared/wizard/wizard_state.dart';

class WizardSummaryScreen extends StatelessWidget {
  final WizardState st;
  const WizardSummaryScreen({super.key, required this.st});

  @override
  Widget build(BuildContext context) {
    final r = st.req;
    final extras = [
      if (r.disassembly) 'Demontage/Montage',
      if (r.packing) 'Verpackung',
      if (r.disposal) 'Entsorgung',
    ].join(' • ');

    return Scaffold(
      appBar: const ZVTopBar(title: 'Neues Angebot', subtitle: 'Schritt 5/5 – Zusammenfassung'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ZVStepBar(step: 5, total: 5, label: 'Riepilogo + Speichern'),
          const SizedBox(height: 12),
          ZVCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ZVBadge(text: serviceLabel(r.service)),
                const SizedBox(height: 10),
                Text('${r.name} • ${r.phone}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                if (r.email.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(r.email, style: TextStyle(color: ZVColors.textSecondary)),
                ],
                const SizedBox(height: 10),
                Text('Abholung: ${r.pickupAddress}'),
                Text('Ziel: ${r.dropoffAddress}'),
                const SizedBox(height: 10),
                Text('Etage: ${r.pickupFloor} (Aufzug: ${r.pickupElevator ? "Ja" : "Nein"})  →  '
                    '${r.dropoffFloor} (Aufzug: ${r.dropoffElevator ? "Ja" : "Nein"})'),
                const SizedBox(height: 6),
                Text('Volumen: ${r.volumeM3.toStringAsFixed(1)} m³'),
                const SizedBox(height: 6),
                Text('Extras: ${extras.isEmpty ? "—" : extras}'),
                const SizedBox(height: 10),
                if (r.note.isNotEmpty) Text('Notiz: ${r.note}'),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0x14FFD200),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0x33FFD200)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.euro, color: ZVColors.textPrimary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Schätzung: ${r.estimateMin}–${r.estimateMax} €',
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Zurück'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context, r),
                  icon: const Icon(Icons.check),
                  label: const Text('Speichern'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

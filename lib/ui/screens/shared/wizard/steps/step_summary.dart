import 'package:flutter/material.dart';
import '../../../../../models/request.dart';
import '../../../../utils/request_ui_helpers.dart';
import '../wizard_state.dart';

class SectionSummary extends StatelessWidget {
  final WizardState st;
  final VoidCallback onBack;

  const SectionSummary({
    super.key,
    required this.st,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final r = st.req;
    final isEntru = r.service == ZVService.entruempelung;

    final pt = r.priceType;
    final priceTypeText = (pt == null)
        ? '—'
        : (pt == PriceType.inspection ? 'Besichtigung' : priceTypeLabel(pt));

    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const Text(
          'Zusammenfassung',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 12),

        _card(
          title: 'Service',
          child: _line('Art', serviceLabel(r.service)),
        ),

        const SizedBox(height: 12),

        _card(
          title: 'Preis',
          child: Column(
            children: [
              _line('Preis-Typ', priceTypeText),
              const SizedBox(height: 6),
              _line(
                'Schätzung',
                '${r.estimateMin.toStringAsFixed(0)}–${r.estimateMax.toStringAsFixed(0)} €',
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        if (!isEntru) ...[
          _card(
            title: 'Details',
            child: Column(
              children: [
                _line('Volumen', '${r.volumeM3.toStringAsFixed(1)} m³'),
                _line('Abbau', r.disassembly ? 'Ja' : 'Nein'),
                _line('Packen', r.packing ? 'Ja' : 'Nein'),
                _line('Entsorgung', r.disposal ? 'Ja' : 'Nein'),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],

        if (isEntru) ...[
          _card(
            title: 'Entrümpelung',
            child: Column(
              children: [
                _line('Objekt', (r.entruType ?? '—').toString()),
                _line('Größe', (r.entruSize ?? '—').toString()),
                _line('Inhalt', r.entruItems.isEmpty ? '—' : r.entruItems.join(', ')),
                _line('Etage', '${r.entruFloor}'),
                _line('Aufzug', r.entruElevator ? 'Ja' : 'Nein'),
                _line('Parken', parkingLabel(r.entruParking)),
                _line('Demontage', r.entruDisassembly ? 'Ja' : 'Nein'),
                _line('Schwer', r.entruHeavy ? 'Ja' : 'Nein'),
                _line('Verschmutzt', r.entruDirty ? 'Ja' : 'Nein'),
                if ((r.entruOther ?? '').trim().isNotEmpty)
                  _line('Sonstiges', (r.entruOther ?? '').trim()),
                if ((r.entruNote ?? '').trim().isNotEmpty)
                  _line('Hinweise', (r.entruNote ?? '').trim()),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],

        _card(
          title: 'Kontakt',
          child: Column(
            children: [
              _line('Name', r.name.trim().isEmpty ? '—' : r.name.trim()),
              _line('Telefon', r.phone.trim().isEmpty ? '—' : r.phone.trim()),
              _line('E-Mail', r.email.trim().isEmpty ? '—' : r.email.trim()),
            ],
          ),
        ),

        const SizedBox(height: 12),

        _card(
          title: 'Adressen',
          child: Column(
            children: [
              _line('Abholung', r.pickupAddress.trim().isEmpty ? '—' : r.pickupAddress.trim()),
              _line('Ziel', r.dropoffAddress.trim().isEmpty ? '—' : r.dropoffAddress.trim()),
            ],
          ),
        ),

        const SizedBox(height: 14),

        OutlinedButton.icon(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back),
          label: const Text('Zurück', style: TextStyle(fontWeight: FontWeight.w900)),
        ),
      ],
    );
  }

  static Widget _card({required String title, required Widget child}) {
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
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  static Widget _line(String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(k, style: const TextStyle(color: Colors.black54)),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              v,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

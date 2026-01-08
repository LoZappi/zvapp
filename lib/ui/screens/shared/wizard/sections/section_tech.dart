import 'package:flutter/material.dart';

import '../wizard_state.dart';
import '../../../../../models/request.dart';

class SectionTech extends StatelessWidget {
  final WizardState st;

  /// chiamato quando cambi un valore (switch/slider/stepper)
  final VoidCallback onChanged;

  /// opzionali: se li passi dallo shell, qui creiamo i bottoni
  /// (ora NON li usiamo più: i bottoni stanno fissi sotto nello Shell)
  final VoidCallback? onNext;
  final VoidCallback? onBack;

  const SectionTech({
    super.key,
    required this.st,
    required this.onChanged,
    this.onNext,
    this.onBack,
  });

  Request get _r => st.req;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Header(
            title: 'Details & Technik',
            subtitle:
                'Etagen, Aufzug, Volumen und Zusatzleistungen – damit wir schnell und korrekt kalkulieren können.',
          ),
          const SizedBox(height: 12),

          _card(
            context,
            title: 'Etagen & Aufzug',
            child: Column(
              children: [
                _stepperRow(
                  context,
                  label: 'Abholadresse: Etage',
                  value: _r.pickupFloor,
                  min: 0,
                  max: 30,
                  onValue: (v) {
                    _r.pickupFloor = v;
                    onChanged();
                  },
                ),
                const SizedBox(height: 6),
                _switchRow(
                  label: 'Abholadresse: Aufzug vorhanden',
                  value: _r.pickupElevator,
                  onChanged: (v) {
                    _r.pickupElevator = v;
                    onChanged();
                  },
                ),
                const Divider(height: 22),
                _stepperRow(
                  context,
                  label: 'Zieladresse: Etage',
                  value: _r.dropoffFloor,
                  min: 0,
                  max: 30,
                  onValue: (v) {
                    _r.dropoffFloor = v;
                    onChanged();
                  },
                ),
                const SizedBox(height: 6),
                _switchRow(
                  label: 'Zieladresse: Aufzug vorhanden',
                  value: _r.dropoffElevator,
                  onChanged: (v) {
                    _r.dropoffElevator = v;
                    onChanged();
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          _card(
            context,
            title: 'Volumen (m³)',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Geschätztes Volumen: ${_r.volumeM3.toStringAsFixed(1)} m³',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Slider(
                  value: _r.volumeM3.clamp(0.0, 120.0),
                  min: 0,
                  max: 120,
                  divisions: 120,
                  label: _r.volumeM3.toStringAsFixed(1),
                  onChanged: (v) {
                    _r.volumeM3 = v;
                    onChanged();
                  },
                ),
                const SizedBox(height: 4),
                const Text(
                  'Tipp: 10–15 m³ ≈ 1 Zimmer, 25–35 m³ ≈ 2 Zimmer (nur grob).',
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          _card(
            context,
            title: 'Zusatzleistungen',
            child: Column(
              children: [
                _switchRow(
                  label: 'Möbel demontieren / montieren',
                  value: _r.disassembly,
                  onChanged: (v) {
                    _r.disassembly = v;
                    onChanged();
                  },
                ),
                _switchRow(
                  label: 'Einpackservice (Kartons / Schutz)',
                  value: _r.packing,
                  onChanged: (v) {
                    _r.packing = v;
                    onChanged();
                  },
                ),
                _switchRow(
                  label: 'Entsorgung / Sperrmüll',
                  value: _r.disposal,
                  onChanged: (v) {
                    _r.disposal = v;
                    onChanged();
                  },
                ),
              ],
            ),
          ),

          // ✅ NIENTE bottoni qui: adesso stanno fissi sotto nello Shell
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // ---------- UI helpers ----------

  Widget _card(BuildContext context, {required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _switchRow({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _stepperRow(
    BuildContext context, {
    required String label,
    required int value,
    required int min,
    required int max,
    required ValueChanged<int> onValue,
  }) {
    final v = value.clamp(min, max);
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        _iconBtn(
          context,
          icon: Icons.remove,
          onTap: v <= min ? null : () => onValue((v - 1).clamp(min, max)),
        ),
        SizedBox(
          width: 44,
          child: Center(
            child: Text(
              '$v',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ),
        _iconBtn(
          context,
          icon: Icons.add,
          onTap: v >= max ? null : () => onValue((v + 1).clamp(min, max)),
        ),
      ],
    );
  }

  Widget _iconBtn(BuildContext context, {required IconData icon, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black12),
          color: onTap == null ? Colors.black12 : Colors.transparent,
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  final String subtitle;

  const _Header({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
        const SizedBox(height: 6),
        Text(subtitle, style: const TextStyle(color: Colors.black54)),
      ],
    );
  }
}

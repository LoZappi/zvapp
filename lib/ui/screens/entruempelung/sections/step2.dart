import 'package:flutter/material.dart';

import '../../shared/wizard/wizard_state.dart';
import '../../../../models/request.dart';

class SectionEntruempelungStep2 extends StatelessWidget {
  final WizardState st;

  /// chiamato quando cambi un valore
  final VoidCallback onChanged;

  /// opzionali: non li usiamo qui (bottoni stanno nello Shell)
  final VoidCallback? onNext;
  final VoidCallback? onBack;

  const SectionEntruempelungStep2({
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
            title: 'Entrümpelung – Zugang',
            subtitle:
                'Etage, Aufzug, Trageweg und Genehmigungen – damit wir Zeit & Aufwand korrekt einschätzen.',
          ),
          const SizedBox(height: 12),

          _card(
            context,
            title: 'Zugang (Etage & Aufzug)',
            child: Column(
              children: [
                _stepperRow(
                  context,
                  label: 'Etage',
                  value: _r.entruFloor,
                  min: 0,
                  max: 30,
                  onValue: (v) {
                    _r.entruFloor = v;
                    onChanged();
                  },
                ),
                const SizedBox(height: 6),
                _switchRow(
                  label: 'Aufzug vorhanden',
                  value: _r.entruElevator,
                  onChanged: (v) {
                    _r.entruElevator = v;
                    onChanged();
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          _card(
            context,
            title: 'Parken / Trageweg',
            child: Column(
              children: [
                _radioRow<ParkingDistance>(
                  title: '< 10 m',
                  value: ParkingDistance.short,
                  groupValue: _r.entruParking,
                  onChanged: (v) {
                    _r.entruParking = v;
                    onChanged();
                  },
                ),
                _radioRow<ParkingDistance>(
                  title: '10 – 30 m',
                  value: ParkingDistance.medium,
                  groupValue: _r.entruParking,
                  onChanged: (v) {
                    _r.entruParking = v;
                    onChanged();
                  },
                ),
                _radioRow<ParkingDistance>(
                  title: '> 30 m',
                  value: ParkingDistance.long,
                  groupValue: _r.entruParking,
                  onChanged: (v) {
                    _r.entruParking = v;
                    onChanged();
                  },
                ),
                const SizedBox(height: 6),
                const Text(
                  'Hinweis: Langer Trageweg kann Zeit und Personal erhöhen.',
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          _card(
            context,
            title: 'Halteverbot / Genehmigung',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _radioRow<bool?>(
                  title: 'Noch unklar',
                  value: null,
                  groupValue: _r.entruPermitNeeded,
                  onChanged: (v) {
                    _r.entruPermitNeeded = v;
                    onChanged();
                  },
                ),
                _radioRow<bool?>(
                  title: 'Ja, wird benötigt',
                  value: true,
                  groupValue: _r.entruPermitNeeded,
                  onChanged: (v) {
                    _r.entruPermitNeeded = v;
                    onChanged();
                  },
                ),
                _radioRow<bool?>(
                  title: 'Nein',
                  value: false,
                  groupValue: _r.entruPermitNeeded,
                  onChanged: (v) {
                    _r.entruPermitNeeded = v;
                    onChanged();
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: TextEditingController(text: _r.entruPermitNote)
                    ..selection = TextSelection.collapsed(offset: _r.entruPermitNote.length),
                  onChanged: (v) {
                    _r.entruPermitNote = v.trim();
                    onChanged();
                  },
                  decoration: const InputDecoration(
                    labelText: 'Hinweis (optional)',
                    hintText: 'z.B. “Innenstadt, Halteverbot nötig”…',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          _card(
            context,
            title: 'Besonderheiten',
            child: Column(
              children: [
                _switchRow(
                  label: 'Demontage nötig',
                  value: _r.entruDisassembly,
                  onChanged: (v) {
                    _r.entruDisassembly = v;
                    onChanged();
                  },
                ),
                _switchRow(
                  label: 'Schwere Gegenstände',
                  value: _r.entruHeavy,
                  onChanged: (v) {
                    _r.entruHeavy = v;
                    onChanged();
                  },
                ),
                _switchRow(
                  label: 'Stark verschmutzt',
                  value: _r.entruDirty,
                  onChanged: (v) {
                    _r.entruDirty = v;
                    onChanged();
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          _card(
            context,
            title: 'Notiz (optional)',
            child: TextField(
              controller: TextEditingController(text: _r.entruNote ?? '')
                ..selection = TextSelection.collapsed(offset: (_r.entruNote ?? '').length),
              onChanged: (v) {
                _r.entruNote = v.trim();
                onChanged();
              },
              minLines: 3,
              maxLines: 6,
              decoration: const InputDecoration(
                hintText: 'Zugang, Zeiten, Besonderheiten, Hausregeln, usw.',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // ---------- UI helpers (stesso stile di SectionTech) ----------

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
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
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
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        ),
        _iconBtn(
          context,
          icon: Icons.remove,
          onTap: v <= min ? null : () => onValue((v - 1).clamp(min, max)),
        ),
        SizedBox(
          width: 44,
          child: Center(
            child: Text('$v', style: const TextStyle(fontWeight: FontWeight.w800)),
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

  Widget _radioRow<T>({
    required String title,
    required T value,
    required T groupValue,
    required ValueChanged<T> onChanged,
  }) {
    return RadioListTile<T>(
      contentPadding: EdgeInsets.zero,
      dense: true,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      value: value,
      groupValue: groupValue,
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
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

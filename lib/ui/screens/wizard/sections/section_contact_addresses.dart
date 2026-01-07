import 'package:flutter/material.dart';

import '../../../../models/request.dart';
import '../../../components/zv_card.dart';
import '../../../components/zv_section_header.dart';
import '../../../theme/zv_colors.dart';
import '../wizard_state.dart';

class SectionContactAddresses extends StatefulWidget {
  final WizardState st;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const SectionContactAddresses({
    super.key,
    required this.st,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<SectionContactAddresses> createState() => _SectionContactAddressesState();
}

class _SectionContactAddressesState extends State<SectionContactAddresses> {
  Request get r => widget.st.req;

  late final TextEditingController _nameC;
  late final TextEditingController _phoneC;
  late final TextEditingController _emailC;

  late final TextEditingController _pickupC;
  late final TextEditingController _dropoffC;

  late final TextEditingController _noteC;

  final List<TextEditingController> _stopControllers = [];

  @override
  void initState() {
    super.initState();

    _nameC = TextEditingController(text: r.name);
    _phoneC = TextEditingController(text: r.phone);
    _emailC = TextEditingController(text: r.email);

    _pickupC = TextEditingController(text: r.pickupAddress);
    _dropoffC = TextEditingController(text: r.dropoffAddress);

    _noteC = TextEditingController(text: r.note);

    for (final s in r.extraStops) {
      _stopControllers.add(TextEditingController(text: s));
    }
  }

  @override
  void dispose() {
    _nameC.dispose();
    _phoneC.dispose();
    _emailC.dispose();
    _pickupC.dispose();
    _dropoffC.dispose();
    _noteC.dispose();
    for (final c in _stopControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _syncToModel() {
    r.name = _nameC.text.trim();
    r.phone = _phoneC.text.trim();
    r.email = _emailC.text.trim();

    r.pickupAddress = _pickupC.text.trim();
    r.dropoffAddress = _dropoffC.text.trim();

    r.note = _noteC.text.trim();

    r.extraStops = _stopControllers
        .map((c) => c.text.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  bool _isValid() {
    final isEntru = r.service == ZVService.entruempelung;

    final nameOk = _nameC.text.trim().isNotEmpty;
    final phoneOk = _phoneC.text.trim().isNotEmpty;
    final pickupOk = _pickupC.text.trim().isNotEmpty;

    // per Entrümpelung spesso basta 1 indirizzo
    final dropOk = isEntru ? true : _dropoffC.text.trim().isNotEmpty;

    return nameOk && phoneOk && pickupOk && dropOk;
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initial = r.date ?? now;

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 2),
    );

    if (picked == null) return;
    setState(() => r.date = picked);
  }

  void _addStop() {
    setState(() => _stopControllers.add(TextEditingController()));
  }

  void _removeStop(int i) {
    setState(() {
      _stopControllers[i].dispose();
      _stopControllers.removeAt(i);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEntru = r.service == ZVService.entruempelung;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      children: [
        const ZVSectionHeader(
          badge: 'KONTAKT & ADRESSEN',
          title: 'Daten für die Anfrage',
          subtitle: 'Kontakt + Start/Ziel + optionale Zusatzstopps.',
        ),
        const SizedBox(height: 12),

        _blockTitle('Kontakt'),
        const SizedBox(height: 8),
        ZVCard(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              _field(
                controller: _nameC,
                label: 'Name & Nachname',
                icon: Icons.person,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 10),
              _field(
                controller: _phoneC,
                label: 'Telefon',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 10),
              _field(
                controller: _emailC,
                label: 'E-Mail (optional)',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        _blockTitle('Adresse(n)'),
        const SizedBox(height: 8),
        ZVCard(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              _field(
                controller: _pickupC,
                label: isEntru ? 'Adresse (Ort der Entrümpelung)' : 'Abholadresse (Start)',
                icon: Icons.place,
                onChanged: (_) => setState(() {}),
              ),

              if (!isEntru) ...[
                const SizedBox(height: 10),
                _field(
                  controller: _dropoffC,
                  label: 'Zieladresse (Abladen)',
                  icon: Icons.flag,
                  onChanged: (_) => setState(() {}),
                ),
              ],

              const SizedBox(height: 10),

              if (_stopControllers.isNotEmpty) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Zwischenstopps / weitere Adressen',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: ZVColors.textPrimary.withOpacity(0.9),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],

              ...List.generate(_stopControllers.length, (i) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: _field(
                          controller: _stopControllers[i],
                          label: 'Zusatzadresse ${i + 1}',
                          icon: Icons.alt_route,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () => _removeStop(i),
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                );
              }),

              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton.icon(
                  onPressed: _addStop,
                  icon: const Icon(Icons.add),
                  label: const Text('Adresse hinzufügen'),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        _blockTitle('Datum & Hinweis (optional)'),
        const SizedBox(height: 8),
        ZVCard(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    color: ZVColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: ZVColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.event),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          r.date == null
                              ? 'Datum wählen'
                              : '${r.date!.day.toString().padLeft(2, '0')}.${r.date!.month.toString().padLeft(2, '0')}.${r.date!.year}',
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _noteC,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Hinweise (z.B. Zwischenstopp/Smistamento, Zeitfenster…)',
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  _syncToModel();
                  widget.onBack();
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('Zurück'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _isValid()
                    ? () {
                        _syncToModel();
                        widget.onNext();
                      }
                    : null,
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Weiter'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _blockTitle(String t) {
    return Text(
      t,
      style: const TextStyle(
        fontWeight: FontWeight.w900,
        color: ZVColors.textPrimary,
        fontSize: 14,
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    void Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
    );
  }
}

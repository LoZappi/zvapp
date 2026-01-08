import 'package:flutter/material.dart';

import '../../../../../models/request.dart';
import '../../../../components/zv_card.dart';
import '../../../../components/zv_section_header.dart';
import '../../../../theme/zv_colors.dart';
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

  void _applyData() {
    r.name = _nameC.text.trim();
    r.phone = _phoneC.text.trim();
    r.email = _emailC.text.trim();
    r.pickupAddress = _pickupC.text.trim();
    r.dropoffAddress = _dropoffC.text.trim();
    r.note = _noteC.text.trim();
    r.extraStops = _stopControllers.map((c) => c.text.trim()).where((s) => s.isNotEmpty).toList();
  }

  bool get _canContinue {
    return _nameC.text.trim().isNotEmpty &&
        _phoneC.text.trim().isNotEmpty &&
        _pickupC.text.trim().isNotEmpty &&
        _dropoffC.text.trim().isNotEmpty;
  }

  void _addStop() {
    setState(() {
      _stopControllers.add(TextEditingController());
    });
  }

  void _removeStop(int index) {
    setState(() {
      _stopControllers[index].dispose();
      _stopControllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const ZVSectionHeader(title: 'Kontakt'),
        const SizedBox(height: 8),
        ZVCard(
          child: Column(
            children: [
              TextField(
                controller: _nameC,
                decoration: const InputDecoration(labelText: 'Name *'),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _phoneC,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Telefon *'),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _emailC,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'E-Mail'),
                onChanged: (_) => setState(() {}),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const ZVSectionHeader(title: 'Adressen'),
        const SizedBox(height: 8),
        ZVCard(
          child: Column(
            children: [
              TextField(
                controller: _pickupC,
                decoration: const InputDecoration(labelText: 'Abholadresse *'),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _dropoffC,
                decoration: const InputDecoration(labelText: 'Zieladresse *'),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              ..._stopControllers.asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: entry.value,
                          decoration: InputDecoration(labelText: 'Zwischenhalt ${entry.key + 1}'),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () => _removeStop(entry.key),
                      ),
                    ],
                  ),
                );
              }),
              TextButton.icon(
                onPressed: _addStop,
                icon: const Icon(Icons.add),
                label: const Text('Zwischenhalt hinzufuegen'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const ZVSectionHeader(title: 'Notiz'),
        const SizedBox(height: 8),
        ZVCard(
          child: TextField(
            controller: _noteC,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Zusaetzliche Informationen',
              alignLabelWithHint: true,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: widget.onBack,
                icon: const Icon(Icons.arrow_back),
                label: const Text('Zurueck'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _canContinue
                    ? () {
                        _applyData();
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
}

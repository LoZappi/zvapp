import 'package:flutter/material.dart';

import '../../../models/request.dart';
import '../../components/zv_card.dart';
import '../../components/zv_number_field.dart';
import '../../components/zv_step_bar.dart';
import '../../components/zv_topbar.dart';
import 'wizard_state.dart';
import 'wizard_summary_screen.dart';

class WizardDetailsScreen extends StatefulWidget {
  final WizardState st;
  const WizardDetailsScreen({super.key, required this.st});

  @override
  State<WizardDetailsScreen> createState() => _WizardDetailsScreenState();
}

class _WizardDetailsScreenState extends State<WizardDetailsScreen> {
  late final TextEditingController volume;

  @override
  void initState() {
    super.initState();
    final v = widget.st.req.volumeM3;
    volume = TextEditingController(text: v <= 0 ? '' : v.toStringAsFixed(1));
  }

  @override
  void dispose() {
    volume.dispose();
    super.dispose();
  }

  void _applyVolume() {
    final v = double.tryParse(volume.text.replaceAll(',', '.').trim()) ?? 0;
    widget.st.req.volumeM3 = v < 0 ? 0 : v;
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.st.req;

    return Scaffold(
      appBar: const ZVTopBar(title: 'Neues Angebot', subtitle: 'Schritt 4/5 – Details'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ZVStepBar(step: 4, total: 5, label: 'Etage, Aufzug, Volumen, Extras + neue Daten'),
          const SizedBox(height: 12),

          // --- floors + elevator + volume + base extras
          ZVCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Abholung', style: TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ZVNumberField(
                        label: 'Etage',
                        value: r.pickupFloor,
                        onChanged: (v) => setState(() => r.pickupFloor = v),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Aufzug'),
                        value: r.pickupElevator,
                        onChanged: (v) => setState(() => r.pickupElevator = v),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 22),
                const Text('Ziel', style: TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ZVNumberField(
                        label: 'Etage',
                        value: r.dropoffFloor,
                        onChanged: (v) => setState(() => r.dropoffFloor = v),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Aufzug'),
                        value: r.dropoffElevator,
                        onChanged: (v) => setState(() => r.dropoffElevator = v),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 22),
                TextField(
                  controller: volume,
                  decoration: const InputDecoration(labelText: 'Volumen (m³)', hintText: 'z.B. 12.0'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                const Text('Extras', style: TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Demontage / Montage'),
                  value: r.disassembly,
                  onChanged: (v) => setState(() => r.disassembly = v ?? false),
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Verpackung'),
                  value: r.packing,
                  onChanged: (v) => setState(() => r.packing = v ?? false),
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Entsorgung'),
                  value: r.disposal,
                  onChanged: (v) => setState(() => r.disposal = v ?? false),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // --- NEW: Critical items
          ZVCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Oggetti critici (ingombranti)', style: TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 10),
                _QtyRow(
                  label: 'Waschmaschine',
                  value: r.washingMachine,
                  onChanged: (v) => setState(() => r.washingMachine = v),
                ),
                _QtyRow(
                  label: 'Trockner',
                  value: r.dryer,
                  onChanged: (v) => setState(() => r.dryer = v),
                ),
                _QtyRow(
                  label: 'Kühlschrank',
                  value: r.fridge,
                  onChanged: (v) => setState(() => r.fridge = v),
                ),
                _QtyRow(
                  label: 'Großes/Ecksofa',
                  value: r.sofaLarge,
                  onChanged: (v) => setState(() => r.sofaLarge = v),
                ),
                _QtyRow(
                  label: 'Schrank > 2m',
                  value: r.wardrobeLarge,
                  onChanged: (v) => setState(() => r.wardrobeLarge = v),
                ),
                _QtyRow(
                  label: 'TV > 65"',
                  value: r.tvLarge,
                  onChanged: (v) => setState(() => r.tvLarge = v),
                ),
                const SizedBox(height: 4),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Special Item (Piano / Safe / sehr schwer)'),
                  subtitle: const Text('Forza “Preis nach Besichtigung”'),
                  value: r.specialItem,
                  onChanged: (v) => setState(() => r.specialItem = v),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // --- NEW: Accessibility
          ZVCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Accessibilità', style: TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 10),
                const Text('Distanza parcheggio → ingresso', style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ParkingDistance.values.map((d) {
                    final selected = r.parkingDistance == d;
                    return ChoiceChip(
                      label: Text(parkingLabel(d)),
                      selected: selected,
                      onSelected: (_) => setState(() => r.parkingDistance = d),
                      selectedColor: const Color(0xFFFFD200),
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Color(0x1A111111)),
                      labelStyle: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF111111)),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Zona difficile (Altstadt / Baustelle / Fußgängerzone)'),
                  value: r.difficultZone,
                  onChanged: (v) => setState(() => r.difficultZone = v ?? false),
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Orario limitato (solo mattina/pomeriggio)'),
                  value: r.timeRestricted,
                  onChanged: (v) => setState(() => r.timeRestricted = v ?? false),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // --- NEW: Price type
          ZVCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tipo preventivo', style: TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 10),
                RadioListTile<PriceType>(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Pauschalpreis (fisso)'),
                  value: PriceType.fixed,
                  groupValue: r.priceType,
                  onChanged: (v) => setState(() => r.priceType = v!),
                ),
                RadioListTile<PriceType>(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Preisspanne (stimata)'),
                  value: PriceType.range,
                  groupValue: r.priceType,
                  onChanged: (v) => setState(() => r.priceType = v!),
                ),
                RadioListTile<PriceType>(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Preis nach Besichtigung (sopralluogo)'),
                  value: PriceType.inspection,
                  groupValue: r.priceType,
                  onChanged: (v) => setState(() => r.priceType = v!),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Nota: “Special Item”, volumi molto alti o situazioni difficili forzano il sopralluogo.',
                  style: TextStyle(color: Color(0xFF6B7280), fontSize: 12),
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
                  onPressed: () {
                    _applyVolume();
                    widget.st.computeEstimate();
                    Navigator.push(context, MaterialPageRoute(builder: (_) => WizardSummaryScreen(st: widget.st)));
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Weiter'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QtyRow extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  const _QtyRow({required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final v = value.clamp(0, 99);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w800))),
          IconButton(
            onPressed: () => onChanged((v - 1).clamp(0, 99)),
            icon: const Icon(Icons.remove),
          ),
          Text('$v', style: const TextStyle(fontWeight: FontWeight.w900)),
          IconButton(
            onPressed: () => onChanged((v + 1).clamp(0, 99)),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

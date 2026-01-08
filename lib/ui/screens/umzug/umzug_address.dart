import 'package:flutter/material.dart';

import '../../theme/zv_colors.dart';
import '../../components/zv_card.dart';
import '../../components/zv_step_bar.dart';
import '../../components/zv_topbar.dart';
import '../shared/wizard/wizard_state.dart';
import 'umzug_details.dart';

class WizardAddressScreen extends StatefulWidget {
  final WizardState st;
  const WizardAddressScreen({super.key, required this.st});

  @override
  State<WizardAddressScreen> createState() => _WizardAddressScreenState();
}

class _WizardAddressScreenState extends State<WizardAddressScreen> {
  late final TextEditingController pickup;
  late final TextEditingController dropoff;

  @override
  void initState() {
    super.initState();
    pickup = TextEditingController(text: widget.st.req.pickupAddress);
    dropoff = TextEditingController(text: widget.st.req.dropoffAddress);
  }

  @override
  void dispose() {
    pickup.dispose();
    dropoff.dispose();
    super.dispose();
  }

  bool get ok => pickup.text.trim().isNotEmpty && dropoff.text.trim().isNotEmpty;

  void _apply() {
    widget.st.req.pickupAddress = pickup.text.trim();
    widget.st.req.dropoffAddress = dropoff.text.trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ZVTopBar(title: 'Neues Angebot', subtitle: 'Schritt 3/5 – Adressen'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ZVStepBar(step: 3, total: 5, label: 'Abholung & Ziel'),
          const SizedBox(height: 12),
          ZVCard(
            child: Column(
              children: [
                TextField(
                  controller: pickup,
                  decoration: const InputDecoration(labelText: 'Abholadresse*', hintText: 'Straße, PLZ Ort'),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: dropoff,
                  decoration: const InputDecoration(labelText: 'Zieladresse*', hintText: 'Straße, PLZ Ort'),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Autocomplete (Google) lo aggiungiamo dopo. Per ora manuale.',
                  style: TextStyle(color: ZVColors.textSecondary, fontSize: 12),
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
                  onPressed: !ok
                      ? null
                      : () {
                          _apply();
                          Navigator.push(context, MaterialPageRoute(builder: (_) => WizardDetailsScreen(st: widget.st)));
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

import 'package:flutter/material.dart';
import '../wizard_state.dart';

class SectionAddresses extends StatefulWidget {
  final WizardState st;

  // rimangono per compatibilità, ma NON usati qui (barra fissa nello Shell)
  final VoidCallback onNext;
  final VoidCallback onBack;

  const SectionAddresses({
    super.key,
    required this.st,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<SectionAddresses> createState() => _SectionAddressesState();
}

class _SectionAddressesState extends State<SectionAddresses> {
  late final TextEditingController fromC;
  late final TextEditingController toC;

  @override
  void initState() {
    super.initState();
    fromC = TextEditingController(text: widget.st.req.pickupAddress);
    toC = TextEditingController(text: widget.st.req.dropoffAddress);
  }

  @override
  void dispose() {
    fromC.dispose();
    toC.dispose();
    super.dispose();
  }

  void _apply() {
    widget.st.req.pickupAddress = fromC.text.trim();
    widget.st.req.dropoffAddress = toC.text.trim();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ auto-save quando esci dal campo (utile, e non pesa)
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const Text(
          'Adressen & Datum',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 10),

        TextField(
          controller: fromC,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(labelText: 'Abholadresse'),
          onChanged: (_) => _apply(),
          onEditingComplete: _apply,
        ),
        const SizedBox(height: 10),

        TextField(
          controller: toC,
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(labelText: 'Zieladresse'),
          onChanged: (_) => _apply(),
          onEditingComplete: _apply,
        ),

        // ✅ NIENTE bottoni qui: adesso stanno fissi sotto nello Shell
        const SizedBox(height: 10),
      ],
    );
  }
}

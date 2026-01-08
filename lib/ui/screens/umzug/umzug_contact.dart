import 'package:flutter/material.dart';

import '../../components/zv_card.dart';
import '../../components/zv_step_bar.dart';
import '../../components/zv_topbar.dart';
import '../shared/wizard/wizard_state.dart';
import 'umzug_address.dart';

class WizardContactScreen extends StatefulWidget {
  final WizardState st;
  const WizardContactScreen({super.key, required this.st});

  @override
  State<WizardContactScreen> createState() => _WizardContactScreenState();
}

class _WizardContactScreenState extends State<WizardContactScreen> {
  late final TextEditingController name;
  late final TextEditingController phone;
  late final TextEditingController email;
  late final TextEditingController note;

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.st.req.name);
    phone = TextEditingController(text: widget.st.req.phone);
    email = TextEditingController(text: widget.st.req.email);
    note = TextEditingController(text: widget.st.req.note);
  }

  @override
  void dispose() {
    name.dispose();
    phone.dispose();
    email.dispose();
    note.dispose();
    super.dispose();
  }

  bool get ok => name.text.trim().isNotEmpty && phone.text.trim().isNotEmpty;

  void _apply() {
    widget.st.req.name = name.text.trim();
    widget.st.req.phone = phone.text.trim();
    widget.st.req.email = email.text.trim();
    widget.st.req.note = note.text.trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ZVTopBar(title: 'Neues Angebot', subtitle: 'Schritt 2/5 – Kontakt'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ZVStepBar(step: 2, total: 5, label: 'Kontakt erfassen'),
          const SizedBox(height: 12),
          ZVCard(
            child: Column(
              children: [
                TextField(
                  controller: name,
                  decoration: const InputDecoration(labelText: 'Name*', hintText: 'z.B. Sven Müller'),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: phone,
                  decoration: const InputDecoration(labelText: 'Telefon*', hintText: '+49 ...'),
                  keyboardType: TextInputType.phone,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: email,
                  decoration: const InputDecoration(labelText: 'E-Mail (optional)', hintText: 'kunde@mail.de'),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: note,
                  decoration: const InputDecoration(
                    labelText: 'Notiz (kurz)',
                    hintText: 'z.B. 4. Stock, ohne Aufzug, Stuttgart → Filderstadt',
                  ),
                  maxLines: 3,
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
                          Navigator.push(context, MaterialPageRoute(builder: (_) => WizardAddressScreen(st: widget.st)));
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

import 'package:flutter/material.dart';

import '../../../../models/request.dart';
import '../../../components/zv_card.dart';
import '../../../components/zv_section_header.dart';
import '../../../theme/zv_colors.dart';
import '../wizard_state.dart';

class SectionContact extends StatefulWidget {
  final WizardState st;

  // lasciati per compatibilità, ma NON usati qui (per evitare doppi bottoni)
  final VoidCallback onNext;
  final VoidCallback onBack;

  const SectionContact({
    super.key,
    required this.st,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<SectionContact> createState() => _SectionContactState();
}

class _SectionContactState extends State<SectionContact> {
  Request get r => widget.st.req;

  late final TextEditingController _nameC;
  late final TextEditingController _phoneC;
  late final TextEditingController _emailC;

  @override
  void initState() {
    super.initState();
    _nameC = TextEditingController(text: r.name);
    _phoneC = TextEditingController(text: r.phone);
    _emailC = TextEditingController(text: r.email);
  }

  @override
  void dispose() {
    _nameC.dispose();
    _phoneC.dispose();
    _emailC.dispose();
    super.dispose();
  }

  InputDecoration _dec(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: ZVColors.surface,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: ZVColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: ZVColors.primary.withValues(alpha: 0.9), width: 2),
      ),
      isDense: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      children: [
        const ZVSectionHeader(
          badge: 'KONTAKT',
          title: 'Kontaktangaben',
          subtitle: 'Damit wir dich schnell erreichen können.',
        ),
        const SizedBox(height: 12),

        ZVCard(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              TextField(
                controller: _nameC,
                decoration: _dec('Name & Nachname', hint: 'z.B. Mario Rossi'),
                textInputAction: TextInputAction.next,
                onChanged: (v) => r.name = v.trim(),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: _phoneC,
                decoration: _dec('Telefon', hint: '+49 ...'),
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                onChanged: (v) => r.phone = v.trim(),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: _emailC,
                decoration: _dec('E-Mail', hint: 'name@mail.de'),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                onChanged: (v) => r.email = v.trim(),
              ),
            ],
          ),
        ),

        // spazio sotto per non finire dietro la bottom bar globale
        const SizedBox(height: 80),
      ],
    );
  }
}

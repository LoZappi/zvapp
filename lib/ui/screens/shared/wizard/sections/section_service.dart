import 'package:flutter/material.dart';
import '../wizard_state.dart';
import '../../../../models/request.dart';

class SectionService extends StatelessWidget {
  final WizardState st;
  final VoidCallback onNext;

  const SectionService({
    super.key,
    required this.st,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final r = st.req;

    Widget tile({
      required String title,
      required String subtitle,
      required IconData icon,
      required ZVService value,
    }) {
      final selected = r.service == value;

      return InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          r.service = value;
          onNext();
        },
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFFFF3B0) : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? const Color(0x33FFD200) : const Color(0x11000000),
            ),
            boxShadow: const [
              BoxShadow(
                blurRadius: 10,
                offset: Offset(0, 4),
                color: Color(0x0A000000),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD200),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: const Color(0xFF111111)),
              ),
              const SizedBox(height: 10),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.black54, fontSize: 12.5),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  selected ? Icons.check_circle : Icons.arrow_forward,
                  size: 18,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Was brauchen Sie?',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          const Text(
            'Wählen Sie den Service aus:',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 14),
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.05,
            ),
            children: [
              tile(
                title: 'Umzug',
                subtitle: 'Privat & Gewerbe',
                icon: Icons.home_work,
                value: ZVService.umzug,
              ),
              tile(
                title: 'Transport',
                subtitle: 'Möbel, Geräte, Kartons',
                icon: Icons.local_shipping,
                value: ZVService.transport,
              ),
              tile(
                title: 'Entrümpelung',
                subtitle: 'Keller, Wohnung, Haus',
                icon: Icons.delete_sweep,
                value: ZVService.entruempelung,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

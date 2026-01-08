import 'package:flutter/material.dart';
import '../wizard_shell_screen.dart';
import '../wizard_state.dart';

class SectionHome extends StatelessWidget {
  final WizardState st;
  final void Function(WizardSection section) onOpen;

  const SectionHome({
    super.key,
    required this.st,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final items = <_HomeItem>[
      _HomeItem(
        title: 'Preis-Typ',
        subtitle: 'Pauschal / Spanne / Besichtigung',
        icon: Icons.tune,
        section: WizardSection.priceType,
      ),
      _HomeItem(
        title: 'Daten (Preis)',
        subtitle: 'Etage, Aufzug, m³, Extras',
        icon: Icons.calculate,
        section: WizardSection.tech,
      ),
      _HomeItem(
        title: 'Inventar',
        subtitle: 'Möbelliste & Mengen',
        icon: Icons.chair_alt,
        section: WizardSection.inventory,
      ),
      _HomeItem(
        title: 'Adressen & Datum',
        subtitle: 'Abholung, Ziel, Termin',
        icon: Icons.place,
        section: WizardSection.addresses,
      ),
      _HomeItem(
        title: 'Kontakt',
        subtitle: 'Name, Telefon, E-Mail',
        icon: Icons.person,
        section: WizardSection.contact,
      ),
      _HomeItem(
        title: 'Zusammenfassung',
        subtitle: 'Final check & senden',
        icon: Icons.request_quote,
        section: WizardSection.summary,
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Start',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          const Text(
            'Wähle einen Bereich aus:',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 14),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.05,
            ),
            itemBuilder: (context, i) {
              final it = items[i];
              return InkWell(
                onTap: () => onOpen(it.section),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0x11000000)),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 10,
                        spreadRadius: 0,
                        offset: Offset(0, 4),
                        color: Color(0x0A000000),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3B0),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0x33FFD200)),
                        ),
                        child: Icon(it.icon, color: const Color(0xFF111111)),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        it.title,
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        it.subtitle,
                        style: const TextStyle(color: Colors.black54, fontSize: 12.5),
                      ),
                      const Spacer(),
                      const Align(
                        alignment: Alignment.bottomRight,
                        child: Icon(Icons.arrow_forward, size: 18, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _HomeItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final WizardSection section;

  _HomeItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.section,
  });
}

import 'package:flutter/material.dart';

class EntruHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const EntruHeader({super.key, required this.title, required this.subtitle});

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

Widget entruCard(BuildContext context, {required String title, required Widget child}) {
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

Widget entruIconPill({required bool selected, required IconData icon}) {
  return Container(
    width: 34,
    height: 34,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: selected ? const Color(0x33FFD200) : Colors.black12),
      color: selected ? const Color(0xFFFFE27A) : Colors.transparent,
    ),
    child: Icon(icon, size: 18),
  );
}

Widget entruInfoBox() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFFFFF7D6),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0x33FFD200)),
    ),
    child: const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.info_outline, color: Color(0xFF8A6D00)),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            'Bitte wähle nur die Abfallarten, die entsorgt werden müssen. '
            'Je genauer die Auswahl und die Fotos, desto präziser wird das Angebot.',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    ),
  );
}

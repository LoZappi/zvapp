import 'package:flutter/material.dart';

import '../wizard_state.dart';
import '../../../../../models/request.dart';

class SectionInventory extends StatefulWidget {
  final WizardState st;

  // rimangono per compatibilità, ma NON usati qui (barra fissa nello Shell)
  final VoidCallback onNext;
  final VoidCallback onBack;

  const SectionInventory({
    super.key,
    required this.st,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<SectionInventory> createState() => _SectionInventoryState();
}

class _SectionInventoryState extends State<SectionInventory> {
  final _search = TextEditingController();

  // Lista base (puoi aggiungere/rimuovere voci quando vuoi)
  final List<String> _defaults = const [
    'Kartons',
    'Kleiderschrank',
    'Kommode',
    'Bett (Einzel)',
    'Bett (Doppel)',
    'Matratze',
    'Sofa 2-Sitzer',
    'Sofa 3-Sitzer',
    'Sessel',
    'Couchtisch',
    'Esstisch',
    'Stühle',
    'TV / Monitor',
    'TV-Board',
    'Regal',
    'Schreibtisch',
    'Bürostuhl',
    'Waschmaschine',
    'Trockner',
    'Kühlschrank',
    'Gefrierschrank',
    'Spülmaschine',
    'Mikrowelle',
    'Herd / Ofen',
    'Fahrrad',
  ];

  Request get _r => widget.st.req;

  int _qty(String key) => (_r.inventory[key] ?? 0);

  void _setQty(String key, int v) {
    final next = v.clamp(0, 999);
    setState(() {
      if (next <= 0) {
        _r.inventory.remove(key);
      } else {
        _r.inventory[key] = next;
      }
    });
  }

  void _inc(String key) => _setQty(key, _qty(key) + 1);
  void _dec(String key) => _setQty(key, _qty(key) - 1);

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = _search.text.trim().toLowerCase();

    // Mostra prima la lista base, poi eventuali extra già inseriti dall’utente
    final extras = _r.inventory.keys.where((k) => !_defaults.contains(k)).toList()..sort();
    final all = [..._defaults, ...extras]
        .where((k) => q.isEmpty ? true : k.toLowerCase().contains(q))
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Inventar (Möbelliste)',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          const Text(
            'Tippe auf + / − um Mengen zu setzen. Du kannst auch eigene Artikel hinzufügen.',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _search,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Suchen… (z.B. Sofa, Kartons, Waschmaschine)',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              isDense: true,
            ),
          ),
          const SizedBox(height: 12),

          _addCustom(context),

          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(14),
              color: Colors.white,
            ),
            child: Column(
              children: all.map((label) {
                final v = _qty(label);
                return Column(
                  children: [
                    ListTile(
                      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
                      trailing: _qtyControl(context, label, v),
                    ),
                    if (label != all.last) const Divider(height: 1),
                  ],
                );
              }).toList(),
            ),
          ),

          // ✅ NIENTE bottoni qui: adesso stanno fissi sotto nello Shell
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _qtyControl(BuildContext context, String key, int v) {
    Widget btn(IconData icon, VoidCallback? onTap) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black12),
            color: onTap == null ? Colors.black12 : Colors.transparent,
          ),
          child: Icon(icon, size: 18),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        btn(Icons.remove, v <= 0 ? null : () => _dec(key)),
        SizedBox(
          width: 40,
          child: Center(
            child: Text('$v', style: const TextStyle(fontWeight: FontWeight.w900)),
          ),
        ),
        btn(Icons.add, () => _inc(key)),
      ],
    );
  }

  Widget _addCustom(BuildContext context) {
    final custom = TextEditingController();

    void add() {
      final t = custom.text.trim();
      if (t.isEmpty) return;
      _setQty(t, _qty(t) <= 0 ? 1 : _qty(t));
      custom.clear();
      setState(() {});
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(14),
        color: const Color(0xFFF7F7F8),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: custom,
              decoration: const InputDecoration(
                hintText: 'Eigenen Artikel hinzufügen (z.B. Klavier)',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onSubmitted: (_) => add(),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton.icon(
            onPressed: add,
            icon: const Icon(Icons.add),
            label: const Text('Hinzufügen'),
          ),
        ],
      ),
    );
  }
}

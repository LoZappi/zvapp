import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../shared/wizard/wizard_state.dart';
import '../../../../models/request.dart';

class SectionEntruempelungStep1 extends StatefulWidget {
  final WizardState st;

  // compatibilità (bottoni nello Shell)
  final VoidCallback onNext;
  final VoidCallback onBack;

  // opzionale: aggiorna Chip/UI sopra
  final VoidCallback? onChanged;

  const SectionEntruempelungStep1({
    super.key,
    required this.st,
    required this.onNext,
    required this.onBack,
    this.onChanged,
  });

  @override
  State<SectionEntruempelungStep1> createState() => _SectionEntruempelungStep1State();
}

class _SectionEntruempelungStep1State extends State<SectionEntruempelungStep1> {
  final _picker = ImagePicker();
  late final TextEditingController otherC;

  Request get _r => widget.st.req;

  @override
  void initState() {
    super.initState();
    otherC = TextEditingController(text: _r.entruOther ?? '');
  }

  @override
  void dispose() {
    otherC.dispose();
    super.dispose();
  }

  void _touch() => widget.onChanged?.call();

  // ----------------- Categorie discarica -----------------
  static const _cats = <_WasteCat>[
    _WasteCat('Restmüll', 'nicht verwertbar', Icons.delete_outline),
    _WasteCat('Sperrmüll', 'große sperrige Teile', Icons.weekend_outlined),
    _WasteCat('Elektrogeräte', 'Waschmaschine, Kühlschrank…', Icons.electrical_services_outlined),
    _WasteCat('Schrott / Metall', 'Metallteile, Eisen…', Icons.construction_outlined),
    _WasteCat('Holz', 'Möbelholz, Bretter…', Icons.forest_outlined),
    _WasteCat('Bauschutt', 'Steine, Fliesen, Beton…', Icons.home_work_outlined),
    _WasteCat('Papier / Kartons', 'Karton, Papier', Icons.inventory_2_outlined),
    _WasteCat('Glas', 'Glas / Spiegel', Icons.wine_bar_outlined),
    _WasteCat('Textilien', 'Kleidung, Teppich…', Icons.checkroom_outlined),
    _WasteCat('Grünschnitt', 'Gartenabfälle', Icons.grass_outlined),
    _WasteCat('Sondermüll', 'Farben, Chemie, Öl…', Icons.warning_amber_outlined),
    _WasteCat('Batterien / Akkus', 'E-Bike, Auto, Geräte', Icons.battery_charging_full_outlined),
  ];

  bool _isSelected(String key) => _r.entruItems.contains(key);

  void _toggle(String key) {
    setState(() {
      if (_isSelected(key)) {
        _r.entruItems.remove(key);
      } else {
        _r.entruItems.add(key);
      }
    });
    _touch();
  }

  Future<void> _pickFromCamera() async {
    final x = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
      maxWidth: 2000,
    );
    if (x == null) return;

    setState(() => _r.entruPhotoPaths.add(x.path));
    _touch();
  }

  Future<void> _pickFromGallery() async {
    final xs = await _picker.pickMultiImage(
      imageQuality: 85,
      maxWidth: 2000,
    );
    if (xs.isEmpty) return;

    setState(() {
      for (final x in xs) {
        _r.entruPhotoPaths.add(x.path);
      }
    });
    _touch();
  }

  void _removePhoto(String path) {
    setState(() => _r.entruPhotoPaths.remove(path));
    _touch();
  }

  // helper: meglio UX se “Art der Fläche” non è selezionata
  bool get _hasAreaType => (_r.entruType ?? '').trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Header(
            title: 'Entrümpelung – Umfang',
            subtitle:
                'Wähle zuerst die Art der Fläche. Danach die Abfallarten. Fotos helfen enorm für ein genaues Angebot.',
          ),
          const SizedBox(height: 12),

          // ✅ QUADRATI PREMIUM
          _card(
            context,
            title: 'Art der Fläche',
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.15,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _StructureTile(
                  label: 'Wohnung / Haus',
                  icon: Icons.home_outlined,
                  selected: _r.entruType == 'Wohnung',
                  onTap: () {
                    setState(() => _r.entruType = 'Wohnung');
                    _touch();
                  },
                ),
                _StructureTile(
                  label: 'Keller',
                  icon: Icons.warehouse_outlined,
                  selected: _r.entruType == 'Keller',
                  onTap: () {
                    setState(() => _r.entruType = 'Keller');
                    _touch();
                  },
                ),
                _StructureTile(
                  label: 'Garage',
                  icon: Icons.garage_outlined,
                  selected: _r.entruType == 'Garage',
                  onTap: () {
                    setState(() => _r.entruType = 'Garage');
                    _touch();
                  },
                ),
                _StructureTile(
                  label: 'Gewerbe / Werkstatt',
                  icon: Icons.factory_outlined,
                  selected: _r.entruType == 'Gewerbe',
                  onTap: () {
                    setState(() => _r.entruType = 'Gewerbe');
                    _touch();
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // info box
          Container(
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
          ),

          const SizedBox(height: 12),

          // ✅ Abfallarten
          _card(
            context,
            title: 'Abfallarten (für die Deponie)',
            child: Column(
              children: _cats.map((c) {
                final selected = _isSelected(c.key);
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: selected ? const Color(0xFFFFF3B0) : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: selected ? const Color(0x33FFD200) : Colors.black12,
                    ),
                  ),
                  child: CheckboxListTile(
                    value: selected,
                    onChanged: _hasAreaType ? (_) => _toggle(c.key) : null,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    controlAffinity: ListTileControlAffinity.trailing,
                    title: Row(
                      children: [
                        _iconPill(selected: selected, icon: c.icon),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            c.key,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: _hasAreaType ? Colors.black87 : Colors.black38,
                            ),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(left: 46),
                      child: Text(
                        c.sub,
                        style: TextStyle(color: _hasAreaType ? Colors.black54 : Colors.black26),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 12),

          // ✅ Foto
          _card(
            context,
            title: 'Fotos (optional, aber empfohlen)',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ein paar schnelle Bilder reichen: Gesamtblick + problematische Stellen '
                  '(Treppenhaus, enge Türen, schwere Teile).',
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _pickFromCamera,
                        icon: const Icon(Icons.photo_camera_outlined),
                        label: const Text('Fotocamera'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          textStyle: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _pickFromGallery,
                        icon: const Icon(Icons.attach_file),
                        label: const Text('Allega'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          textStyle: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                if (_r.entruPhotoPaths.isNotEmpty)
                  SizedBox(
                    height: 86,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _r.entruPhotoPaths.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, i) {
                        final path = _r.entruPhotoPaths[i];
                        return Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                File(path),
                                width: 86,
                                height: 86,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 86,
                                  height: 86,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.black12),
                                  ),
                                  child: const Icon(Icons.broken_image_outlined),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: InkWell(
                                onTap: () => _removePhoto(path),
                                borderRadius: BorderRadius.circular(999),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.55),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: const Icon(Icons.close, size: 16, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  )
                else
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: const Text(
                      'Noch keine Fotos hinzugefügt.',
                      style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w700),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ✅ Altro
          _card(
            context,
            title: 'Altro (optional)',
            child: TextField(
              controller: otherC,
              onChanged: (v) {
                _r.entruOther = v.trim();
                _touch();
              },
              minLines: 2,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'z.B. "viel Kleinkram", "Sondermüll separat", "Garage voll"...',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // ---------- UI helpers ----------

  Widget _card(BuildContext context, {required String title, required Widget child}) {
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

  Widget _iconPill({required bool selected, required IconData icon}) {
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
}

class _WasteCat {
  final String key;
  final String sub;
  final IconData icon;
  const _WasteCat(this.key, this.sub, this.icon);
}

class _StructureTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _StructureTile({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected ? const Color(0xFFFFF3B0) : Colors.white;
    final border = selected ? const Color(0xFFFFD200) : const Color(0x22000000);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border, width: selected ? 2 : 1),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: const Color(0xFFFFD200).withValues(alpha: 0.18),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 120),
                opacity: selected ? 1 : 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD200),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Icon(Icons.check, size: 16, color: Colors.black),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: selected ? const Color(0xFFFFE27A) : const Color(0xFFF4F5F7),
                    border: Border.all(
                      color: selected ? const Color(0x33FFD200) : const Color(0x22000000),
                    ),
                  ),
                  child: Icon(icon, size: 28, color: Colors.black87),
                ),
                const SizedBox(height: 12),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  selected ? 'Ausgewählt' : 'Tippen zum Auswählen',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: selected ? const Color(0xFF6B5500) : Colors.black45,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  final String subtitle;

  const _Header({required this.title, required this.subtitle});

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

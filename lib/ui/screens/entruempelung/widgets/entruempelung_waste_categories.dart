import 'package:flutter/material.dart';

class WasteCat {
  final String key;
  final String sub;
  final IconData icon;
  const WasteCat(this.key, this.sub, this.icon);
}

/// Solo categorie utili per discarica / smaltimento
const entruWasteCats = <WasteCat>[
  WasteCat('Restmüll', 'nicht verwertbar', Icons.delete_outline),
  WasteCat('Sperrmüll', 'große sperrige Teile', Icons.weekend_outlined),
  WasteCat('Elektrogeräte', 'Waschmaschine, Kühlschrank...', Icons.electrical_services_outlined),
  WasteCat('Schrott / Metall', 'Metallteile, Eisen...', Icons.construction_outlined),
  WasteCat('Holz', 'Möbelholz, Bretter...', Icons.forest_outlined),
  WasteCat('Bauschutt', 'Steine, Fliesen, Beton...', Icons.home_work_outlined),
  WasteCat('Papier / Kartons', 'Karton, Papier', Icons.inventory_2_outlined),
  WasteCat('Glas', 'Glas / Spiegel', Icons.wine_bar_outlined),
  WasteCat('Textilien', 'Kleidung, Teppich...', Icons.checkroom_outlined),
  WasteCat('Grünschnitt', 'Gartenabfälle', Icons.grass_outlined),
  WasteCat('Sondermüll', 'Farben, Chemie, Öl...', Icons.warning_amber_outlined),
  WasteCat('Batterien / Akkus', 'E-Bike, Auto, Geräte', Icons.battery_charging_full_outlined),
];

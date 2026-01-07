import 'package:flutter/material.dart';

class InvItem {
  final String key;
  final String title;
  final int weight; // internal points
  final bool special; // forces inspection
  final String unit;

  const InvItem({
    required this.key,
    required this.title,
    required this.weight,
    this.special = false,
    this.unit = 'Stk',
  });
}

class InvCategory {
  final String title;
  final IconData icon;
  final List<InvItem> items;

  const InvCategory({required this.title, required this.icon, required this.items});
}

const List<InvCategory> inventoryCatalog = [
  InvCategory(
    title: 'Wohnzimmer',
    icon: Icons.weekend,
    items: [
      InvItem(key: 'sofa_small', title: 'Sofa klein', weight: 4),
      InvItem(key: 'sofa_large', title: 'Großes/Ecksofa', weight: 8),
      InvItem(key: 'armchair', title: 'Sessel', weight: 3),
      InvItem(key: 'tv', title: 'TV (normal)', weight: 2),
      InvItem(key: 'tv_large', title: 'TV > 65"', weight: 4),
      InvItem(key: 'coffee_table', title: 'Couchtisch', weight: 2),
      InvItem(key: 'shelf_small', title: 'Regal klein', weight: 2),
      InvItem(key: 'shelf_large', title: 'Regal groß', weight: 4),
    ],
  ),
  InvCategory(
    title: 'Schlafzimmer',
    icon: Icons.bed,
    items: [
      InvItem(key: 'bed_single', title: 'Bett (Einzel)', weight: 4),
      InvItem(key: 'bed_double', title: 'Bett (Doppel)', weight: 6),
      InvItem(key: 'mattress', title: 'Matratze', weight: 3),
      InvItem(key: 'wardrobe_small', title: 'Kleiderschrank klein', weight: 5),
      InvItem(key: 'wardrobe_large', title: 'Schrank > 2m', weight: 8),
      InvItem(key: 'nightstand', title: 'Nachttisch', weight: 1),
      InvItem(key: 'dresser', title: 'Kommode', weight: 4),
    ],
  ),
  InvCategory(
    title: 'Büro',
    icon: Icons.desk,
    items: [
      InvItem(key: 'desk_small', title: 'Schreibtisch klein', weight: 3),
      InvItem(key: 'desk_large', title: 'Schreibtisch groß', weight: 5),
      InvItem(key: 'office_chair', title: 'Bürostuhl', weight: 2),
      InvItem(key: 'pc', title: 'PC (Tower)', weight: 2),
      InvItem(key: 'monitor', title: 'Monitor', weight: 1),
      InvItem(key: 'printer', title: 'Drucker', weight: 2),
    ],
  ),
  InvCategory(
    title: 'Küche',
    icon: Icons.kitchen,
    items: [
      InvItem(key: 'fridge', title: 'Kühlschrank', weight: 7),
      InvItem(key: 'washing_machine', title: 'Waschmaschine', weight: 7),
      InvItem(key: 'dryer', title: 'Trockner', weight: 6),
      InvItem(key: 'dishwasher', title: 'Spülmaschine', weight: 6),
      InvItem(key: 'oven', title: 'Backofen/Herd', weight: 6),
      InvItem(key: 'microwave', title: 'Mikrowelle', weight: 1),
      InvItem(key: 'kitchen_table', title: 'Küchentisch', weight: 3),
      InvItem(key: 'chair', title: 'Stuhl', weight: 1),
      InvItem(key: 'moving_box', title: 'Umzugskarton', weight: 1, unit: 'Box'),
    ],
  ),
  InvCategory(
    title: 'Keller / Garage',
    icon: Icons.garage,
    items: [
      InvItem(key: 'bike', title: 'Fahrrad', weight: 3),
      InvItem(key: 'tire_set', title: 'Reifensatz', weight: 2),
      InvItem(key: 'toolbox', title: 'Werkzeugkiste', weight: 3),
      InvItem(key: 'storage_rack', title: 'Lagerregal', weight: 4),
    ],
  ),
  InvCategory(
    title: 'Spezial (Besichtigung)',
    icon: Icons.priority_high,
    items: [
      InvItem(key: 'piano_safe', title: 'Klavier / Safe / Extra schwer', weight: 10, special: true),
      InvItem(key: 'aquarium', title: 'Aquarium groß', weight: 8, special: true),
    ],
  ),
];

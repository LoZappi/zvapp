import '../models/request.dart';

class InventoryPreset {
  final String title;
  final String subtitle;
  final Map<String, int> items;

  const InventoryPreset({required this.title, required this.subtitle, required this.items});
}

const presets = <InventoryPreset>[
  InventoryPreset(
    title: '1 Zimmer (Basic)',
    subtitle: 'Schnellstart, danach anpassen',
    items: {
      'sofa_small': 1,
      'coffee_table': 1,
      'tv': 1,
      'bed_single': 1,
      'mattress': 1,
      'wardrobe_small': 1,
      'dresser': 1,
      'desk_small': 1,
      'office_chair': 1,
      'moving_box': 20,
    },
  ),
  InventoryPreset(
    title: '2 Zimmer (Standard)',
    subtitle: 'Realistisch für kleine Wohnungen',
    items: {
      'sofa_large': 1,
      'coffee_table': 1,
      'tv_large': 1,
      'bed_double': 1,
      'mattress': 1,
      'wardrobe_large': 1,
      'dresser': 2,
      'desk_small': 1,
      'office_chair': 1,
      'kitchen_table': 1,
      'chair': 4,
      'washing_machine': 1,
      'fridge': 1,
      'moving_box': 35,
    },
  ),
  InventoryPreset(
    title: '3 Zimmer (Family)',
    subtitle: 'Mehr Möbel + Geräte',
    items: {
      'sofa_large': 1,
      'armchair': 1,
      'coffee_table': 1,
      'tv_large': 1,
      'shelf_large': 1,
      'bed_double': 1,
      'bed_single': 1,
      'mattress': 2,
      'wardrobe_large': 2,
      'dresser': 2,
      'desk_large': 1,
      'office_chair': 1,
      'kitchen_table': 1,
      'chair': 6,
      'washing_machine': 1,
      'dryer': 1,
      'fridge': 1,
      'dishwasher': 1,
      'moving_box': 55,
      'bike': 2,
    },
  ),
];

void applyPresetToRequest(Request r, InventoryPreset p) {
  r.inventory = Map<String, int>.from(p.items);
}

import '../models/request.dart';

class ZVPricingResult {
  final bool inspection;
  final int base;
  final int size; // mq OR m³
  final int floors;
  final int items;
  final int access;
  final int extras;
  final int total;

  const ZVPricingResult({
    required this.inspection,
    required this.base,
    required this.size,
    required this.floors,
    required this.items,
    required this.access,
    required this.extras,
    required this.total,
  });
}

class ZVPricing {
  static const int _rangePct = 15;

  static bool mustInspection(Request r) {
    if (r.specialItem) return true;

    // premium: preferisci mq se inserito
    if (r.homeSqm > 120) return true;
    if (r.homeSqm <= 0 && r.volumeM3 > 20) return true;

    if (r.parkingDistance == ParkingDistance.long && r.difficultZone) return true;

    // se non hai né mq né m³ -> meglio sopralluogo (dati insufficienti)
    if (r.homeSqm <= 0 && r.volumeM3 <= 0) return true;

    return false;
  }

  static int baseByService(ZVService s) {
    switch (s) {
      case ZVService.transport:
        return 90;
      case ZVService.umzug:
        return 180;
      case ZVService.entruempelung:
        return 200;
    }
  }

  static int sizeBySqm(int sqm) {
    if (sqm <= 0) return 0;
    if (sqm <= 35) return 40;
    if (sqm <= 60) return 90;
    if (sqm <= 90) return 150;
    if (sqm <= 120) return 220;
    // >120: sopralluogo gestito sopra
    return 220;
  }

  static int sizeByM3(double m3) {
    if (m3 <= 0) return 0;
    if (m3 <= 3) return 20;
    if (m3 <= 8) return 60;
    if (m3 <= 15) return 120;
    if (m3 <= 20) return 180;
    // >20: sopralluogo gestito sopra
    return 180;
  }

  static int floorsCost(Request r) {
    int floors = 0;
    if (!r.pickupElevator && r.pickupFloor > 0) floors += r.pickupFloor * 15;
    if (!r.dropoffElevator && r.dropoffFloor > 0) floors += r.dropoffFloor * 15;
    return floors;
  }

  static int extrasCost(Request r) {
    int extras = 0;
    if (r.disassembly) extras += 60;
    if (r.packing) extras += 80;
    if (r.disposal) extras += 120;
    // “casa generica” (se vuoi attivarli)
    if (r.hasBasement) extras += 30;
    if (r.hasAttic) extras += 30;
    if (r.hasGarage) extras += 40;
    return extras;
  }

  static int itemsCost(Request r) {
    int items = 0;
    items += r.washingMachine * 25;
    items += r.dryer * 25;
    items += r.fridge * 35;
    items += r.sofaLarge * 40;
    items += r.wardrobeLarge * 50;
    items += r.tvLarge * 20;
    return items;
  }

  static int accessCost(Request r) {
    int access = 0;
    switch (r.parkingDistance) {
      case ParkingDistance.short:
        break;
      case ParkingDistance.medium:
        access += 30;
        break;
      case ParkingDistance.long:
        access += 60;
        break;
    }
    if (r.difficultZone) access += 40;
    if (r.timeRestricted) access += 20;
    return access;
  }

  static ZVPricingResult compute(Request r) {
    final inspection = mustInspection(r);

    // se deve sopralluogo, forziamo il tipo
    if (inspection) {
      r.priceType = PriceType.inspection;
    }

    final base = baseByService(r.service);

    // premium: mq se c’è, altrimenti m³
    final size = (r.homeSqm > 0) ? sizeBySqm(r.homeSqm) : sizeByM3(r.volumeM3);

    final floors = floorsCost(r);
    final items = itemsCost(r);
    final access = accessCost(r);
    final extras = extrasCost(r);

    final total = base + size + floors + items + access + extras;

    return ZVPricingResult(
      inspection: inspection || r.priceType == PriceType.inspection,
      base: base,
      size: size,
      floors: floors,
      items: items,
      access: access,
      extras: extras,
      total: total,
    );
  }

  static void applyToRequest(Request r) {
    final res = compute(r);

    // breakdown
    r.brBase = res.base;
    r.brVolume = res.size; // nome legacy: ora è “size”
    r.brFloors = res.floors;
    r.brItems = res.items;
    r.brAccess = res.access;
    r.brExtras = res.extras;

    if (res.inspection) {
      r.estimateMin = 0;
      r.estimateMax = 0;
      return;
    }

    if (r.priceType == PriceType.fixed) {
      r.estimateMin = res.total.toDouble();
      r.estimateMax = res.total.toDouble();
      return;
    }

    // range ±15%
    final min = (res.total * (100 - _rangePct) / 100).round();
    final max = (res.total * (100 + _rangePct) / 100).round();
    r.estimateMin = (min < 0 ? 0 : min).toDouble();
    r.estimateMax = (max < r.estimateMin ? r.estimateMin : max).toDouble();
  }
}

import '../../../models/request.dart';

class WizardState {
  final Request req;

  WizardState([Request? req]) : req = req ?? Request.draft();

  void computeEstimate() {
    if (req.service == ZVService.entruempelung) {
      _computeEntruempelung();
    } else {
      _computeDefault();
    }
  }

  /* ---------------- ENTRÜMPELUNG ---------------- */

  void _computeEntruempelung() {
    double base = 0;

    // 1) base per tipo immobile
    switch (req.entruType) {
      case 'Keller':
        base += 250;
        break;
      case 'Garage':
        base += 220;
        break;
      case 'Wohnung':
        base += 400;
        break;
      case 'Haus':
        base += 600;
        break;
      case 'Büro / Gewerbe':
        base += 700;
        break;
      default:
        base += 350;
    }

    // 2) dimensione
    switch (req.entruSize) {
      case 'Klein – wenige Gegenstände':
        base += 0;
        break;
      case 'Mittel – 1–2 Räume':
        base += 150;
        break;
      case 'Groß – mehrere Räume':
        base += 350;
        break;
      case 'Komplett – alles voll':
        base += 650;
        break;
      default:
        break;
    }

    // 3) contenuto
    final items = req.entruItems;
    if (items.contains('Elektrogeräte')) base += 80;
    if (items.contains('Sperrmüll')) base += 120;
    if (items.contains('Sondermüll')) base += 250;
    if (items.contains('Restmüll / Mischabfall')) base += 150;

    // 4) accesso
    base += req.entruFloor * 25;
    if (!req.entruElevator && req.entruFloor > 1) {
      base += 80;
    }

    switch (req.entruParking) {
      case ParkingDistance.medium:
        base += 60;
        break;
      case ParkingDistance.long:
        base += 140;
        break;
      case ParkingDistance.short:
        break;
    }

    // 5) extra
    if (req.entruDisassembly) base += 120;
    if (req.entruHeavy) base += 180;
    if (req.entruDirty) base += 200;

    // 6) risultato finale (forchetta)
    req.estimateMin = (base * 0.90);
    req.estimateMax = (base * 1.15);
  }

  /* ---------------- UMZUG / TRANSPORT ---------------- */

  void _computeDefault() {
    double base = 0;

    base += 200; // base service
    base += req.volumeM3 * 25;
    base += (req.pickupFloor + req.dropoffFloor) * 30;

    // se manca anche solo un ascensore, più fatica
    if (!req.pickupElevator || !req.dropoffElevator) {
      base += 80;
    }

    if (req.disassembly) base += 120;
    if (req.packing) base += 150;
    if (req.disposal) base += 180;

    req.estimateMin = (base * 0.90);
    req.estimateMax = (base * 1.15);
  }
}

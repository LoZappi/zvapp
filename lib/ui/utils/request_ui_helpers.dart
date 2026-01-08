import 'package:flutter/material.dart';
import '../../models/request.dart';

String serviceLabel(ZVService s) {
  switch (s) {
    case ZVService.umzug:
      return 'Umzug';
    case ZVService.transport:
      return 'Transport';
    case ZVService.entruempelung:
      return 'Entrümpelung';
  }
}

String statusLabel(ZVStatus s) {
  switch (s) {
    case ZVStatus.neu:
      return 'Neu';
    case ZVStatus.kontaktiert:
      return 'Kontaktiert';
    case ZVStatus.angebot:
      return 'Angebot';
    case ZVStatus.bestaetigt:
      return 'Bestätigt';
    case ZVStatus.verloren:
      return 'Verloren';
  }
}

IconData statusIcon(ZVStatus s) {
  switch (s) {
    case ZVStatus.neu:
      return Icons.fiber_new;
    case ZVStatus.kontaktiert:
      return Icons.call;
    case ZVStatus.angebot:
      return Icons.request_quote;
    case ZVStatus.bestaetigt:
      return Icons.verified;
    case ZVStatus.verloren:
      return Icons.cancel;
  }
}

String priceTypeLabel(PriceType? t) {
  if (t == null) return '';
  switch (t) {
    case PriceType.fixed:
      return 'Pauschal';
    case PriceType.range:
      return 'Spanne';
    case PriceType.inspection:
      return 'Besichtigung';
  }
}

String parkingLabel(ParkingDistance p) {
  switch (p) {
    case ParkingDistance.short:
      return '< 10 m';
    case ParkingDistance.medium:
      return '10-30 m';
    case ParkingDistance.long:
      return '> 30 m';
  }
}

String parkingDistanceLabel(ParkingDistance p) => parkingLabel(p);

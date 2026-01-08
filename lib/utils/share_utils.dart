import 'package:url_launcher/url_launcher.dart';
import '../models/request.dart';
import '../ui/utils/request_ui_helpers.dart';

class ShareUtils {
  static String _toWaNumber(String raw) {
    var s = raw.trim();
    s = s.replaceAll(RegExp(r'[^0-9\+]'), '');
    if (s.startsWith('00')) s = '+${s.substring(2)}';
    if (!s.startsWith('+') && s.startsWith('0')) {
      s = '+49${s.substring(1)}';
    }
    return s.replaceAll('+', '');
  }

  static String _priceLine(Request r) {
    if (r.priceType == PriceType.inspection || r.specialItem) {
      return 'Preis nach Besichtigung';
    }
    if (r.priceType == PriceType.fixed) {
      return (r.estimateMin > 0) ? '${r.estimateMin} € (pauschal)' : '—';
    }
    // range
    if (r.estimateMin > 0 && r.estimateMax > 0) return '${r.estimateMin}–${r.estimateMax} €';
    return '—';
  }

  static String _itemsText(Request r) {
    final parts = <String>[];
    if (r.washingMachine > 0) parts.add('Waschmaschine x${r.washingMachine}');
    if (r.dryer > 0) parts.add('Trockner x${r.dryer}');
    if (r.fridge > 0) parts.add('Kühlschrank x${r.fridge}');
    if (r.sofaLarge > 0) parts.add('Großes Sofa x${r.sofaLarge}');
    if (r.wardrobeLarge > 0) parts.add('Schrank >2m x${r.wardrobeLarge}');
    if (r.tvLarge > 0) parts.add('TV >65" x${r.tvLarge}');
    if (r.specialItem) parts.add('Special Item (Piano/Safe)');
    return parts.isEmpty ? '—' : parts.join(' • ');
  }

  static String _extrasText(Request r) {
    final extras = [
      if (r.disassembly) 'Demontage/Montage',
      if (r.packing) 'Verpackung',
      if (r.disposal) 'Entsorgung',
    ];
    return extras.isEmpty ? '—' : extras.join(' • ');
  }

  static String buildOfferText(Request r) {
    final etagenText =
        '${r.pickupFloor} (Aufzug: ${r.pickupElevator ? "Ja" : "Nein"}) → ${r.dropoffFloor} (Aufzug: ${r.dropoffElevator ? "Ja" : "Nein"})';

    final volumeText = r.volumeM3 > 0 ? '${r.volumeM3.toStringAsFixed(1)} m³' : '—';

    final access = [
      'Parkplatz: ${parkingLabel(r.parkingDistance)}',
      if (r.difficultZone) 'Zone: schwierig',
      if (r.timeRestricted) 'Zeit: eingeschränkt',
    ].join(' • ');

    final priceLine = _priceLine(r);

    // Breakdown (se non inspection)
    final hasBreakdown = !(r.priceType == PriceType.inspection || r.specialItem);
    final total = r.brBase + r.brVolume + r.brFloors + r.brItems + r.brAccess + r.brExtras;

    final breakdown = hasBreakdown
        ? [
            '',
            'Kostenaufstellung (transparent):',
            '• Basis: ${r.brBase} €',
            '• Volumen: ${r.brVolume} €',
            '• Etagen/Tragen: ${r.brFloors} €',
            '• Oggetti critici: ${r.brItems} €',
            '• Accesso: ${r.brAccess} €',
            '• Extras: ${r.brExtras} €',
            '—',
            'Zwischensumme: $total €',
          ].join('\n')
        : '';

    return [
      'Hallo ${r.name.isNotEmpty ? r.name : ""},'.trim(),
      '',
      'hier unser Angebot:',
      '',
      '📦 Service: ${serviceLabel(r.service)}',
      '📍 Abholung: ${r.pickupAddress.isNotEmpty ? r.pickupAddress : "—"}',
      '📍 Ziel: ${r.dropoffAddress.isNotEmpty ? r.dropoffAddress : "—"}',
      '🏢 Etagen: $etagenText',
      '🚚 $access',
      '📐 Volumen: $volumeText',
      '🧱 Oggetti: ${_itemsText(r)}',
      '➕ Extras: ${_extrasText(r)}',
      if (r.note.trim().isNotEmpty) '📝 Notiz: ${r.note.trim()}',
      '',
      '💰 Preis: $priceLine',
      if (breakdown.isNotEmpty) breakdown,
      '',
      'Der Preis basiert auf den angegebenen Informationen.',
      'Änderungen bei Volumen, Etagen oder Zusatzleistungen können den Preis beeinflussen.',
      '',
      'Bei Zustimmung bitte kurze Bestätigung per E-Mail an',
      'zvtransportgbr@gmail.com (mit Datum + Auftrag).',
      '',
      'Viele Grüße',
      'Z&V Transport GbR',
    ].join('\n');
  }

  static Future<void> shareOfferWhatsApp(Request r) async {
    final text = buildOfferText(r);
    final encoded = Uri.encodeComponent(text);

    final phoneRaw = r.phone.trim();
    final url = (phoneRaw.isEmpty)
        ? Uri.parse('https://wa.me/?text=$encoded')
        : Uri.parse('https://wa.me/${_toWaNumber(phoneRaw)}?text=$encoded');

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Impossibile aprire WhatsApp.');
    }
  }

  static Future<void> shareOfferEmail(Request r) async {
    final subject = 'Angebot – Z&V Transport (${serviceLabel(r.service)})';
    final body = buildOfferText(r);
    final to = r.email.trim();

    final uri = Uri(
      scheme: 'mailto',
      path: to,
      queryParameters: {
        'subject': subject,
        'body': body,
      },
    );

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Impossibile aprire Email.');
    }
  }

  static String getOfferText(Request r) => buildOfferText(r);
}
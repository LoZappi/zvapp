import 'package:flutter/material.dart';
import '../../utils/request_ui_helpers.dart';
import 'wizard_state.dart';
import '../../../models/request.dart' as m;

// sections comuni
import 'sections/section_price_type.dart';
import 'sections/section_tech.dart';
import 'sections/section_inventory.dart';
import 'sections/section_summary.dart';

// contact
import 'sections/section_contact_addresses.dart';

// Entrümpelung
import 'sections/section_entruempelung_step1.dart';
import 'sections/section_entruempelung_step2.dart';

enum WizardSection {
  priceType,

  // Umzug / Transport
  tech,
  inventory,

  // Entrümpelung
  entruStep1,
  entruStep2,

  // ✅ merged
  contactAddresses,

  summary,
}

class WizardShellScreen extends StatefulWidget {
  final WizardState st;
  const WizardShellScreen({super.key, required this.st});

  @override
  State<WizardShellScreen> createState() => _WizardShellScreenState();
}

class _WizardShellScreenState extends State<WizardShellScreen> {
  WizardSection current = WizardSection.priceType;

  bool get isEntru => widget.st.req.service == m.ZVService.entruempelung;

  bool get isFirst => current == WizardSection.priceType;
  bool get isLast => current == WizardSection.summary;

  void goNext() {
    setState(() => current = _nextOf(current));
  }

  void goBack() {
    setState(() => current = _prevOf(current));
  }

  void _onBackPressed() {
    if (isFirst) {
      Navigator.of(context).pop();
    } else {
      goBack();
    }
  }

  void _onNextPressed() {
    if (isLast) {
      Navigator.of(context).pop();
    } else {
      goNext();
    }
  }

  WizardSection _nextOf(WizardSection s) {
    if (isEntru) {
      switch (s) {
        case WizardSection.priceType:
          return WizardSection.entruStep1;
        case WizardSection.entruStep1:
          return WizardSection.entruStep2;
        case WizardSection.entruStep2:
          return WizardSection.contactAddresses;
        case WizardSection.contactAddresses:
          return WizardSection.summary;
        default:
          return s;
      }
    } else {
      switch (s) {
        case WizardSection.priceType:
          return WizardSection.tech;
        case WizardSection.tech:
          return WizardSection.inventory;
        case WizardSection.inventory:
          return WizardSection.contactAddresses;
        case WizardSection.contactAddresses:
          return WizardSection.summary;
        default:
          return s;
      }
    }
  }

  WizardSection _prevOf(WizardSection s) {
    if (isEntru) {
      switch (s) {
        case WizardSection.entruStep1:
          return WizardSection.priceType;
        case WizardSection.entruStep2:
          return WizardSection.entruStep1;
        case WizardSection.contactAddresses:
          return WizardSection.entruStep2;
        case WizardSection.summary:
          return WizardSection.contactAddresses;
        default:
          return s;
      }
    } else {
      switch (s) {
        case WizardSection.tech:
          return WizardSection.priceType;
        case WizardSection.inventory:
          return WizardSection.tech;
        case WizardSection.contactAddresses:
          return WizardSection.inventory;
        case WizardSection.summary:
          return WizardSection.contactAddresses;
        default:
          return s;
      }
    }
  }

  String titleOf(WizardSection s) {
    switch (s) {
      case WizardSection.priceType:
        return 'Preis-Typ';
      case WizardSection.tech:
        return 'Details';
      case WizardSection.inventory:
        return 'Inventar';
      case WizardSection.entruStep1:
        return 'Entrümpelung – Umfang';
      case WizardSection.entruStep2:
        return 'Entrümpelung – Zugang';
      case WizardSection.contactAddresses:
        return 'Kontakt & Adressen';
      case WizardSection.summary:
        return 'Zusammenfassung';
    }
  }

  Widget buildSection() {
    switch (current) {
      case WizardSection.priceType:
        return SectionPriceType(
          st: widget.st,
          onNext: goNext,
          onBack: () => Navigator.of(context).pop(),
        );

      case WizardSection.tech:
        return SectionTech(
          st: widget.st,
          onChanged: () => setState(() {}),
        );

      case WizardSection.inventory:
        return SectionInventory(
          st: widget.st,
          onNext: goNext,
          onBack: goBack,
        );

      case WizardSection.entruStep1:
        return SectionEntruempelungStep1(
          st: widget.st,
          onNext: goNext,
          onBack: goBack,
        );

      case WizardSection.entruStep2:
        // ✅ FIX: onChanged obbligatorio
        return SectionEntruempelungStep2(
          st: widget.st,
          onChanged: () => setState(() {}),
          onNext: goNext,
          onBack: goBack,
        );

      case WizardSection.contactAddresses:
        return SectionContactAddresses(
          st: widget.st,
          onNext: goNext,
          onBack: goBack,
        );

      case WizardSection.summary:
        return SectionSummary(
          st: widget.st,
          onBack: goBack,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = titleOf(current);

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Center(child: _Chip(r: widget.st.req)),
          ),
        ],
      ),

      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 10),
                child: Text(
                  'Z&V Transport',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
              ),
              const Divider(height: 1),

              ListTile(
                leading: const Icon(Icons.home_rounded),
                title: const Text('Home'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamedAndRemoveUntil('/', (r) => false);
                },
              ),

              ListTile(
                leading: const Icon(Icons.list_alt_rounded),
                title: const Text('Richieste'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamedAndRemoveUntil('/requests', (r) => false);
                },
              ),

              const Divider(height: 1),

              ListTile(
                leading: const Icon(Icons.close),
                title: const Text('Schließen'),
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),

      body: SafeArea(child: buildSection()),

      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0x11000000))),
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _onBackPressed,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Zurück'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _onNextPressed,
                  icon: Icon(isLast ? Icons.check : Icons.arrow_forward),
                  label: Text(isLast ? 'Fertig' : 'Weiter'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final m.Request r;
  const _Chip({required this.r});

  @override
  Widget build(BuildContext context) {
    final pt = r.priceType;

    final text = (pt == null)
        ? 'Preis-Typ'
        : (pt == m.PriceType.inspection ? 'Preis nach Besichtigung' : priceTypeLabel(pt));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3B0),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0x33FFD200)),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w900)),
    );
  }
}

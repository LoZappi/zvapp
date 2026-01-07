import 'package:flutter/material.dart';
import '../../../../models/request.dart';
import '../wizard_state.dart';

class SectionPriceType extends StatefulWidget {
  final WizardState st;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const SectionPriceType({
    super.key,
    required this.st,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<SectionPriceType> createState() => _SectionPriceTypeState();
}

class _SectionPriceTypeState extends State<SectionPriceType> {
  void _set(PriceType v) => setState(() => widget.st.req.priceType = v);

  // Default + recommended in base al service
  PriceType _defaultFor(ZVService s) {
    switch (s) {
      case ZVService.entruempelung:
        return PriceType.inspection; // spesso serve sopralluogo/foto
      case ZVService.transport:
        return PriceType.fixed; // trasporti spesso “semplici”
      case ZVService.umzug:
      default:
        return PriceType.range; // trasloco = tanti dettagli -> spanne
    }
  }

  PriceType _recommendedFor(ZVService s) {
    switch (s) {
      case ZVService.entruempelung:
        return PriceType.inspection;
      case ZVService.transport:
        return PriceType.fixed;
      case ZVService.umzug:
      default:
        return PriceType.range;
    }
  }

  _PriceCopy _copyFor(ZVService s) {
    // Testi adattati (stessa UI)
    switch (s) {
      case ZVService.entruempelung:
        return const _PriceCopy(
          fixedTitle: 'Pauschalpreis',
          fixedSub: 'Fester Preis – gut bei klaren Fotos/Details.',
          rangeTitle: 'Preisspanne',
          rangeSub: 'Flexibel – bei unsicheren Mengen/Schwierigkeiten.',
          inspTitle: 'Preis nach Besichtigung',
          inspSub: 'Empfohlen bei großen Entrümpelungen / Sondermüll / schwerem Zugang.',
        );
      case ZVService.transport:
        return const _PriceCopy(
          fixedTitle: 'Pauschalpreis',
          fixedSub: 'Empfohlen für Kleintransporte mit klaren Angaben.',
          rangeTitle: 'Preisspanne',
          rangeSub: 'Wenn Gewicht/Umfang noch unklar ist.',
          inspTitle: 'Preis nach Besichtigung',
          inspSub: 'Für Spezialfälle (sehr groß/schwer oder schwieriger Zugang).',
        );
      case ZVService.umzug:
      default:
        return const _PriceCopy(
          fixedTitle: 'Pauschalpreis',
          fixedSub: 'Fester Preis – gut, wenn alles genau bekannt ist.',
          rangeTitle: 'Preisspanne',
          rangeSub: 'Empfohlen – passt sich an Details (Volumen/Etagen/Extras) an.',
          inspTitle: 'Preis nach Besichtigung',
          inspSub: 'Für große / schwierige / spezielle Umzüge.',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.st.req;

    // default sicuro in base al service
    r.priceType ??= _defaultFor(r.service);

    final rec = _recommendedFor(r.service);
    final copy = _copyFor(r.service);

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
      children: [
        const Text(
          'Preis-Typ wählen',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 6),
        const Text(
          'Wähle, wie du das Angebot kalkulieren willst.',
          style: TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 18),

        _BigPriceButton(
          title: copy.fixedTitle,
          subtitle: copy.fixedSub,
          icon: Icons.verified_rounded,
          value: PriceType.fixed,
          selected: r.priceType == PriceType.fixed,
          recommended: rec == PriceType.fixed,
          onTap: () => _set(PriceType.fixed),
        ),
        const SizedBox(height: 10),

        _BigPriceButton(
          title: copy.rangeTitle,
          subtitle: copy.rangeSub,
          icon: Icons.auto_graph_rounded,
          value: PriceType.range,
          selected: r.priceType == PriceType.range,
          recommended: rec == PriceType.range,
          onTap: () => _set(PriceType.range),
        ),
        const SizedBox(height: 10),

        _BigPriceButton(
          title: copy.inspTitle,
          subtitle: copy.inspSub,
          icon: Icons.visibility_rounded,
          value: PriceType.inspection,
          selected: r.priceType == PriceType.inspection,
          recommended: rec == PriceType.inspection,
          onTap: () => _set(PriceType.inspection),
        ),
      ],
    );
  }
}

/* ---------------- UI ---------------- */

class _PriceCopy {
  final String fixedTitle;
  final String fixedSub;
  final String rangeTitle;
  final String rangeSub;
  final String inspTitle;
  final String inspSub;

  const _PriceCopy({
    required this.fixedTitle,
    required this.fixedSub,
    required this.rangeTitle,
    required this.rangeSub,
    required this.inspTitle,
    required this.inspSub,
  });
}

class _BigPriceButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final PriceType value;
  final bool selected;
  final bool recommended;
  final VoidCallback onTap;

  const _BigPriceButton({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.selected,
    required this.onTap,
    this.recommended = false,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = selected
        ? Theme.of(context).colorScheme.primary.withOpacity(0.6)
        : Colors.black12;

    final bgColor = selected
        ? Theme.of(context).colorScheme.primary.withOpacity(0.08)
        : Colors.white;

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 30,
                color: selected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.black54,
              ),
              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  selected ? FontWeight.w900 : FontWeight.w800,
                            ),
                          ),
                        ),
                        if (recommended)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.15),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              'EMPFOHLEN',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.6,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.black54,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),
              Icon(
                selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: selected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.black38,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

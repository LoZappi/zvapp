import 'package:flutter/material.dart';

import '../theme/zv_colors.dart';
import '../../data/requests_repo.dart';
import '../../models/request.dart';
import '../components/zv_card.dart';
import '../components/zv_section_header.dart';
import 'requests_screen.dart';
import 'wizard/wizard_shell_screen.dart';
import 'wizard/wizard_state.dart';

class QuickStartScreen extends StatelessWidget {
  final RequestsRepo repo;
  const QuickStartScreen({super.key, required this.repo});

  Future<void> _startWizard(BuildContext context, ZVService service) async {
    final st = WizardState(
      Request(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt: DateTime.now(),
        service: service,
        status: ZVStatus.neu, // ✅ obbligatorio
      ),
    );

    final created = await Navigator.push<Request?>(
      context,
      MaterialPageRoute(builder: (_) => WizardShellScreen(st: st)),
    );

    if (created != null) {
      await repo.add(created);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!repo.ready) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: ZVColors.background,
      appBar: AppBar(
        backgroundColor: ZVColors.background,
        elevation: 0,
        toolbarHeight: 74,
        titleSpacing: 16,
        centerTitle: true,
        title: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 54,
                height: 54,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: ZVColors.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: ZVColors.primary.withOpacity(0.25)),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 18,
                      offset: Offset(0, 8),
                      color: Color(0x22000000),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const Text(
              'Z&V Transport App',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 20,
                color: ZVColors.textPrimary,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(
            height: 2,
            color: ZVColors.primary.withOpacity(0.75),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ZVSectionHeader(
            badge: 'START',
            title: 'Neues Angebot',
            subtitle: 'Wähle den Service und starte sofort.',
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _BigTile(
                  title: 'Umzug',
                  subtitle: 'Wohnung, Haus, Büro',
                  icon: Icons.inventory_2,
                  onTap: () => _startWizard(context, ZVService.umzug),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _BigTile(
                  title: 'Transport',
                  subtitle: 'Möbel, Geräte, Kleintransport',
                  icon: Icons.local_shipping,
                  onTap: () => _startWizard(context, ZVService.transport),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _BigTile(
                  title: 'Entrümpelung',
                  subtitle: 'Keller, Wohnung, Garage',
                  icon: Icons.delete_sweep,
                  onTap: () => _startWizard(context, ZVService.entruempelung),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: _BigTile(
                  title: 'Altro',
                  subtitle: 'Coming soon',
                  icon: Icons.auto_awesome,
                  disabled: true,
                  onTap: null,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          const Text(
            'Work in progress',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),

          Row(
            children: const [
              Expanded(
                child: _WipTile(
                  title: 'Kalender',
                  subtitle: 'In Planung',
                  icon: Icons.calendar_month,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _WipTile(
                  title: 'PDF Export',
                  subtitle: 'In Planung',
                  icon: Icons.picture_as_pdf,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          ZVCard(
            padding: const EdgeInsets.all(14),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => RequestsScreen(repo: repo)),
            ),
            child: Row(
              children: const [
                Icon(Icons.inbox),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Anfragen öffnen',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
                Icon(Icons.chevron_right),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BigTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap;
  final bool disabled;

  const _BigTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: disabled ? 0.7 : 1,
      child: AspectRatio(
        aspectRatio: 1,
        child: ZVCard(
          padding: const EdgeInsets.all(14),
          onTap: disabled ? null : onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: ZVColors.primarySoft,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: ZVColors.primary.withOpacity(0.25)),
                ),
                child: Icon(icon, size: 28, color: ZVColors.textPrimary),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: ZVColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                height: 32,
                child: Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.25,
                    color: ZVColors.textSecondary,
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

class _WipTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _WipTile({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ZVCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: ZVColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: ZVColors.border),
            ),
            child: Icon(icon, color: ZVColors.textPrimary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: ZVColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(color: ZVColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../models/request.dart';
import '../../utils/request_ui_helpers.dart';
import '../../../data/requests_repo.dart';
import '../../components/zv_card.dart';
import '../../components/zv_section_header.dart';
import '../../components/zv_topbar.dart';
import 'anfragen_list.dart';
import 'anfragen_detail.dart';
import '../shared/wizard/wizard_shell.dart';
import '../shared/wizard/wizard_state.dart';

class DashboardScreen extends StatefulWidget {
  final RequestsRepo repo;
  const DashboardScreen({super.key, required this.repo});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  @override
  Widget build(BuildContext context) {
    if (!widget.repo.ready) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final items = widget.repo.items;
    final neu = items.where((e) => e.status == ZVStatus.neu).length;
    final offen = items.where((e) => e.status != ZVStatus.bestaetigt && e.status != ZVStatus.verloren).length;
    final best = items.where((e) => e.status == ZVStatus.bestaetigt).length;

    return Scaffold(
      appBar: const ZVTopBar(title: 'Z&V – Intern', subtitle: 'Anfragen & Angebote verwalten'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ZVSectionHeader(
            badge: 'Dashboard',
            title: 'Schnellübersicht',
            subtitle: 'Alle Anfragen werden lokal gespeichert.',
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _StatCard(label: 'Neu', value: '$neu', icon: Icons.fiber_new)),
              const SizedBox(width: 12),
              Expanded(child: _StatCard(label: 'Offen', value: '$offen', icon: Icons.pending_actions)),
              const SizedBox(width: 12),
              Expanded(child: _StatCard(label: 'Bestätigt', value: '$best', icon: Icons.verified)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final st = WizardState(Request(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      createdAt: DateTime.now(),
                      service: ZVService.umzug,
                      status: ZVStatus.neu,
                    ));
                    final created = await Navigator.push<Request?>(
                      context,
                      MaterialPageRoute(builder: (_) => WizardShellScreen(st: st)),
                    );
                    if (created != null) await widget.repo.add(created);
                  },
                  icon: const Icon(Icons.request_quote),
                  label: const Text('Neues Angebot'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RequestsScreen(repo: widget.repo)),
                  ),
                  icon: const Icon(Icons.inbox),
                  label: const Text('Anfragen'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Letzte Anfragen', style: TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          ...items.take(4).map((r) => _RequestCard(
                r: r,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => RequestDetailScreen(repo: widget.repo, r: r)),
                ),
              )),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCard({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ZVCard(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0x14FFD200),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Color(0xFF6B7280), fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final Request r;
  final VoidCallback onTap;

  const _RequestCard({required this.r, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final price = (r.estimateMin > 0 && r.estimateMax > 0) ? '${r.estimateMin}–${r.estimateMax} €' : '—';
    return ZVCard(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0x14FFD200),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(statusIcon(r.status)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${serviceLabel(r.service)} • ${r.name}', style: const TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(
                  r.note.isEmpty ? '—' : r.note,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Color(0xFF6B7280)),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(statusLabel(r.status), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
                    const SizedBox(width: 10),
                    Text(price, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}

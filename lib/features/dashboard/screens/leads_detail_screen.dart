import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/responsive/responsive_layout.dart';
import '../providers/dashboard_providers.dart';

class LeadsDetailScreen extends ConsumerWidget {
  const LeadsDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ResponsiveLayout(
      mobile: _buildMobileView(context, ref),
      tablet: _buildTabletView(context, ref),
      desktop: _buildDesktopView(context, ref),
    );
  }

  Widget _buildMobileView(BuildContext context, WidgetRef ref) {
    // On mobile, we just show the list. Tapping an item would navigate to a separate detail page (not implemented here)
    return Scaffold(
      appBar: AppBar(title: const Text('Leads')),
      body: const LeadListView(),
    );
  }

  Widget _buildTabletView(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leads')),
      body: Row(
        children: const [
          // Lead List (Left Panel)
          Expanded(
            flex: 2,
            child: LeadListView(),
          ),

          VerticalDivider(width: 1),

          // Lead Detail (Right Panel)
          Expanded(
            flex: 3,
            child: LeadDetailPanel(),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopView(BuildContext context, WidgetRef ref) {
    // Desktop is similar to tablet but maybe with a persistent drawer if it was a full app structure
    // For this specific screen request, we'll keep the master-detail layout
    return Scaffold(
      appBar: AppBar(title: const Text('Leads Management')),
      body: Row(
        children: const [
          Expanded(
            flex: 1,
            child: LeadListView(),
          ),
          VerticalDivider(width: 1),
          Expanded(
            flex: 3,
            child: LeadDetailPanel(),
          ),
        ],
      ),
    );
  }
}

class LeadListView extends ConsumerWidget {
  const LeadListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(topLeadsProvider).when(
          data: (leads) => ListView.separated(
            itemCount: leads.length,
            separatorBuilder: (c, i) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final lead = leads[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(lead.company[0]),
                ),
                title: Text(lead.company),
                subtitle: Text(lead.contact),
                onTap: () {
                  // In a real app, this would select the lead
                },
              );
            },
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => Center(child: Text('Error: $e')),
        );
  }
}

class LeadDetailPanel extends StatelessWidget {
  const LeadDetailPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.people_outline, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'Select a lead to view details',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }
}

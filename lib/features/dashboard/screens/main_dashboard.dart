import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../core/responsive/responsive_layout.dart';
import '../providers/dashboard_providers.dart';

class MainDashboard extends ConsumerWidget {
  const MainDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ResponsiveLayout(
      // Mobile: Vertical Scroll
      mobile: _buildMobileLayout(context, ref),

      // Tablet: 2-Column Grid
      tablet: _buildTabletLayout(context, ref),

      // Desktop/Web: 3-Column Grid mit Sidebar
      desktop: _buildDesktopLayout(context, ref),
    );
  }

  // MOBILE LAYOUT (Smartphone)
  Widget _buildMobileLayout(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SalesAI Pro'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => _showNotifications(context),
          ),
        ],
      ),
      drawer: _buildNavigationDrawer(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Quick Stats
            _buildQuickStatsCard(ref, layout: 'mobile'),
            const SizedBox(height: 16),

            // Dashboard Widgets (stacked vertically)
            ..._getDashboardWidgets(context, ref).map((widget) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: widget,
                )),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  // TABLET LAYOUT (iPad, Android Tablets)
  Widget _buildTabletLayout(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SalesAI Pro Dashboard'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
          IconButton(icon: const Icon(Icons.account_circle), onPressed: () {}),
        ],
      ),
      body: Row(
        children: [
          // Side Navigation (immer sichtbar auf Tablet)
          NavigationRail(
            selectedIndex: 0,
            onDestinationSelected: (index) =>
                _navigateToSection(context, index),
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard),
                label: Text('Overview'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.people),
                label: Text('Leads'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.show_chart),
                label: Text('Pipeline'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.phone),
                label: Text('Calls'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.send),
                label: Text('Outreach'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.analytics),
                label: Text('Analytics'),
              ),
            ],
          ),

          const VerticalDivider(width: 1),

          // Main Content Area (2-Column Grid)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: CustomScrollView(
                slivers: [
                  // Header mit Quick Stats
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Guten Tag, ${_getUserName(ref)}!',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _getGreetingMessage(),
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 24),
                        _buildQuickStatsCard(ref, layout: 'tablet'),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),

                  // 2-Column Grid für Widgets
                  SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.5,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    delegate: SliverChildListDelegate(
                      _getDashboardWidgets(context, ref),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // DESKTOP/WEB LAYOUT (Browser, großer Screen)
  Widget _buildDesktopLayout(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Row(
        children: [
          // Permanent Sidebar Navigation
          Container(
            width: 250,
            color: Theme.of(context).colorScheme.surface,
            child: Column(
              children: [
                // Logo & Company Name
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: const [
                      Icon(Icons.auto_awesome, size: 32, color: Colors.blue),
                      SizedBox(width: 12),
                      Text(
                        'SalesAI Pro',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(),

                // Navigation Items
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(8),
                    children: [
                      _buildNavItem(
                        icon: Icons.dashboard,
                        label: 'Dashboard',
                        isSelected: true,
                        onTap: () => _navigateToSection(context, 0),
                      ),
                      _buildNavItem(
                        icon: Icons.people,
                        label: 'Leads',
                        badge: '12',
                        onTap: () => _navigateToSection(context, 1),
                      ),
                      _buildNavItem(
                        icon: Icons.show_chart,
                        label: 'Pipeline',
                        onTap: () => _navigateToSection(context, 2),
                      ),
                      _buildNavItem(
                        icon: Icons.phone,
                        label: 'Call Intelligence',
                        onTap: () => _navigateToSection(context, 3),
                      ),
                      _buildNavItem(
                        icon: Icons.send,
                        label: 'Outreach',
                        onTap: () => _navigateToSection(context, 4),
                      ),
                      _buildNavItem(
                        icon: Icons.analytics,
                        label: 'Analytics',
                        onTap: () => _navigateToSection(context, 5),
                      ),

                      const Divider(height: 32),

                      // Settings Section
                      const Padding(
                        padding: EdgeInsets.only(left: 16, bottom: 8),
                        child: Text(
                          'SETTINGS',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      _buildNavItem(
                        icon: Icons.sync,
                        label: 'CRM Integration',
                        onTap: () {},
                      ),
                      _buildNavItem(
                        icon: Icons.group,
                        label: 'Team',
                        onTap: () {},
                      ),
                      _buildNavItem(
                        icon: Icons.settings,
                        label: 'Settings',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                const Divider(),

                // User Profile
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(_getUserAvatar(ref)),
                        onBackgroundImageError: (_, __) {},
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _getUserName(ref),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const Text(
                              'Sales Rep',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout),
                        onPressed: () => _logout(ref),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const VerticalDivider(width: 1),

          // Main Content Area
          Expanded(
            child: Column(
              children: [
                // Top Bar
                Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Search Bar
                      Expanded(
                        flex: 2,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search leads, deals, contacts...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                          ),
                        ),
                      ),

                      const Spacer(),

                      // Quick Actions
                      IconButton(
                        icon: const Icon(Icons.add_circle),
                        tooltip: 'Add Lead',
                        onPressed: () => _showAddLeadDialog(context),
                      ),
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined),
                        tooltip: 'Notifications',
                        onPressed: () => _showNotifications(context),
                      ),
                      IconButton(
                        icon: const Icon(Icons.help_outline),
                        tooltip: 'Help',
                        onPressed: () => _showHelp(context),
                      ),
                    ],
                  ),
                ),

                // Content Area mit 3-Column Grid
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: CustomScrollView(
                      slivers: [
                        // Header
                        SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Dashboard Overview',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const Spacer(),
                                  // Date Range Selector
                                  DropdownButton<String>(
                                    value: 'This Week',
                                    items: [
                                      'Today',
                                      'This Week',
                                      'This Month',
                                      'This Quarter'
                                    ]
                                        .map((e) => DropdownMenuItem(
                                            value: e, child: Text(e)))
                                        .toList(),
                                    onChanged: (value) =>
                                        _changeDateRange(value),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _getGreetingMessage(),
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              const SizedBox(height: 24),

                              // Quick Stats Cards (horizontal)
                              _buildQuickStatsCard(ref, layout: 'desktop'),

                              const SizedBox(height: 32),
                            ],
                          ),
                        ),

                        // 3-Column Grid für Dashboard Widgets
                        SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1.3,
                            crossAxisSpacing: 24,
                            mainAxisSpacing: 24,
                          ),
                          delegate: SliverChildListDelegate(
                            _getDashboardWidgets(context, ref),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Navigation Item Builder
  Widget _buildNavItem({
    required IconData icon,
    required String label,
    String? badge,
    bool isSelected = false,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.blue : Colors.grey[600],
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.blue : Colors.grey[800],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        trailing: badge != null
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              )
            : null,
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  // Quick Stats Card (responsive)
  Widget _buildQuickStatsCard(WidgetRef ref, {required String layout}) {
    final stats = ref.watch(dashboardStatsProvider);

    return stats.when(
      data: (data) {
        if (layout == 'mobile') {
          // Mobile: 2x2 Grid
          return GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _buildStatCard('Hot Leads', data.hotLeads.toString(), Colors.red,
                  Icons.local_fire_department),
              _buildStatCard('Open Deals', data.openDeals.toString(),
                  Colors.blue, Icons.handshake),
              _buildStatCard('Forecast', '€${data.forecastAmount}K',
                  Colors.green, Icons.trending_up),
              _buildStatCard('Win Rate', '${data.winRate}%', Colors.purple,
                  Icons.emoji_events),
            ],
          );
        } else if (layout == 'tablet') {
          // Tablet: 4 Cards in Row
          return Row(
            children: [
              Expanded(
                  child: _buildStatCard('Hot Leads', data.hotLeads.toString(),
                      Colors.red, Icons.local_fire_department)),
              const SizedBox(width: 16),
              Expanded(
                  child: _buildStatCard('Open Deals', data.openDeals.toString(),
                      Colors.blue, Icons.handshake)),
              const SizedBox(width: 16),
              Expanded(
                  child: _buildStatCard('Forecast', '€${data.forecastAmount}K',
                      Colors.green, Icons.trending_up)),
              const SizedBox(width: 16),
              Expanded(
                  child: _buildStatCard('Win Rate', '${data.winRate}%',
                      Colors.purple, Icons.emoji_events)),
            ],
          );
        } else {
          // Desktop: 4 Cards in Row (larger)
          return Row(
            children: [
              Expanded(
                  child: _buildStatCard('Hot Leads', data.hotLeads.toString(),
                      Colors.red, Icons.local_fire_department,
                      large: true)),
              const SizedBox(width: 24),
              Expanded(
                  child: _buildStatCard('Open Deals', data.openDeals.toString(),
                      Colors.blue, Icons.handshake,
                      large: true)),
              const SizedBox(width: 24),
              Expanded(
                  child: _buildStatCard('Forecast', '€${data.forecastAmount}K',
                      Colors.green, Icons.trending_up,
                      large: true)),
              const SizedBox(width: 24),
              Expanded(
                  child: _buildStatCard('Win Rate', '${data.winRate}%',
                      Colors.purple, Icons.emoji_events,
                      large: true)),
            ],
          );
        }
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => const Text('Error loading stats'),
    );
  }

  Widget _buildStatCard(String label, String value, Color color, IconData icon,
      {bool large = false}) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(large ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: large ? 32 : 24),
                if (large)
                  const Icon(Icons.arrow_forward, size: 16, color: Colors.grey),
              ],
            ),
            SizedBox(height: large ? 16 : 8),
            Text(
              value,
              style: TextStyle(
                fontSize: large ? 32 : 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: large ? 14 : 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dashboard Widgets (alle Untergruppen)
  List<Widget> _getDashboardWidgets(BuildContext context, WidgetRef ref) {
    return [
      _buildLeadsWidget(context, ref),
      _buildPipelineWidget(context, ref),
      _buildCallIntelWidget(context, ref),
      _buildOutreachWidget(context, ref),
      _buildAnalyticsWidget(context, ref),
      _buildTeamPerformanceWidget(context, ref),
    ];
  }

  Widget _buildLeadsWidget(BuildContext context, WidgetRef ref) {
    return DashboardWidget(
      title: 'Top Priority Leads',
      icon: Icons.people,
      onTap: () => Navigator.pushNamed(context, '/leads'),
      child: ref.watch(topLeadsProvider).when(
            data: (leads) => ListView.builder(
              shrinkWrap: true,
              itemCount: min(leads.length, 3),
              itemBuilder: (context, index) {
                final lead = leads[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getScoreColor(lead.score),
                    child: Text('${lead.score}'),
                  ),
                  title: Text(lead.company),
                  subtitle: Text(lead.contact),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _openLeadDetail(lead.id),
                );
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => const Text('Error'),
          ),
    );
  }

  Widget _buildPipelineWidget(BuildContext context, WidgetRef ref) {
    return DashboardWidget(
      title: 'Pipeline Health',
      icon: Icons.show_chart,
      onTap: () => Navigator.pushNamed(context, '/pipeline'),
      child: ref.watch(pipelineHealthProvider).when(
            data: (data) => Column(
              children: [
                // Pipeline Chart (mini)
                Expanded(
                  child: SfCircularChart(
                    series: [
                      DoughnutSeries<PipelineStage, String>(
                        dataSource: data.stages,
                        xValueMapper: (stage, _) => stage.name,
                        yValueMapper: (stage, _) => stage.value,
                      ),
                    ],
                  ),
                ),
                Text(
                  'Total: €${data.totalValue}K',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => const Text('Error'),
          ),
    );
  }

  Widget _buildCallIntelWidget(BuildContext context, WidgetRef ref) {
    return DashboardWidget(
      title: 'Recent Calls',
      icon: Icons.phone,
      onTap: () => Navigator.pushNamed(context, '/calls'),
      child: ref.watch(recentCallsProvider).when(
            data: (calls) => ListView.builder(
              shrinkWrap: true,
              itemCount: min(calls.length, 3),
              itemBuilder: (context, index) {
                final call = calls[index];
                return ListTile(
                  leading: Icon(
                    Icons.phone_callback,
                    color: _getSentimentColor(call.sentiment),
                  ),
                  title: Text(call.company),
                  subtitle: Text(_formatCallDuration(call.duration)),
                  trailing: Chip(
                    label: Text('${call.dealScore}'),
                    backgroundColor: _getScoreColor(call.dealScore),
                  ),
                  onTap: () => _openCallAnalysis(call.id),
                );
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => const Text('Error'),
          ),
    );
  }

  Widget _buildOutreachWidget(BuildContext context, WidgetRef ref) {
    return DashboardWidget(
      title: 'Outreach Campaigns',
      icon: Icons.send,
      onTap: () => Navigator.pushNamed(context, '/outreach'),
      child: ref.watch(campaignStatsProvider).when(
            data: (stats) => Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCampaignStat('Sent Today', stats.sentToday.toString()),
                _buildCampaignStat('Reply Rate', '${stats.replyRate}%'),
                _buildCampaignStat(
                    'Meetings Booked', stats.meetingsBooked.toString()),
              ],
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => const Text('Error'),
          ),
    );
  }

  Widget _buildAnalyticsWidget(BuildContext context, WidgetRef ref) {
    return DashboardWidget(
      title: 'Forecast',
      icon: Icons.analytics,
      onTap: () => Navigator.pushNamed(context, '/analytics'),
      child: ref.watch(forecastProvider).when(
            data: (forecast) => Column(
              children: [
                Expanded(
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    series: [
                      LineSeries<ForecastData, String>(
                        dataSource: forecast.data,
                        xValueMapper: (data, _) => data.month,
                        yValueMapper: (data, _) => data.revenue,
                      ),
                    ],
                  ),
                ),
                Text(
                  'Q1 Forecast: €${forecast.q1Total}K',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => const Text('Error'),
          ),
    );
  }

  Widget _buildTeamPerformanceWidget(BuildContext context, WidgetRef ref) {
    return DashboardWidget(
      title: 'Team Performance',
      icon: Icons.group,
      onTap: () => Navigator.pushNamed(context, '/team'),
      child: ref.watch(teamStatsProvider).when(
            data: (stats) => ListView.builder(
              shrinkWrap: true,
              itemCount: min(stats.members.length, 3),
              itemBuilder: (context, index) {
                final member = stats.members[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(member.avatar),
                    onBackgroundImageError: (_, __) {},
                  ),
                  title: Text(member.name),
                  subtitle: LinearProgressIndicator(
                    value: member.quota / 100,
                    backgroundColor: Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation(Colors.green),
                  ),
                  trailing: Text('${member.quota}%'),
                );
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => const Text('Error'),
          ),
    );
  }

  Widget _buildCampaignStat(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600])),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  // Placeholder Helper Methods
  void _showNotifications(BuildContext context) {
    // Implement notification logic
  }

  Widget _buildNavigationDrawer(BuildContext context) {
    // Implement drawer
    return const Drawer();
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Leads'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
    );
  }

  void _navigateToSection(BuildContext context, int index) {
    // Handle navigation
  }

  String _getUserName(WidgetRef ref) => 'User';

  String _getGreetingMessage() => 'Welcome back to your dashboard';

  String _getUserAvatar(WidgetRef ref) => 'https://i.pravatar.cc/150';

  void _logout(WidgetRef ref) {
    // Logout logic
  }

  void _showAddLeadDialog(BuildContext context) {
    // Show dialog
  }

  void _showHelp(BuildContext context) {
    // Show help
  }

  void _changeDateRange(String? value) {
    // Change date range
  }

  Color _getScoreColor(int score) {
    if (score > 80) return Colors.green;
    if (score > 50) return Colors.orange;
    return Colors.red;
  }

  void _openLeadDetail(String id) {
    // Open lead detail
  }

  Color _getSentimentColor(CallSentiment sentiment) {
    switch (sentiment) {
      case CallSentiment.positive:
        return Colors.green;
      case CallSentiment.neutral:
        return Colors.orange;
      case CallSentiment.negative:
        return Colors.red;
    }
  }

  String _formatCallDuration(Duration duration) {
    return '${duration.inMinutes}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}';
  }

  void _openCallAnalysis(String id) {
    // Open call analysis
  }
}

// Dashboard Widget Container
class DashboardWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final VoidCallback onTap;

  const DashboardWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Icon(Icons.arrow_forward, size: 16, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}

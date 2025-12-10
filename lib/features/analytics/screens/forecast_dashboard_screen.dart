import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../core/models/forecast_data.dart';
import '../../../core/providers/mock_forecast_provider.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../../shared/widgets/error_view.dart';
import '../widgets/deal_risk_card.dart';
import '../widgets/expansion_opportunity_card.dart';
import '../widgets/churn_risk_card.dart';

class ForecastDashboardScreen extends ConsumerWidget {
  const ForecastDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forecast = ref.watch(mockForecastProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Revenue Forecast Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(mockForecastProvider),
          ),
        ],
      ),
      body: forecast.when(
        data: (data) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(mockForecastProvider);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _buildSummaryCards(context, data),
                _buildRevenueForecastChart(context, data),
                _buildAtRiskDeals(context, data),
                _buildUpsideOpportunities(context, data),
                _buildChurnRiskAccounts(context, data),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        loading: () => const LoadingIndicator(message: 'Loading forecast data...'),
        error: (err, stack) => ErrorView(
          error: err,
          onRetry: () => ref.refresh(mockForecastProvider),
        ),
      ),
    );
  }

  Widget _buildSummaryCards(BuildContext context, ForecastDashboardData data) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _SummaryCard(
              title: 'At Risk',
              value: '${data.atRiskDealsCount}',
              subtitle: 'deals',
              color: Colors.orange,
              icon: Icons.warning,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _SummaryCard(
              title: 'Upside',
              value: '${currencyFormat.format(data.upsidePotential / 1000)}K',
              subtitle: 'potential',
              color: Colors.green,
              icon: Icons.trending_up,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _SummaryCard(
              title: 'Churn Risk',
              value: '${currencyFormat.format(data.arrAtRisk / 1000)}K',
              subtitle: 'ARR at risk',
              color: Colors.red,
              icon: Icons.priority_high,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueForecastChart(
    BuildContext context,
    ForecastDashboardData data,
  ) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '3-Month Revenue Forecast',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Predicted revenue with confidence intervals',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() < data.forecast.length) {
                            return Text('M${value.toInt() + 1}');
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 50,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${(value / 1000).toStringAsFixed(0)}K',
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    // Predicted Revenue Line
                    LineChartBarData(
                      spots: data.forecast.asMap().entries.map((e) {
                        return FlSpot(
                          e.key.toDouble(),
                          e.value.predictedRevenue,
                        );
                      }).toList(),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                    ),
                    // Actual Revenue Line (if available)
                    if (data.forecast.any((d) => d.actualRevenue > 0))
                      LineChartBarData(
                        spots: data.forecast
                            .asMap()
                            .entries
                            .where((e) => e.value.actualRevenue > 0)
                            .map((e) {
                          return FlSpot(
                            e.key.toDouble(),
                            e.value.actualRevenue,
                          );
                        }).toList(),
                        isCurved: true,
                        color: Colors.green,
                        barWidth: 3,
                        dotData: const FlDotData(show: true),
                        dashArray: [5, 5],
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ChartLegend(color: Colors.blue, label: 'Predicted'),
                const SizedBox(width: 16),
                _ChartLegend(color: Colors.green, label: 'Actual'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAtRiskDeals(BuildContext context, ForecastDashboardData data) {
    if (data.atRiskDeals.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Icon(Icons.warning, color: Colors.orange[700]),
              const SizedBox(width: 8),
              Text(
                'Deals at Risk',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Spacer(),
              Chip(
                label: Text('${data.atRiskDealsCount}'),
                backgroundColor: Colors.orange.withOpacity(0.2),
                labelStyle: TextStyle(
                  color: Colors.orange[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        ...data.atRiskDeals.map((deal) => DealRiskCard(deal: deal)),
      ],
    );
  }

  Widget _buildUpsideOpportunities(
    BuildContext context,
    ForecastDashboardData data,
  ) {
    if (data.upsideOpportunities.isEmpty) {
      return const SizedBox.shrink();
    }

    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Row(
            children: [
              Icon(Icons.trending_up, color: Colors.green[700]),
              const SizedBox(width: 8),
              Text(
                'Expansion Opportunities',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Spacer(),
              Chip(
                label: Text('${currencyFormat.format(data.upsidePotential / 1000)}K'),
                backgroundColor: Colors.green.withOpacity(0.2),
                labelStyle: TextStyle(
                  color: Colors.green[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        ...data.upsideOpportunities.map(
          (opp) => ExpansionOpportunityCard(opportunity: opp),
        ),
      ],
    );
  }

  Widget _buildChurnRiskAccounts(
    BuildContext context,
    ForecastDashboardData data,
  ) {
    if (data.churnRiskAccounts.isEmpty) {
      return const SizedBox.shrink();
    }

    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Row(
            children: [
              Icon(Icons.priority_high, color: Colors.red[700]),
              const SizedBox(width: 8),
              Text(
                'Churn Risk Accounts',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Spacer(),
              Chip(
                label: Text('${currencyFormat.format(data.arrAtRisk / 1000)}K ARR'),
                backgroundColor: Colors.red.withOpacity(0.2),
                labelStyle: TextStyle(
                  color: Colors.red[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        ...data.churnRiskAccounts.map(
          (account) => ChurnRiskCard(account: account),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color color;
  final IconData icon;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
          ),
        ],
      ),
    );
  }
}

class _ChartLegend extends StatelessWidget {
  final Color color;
  final String label;

  const _ChartLegend({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 3,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

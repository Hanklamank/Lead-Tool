import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/forecast_data.dart';

// Mock forecast provider that doesn't require API
final mockForecastProvider = FutureProvider<ForecastDashboardData>((ref) async {
  // Simulate network delay
  await Future.delayed(const Duration(seconds: 1));

  // Return mock data
  return ForecastDashboardData(
    forecast: [
      const ForecastData(
        month: 1,
        predictedRevenue: 250000,
        confidenceHigh: 280000,
        confidenceLow: 220000,
        actualRevenue: 245000,
        contributingFactors: ['Strong pipeline', 'Historical trends'],
      ),
      const ForecastData(
        month: 2,
        predictedRevenue: 280000,
        confidenceHigh: 310000,
        confidenceLow: 250000,
        actualRevenue: 0,
        contributingFactors: ['Expected closures', 'Seasonal uptick'],
      ),
      const ForecastData(
        month: 3,
        predictedRevenue: 320000,
        confidenceHigh: 360000,
        confidenceLow: 280000,
        actualRevenue: 0,
        contributingFactors: ['Major deals expected', 'Market expansion'],
      ),
    ],
    atRiskDeals: [
      Deal(
        id: '1',
        name: 'Enterprise Software Deal - Acme Corp',
        accountName: 'Acme Corporation',
        value: 150000,
        stage: 'negotiation',
        closeDate: DateTime.now().add(const Duration(days: 15)),
        probability: 0.65,
        ownerId: 'owner1',
        ownerName: 'John Smith',
        riskScore: 0.75,
        riskFactors: [
          'No contact in 14 days',
          'Competitor engagement detected',
          'Budget concerns raised',
        ],
        notes: 'Needs immediate attention',
      ),
      Deal(
        id: '2',
        name: 'Cloud Migration Project - Tech Innovations',
        accountName: 'Tech Innovations LLC',
        value: 85000,
        stage: 'proposal',
        closeDate: DateTime.now().add(const Duration(days: 20)),
        probability: 0.55,
        ownerId: 'owner2',
        ownerName: 'Sarah Johnson',
        riskScore: 0.68,
        riskFactors: [
          'Decision maker changed',
          'Timeline pushed back twice',
        ],
      ),
    ],
    upsideOpportunities: [
      ExpansionOpportunity(
        id: '1',
        accountName: 'Global Enterprises Inc',
        accountId: 'acc1',
        potentialRevenue: 200000,
        probability: 0.70,
        opportunityType: 'Upsell',
        signals: [
          'Usage increased by 45% last quarter',
          'Positive feedback from stakeholders',
          'Budget approved for expansion',
        ],
        recommendedAction: 'Schedule executive review meeting',
        suggestedTiming: DateTime.now().add(const Duration(days: 7)),
      ),
      ExpansionOpportunity(
        id: '2',
        accountName: 'Innovate Solutions',
        accountId: 'acc2',
        potentialRevenue: 120000,
        probability: 0.60,
        opportunityType: 'Cross-sell',
        signals: [
          'Asked about premium features',
          'Team size doubled',
          'Exploring complementary solutions',
        ],
        recommendedAction: 'Present enterprise package demo',
      ),
    ],
    churnRiskAccounts: [
      ChurnRiskAccount(
        id: '1',
        accountName: 'Digital Solutions Co',
        arr: 180000,
        churnProbability: 0.72,
        riskIndicators: [
          'Support tickets up 300%',
          'Login activity decreased 60%',
          'Payment delays',
          'Key user left company',
        ],
        healthScore: 'critical',
        lastEngagement: DateTime.now().subtract(const Duration(days: 45)),
        assignedCsm: 'Mike Wilson',
        recommendedIntervention: 'Urgent: Schedule C-level meeting, offer premium support',
      ),
      ChurnRiskAccount(
        id: '2',
        accountName: 'StartupHub',
        arr: 95000,
        churnProbability: 0.55,
        riskIndicators: [
          'NPS score dropped',
          'Feature requests ignored',
          'Competitor evaluation started',
        ],
        healthScore: 'poor',
        lastEngagement: DateTime.now().subtract(const Duration(days: 21)),
        assignedCsm: 'Lisa Chen',
        recommendedIntervention: 'Product roadmap session, address feature gaps',
      ),
    ],
    atRiskDealsCount: 2,
    upsidePotential: 320000,
    arrAtRisk: 275000,
    lastUpdated: DateTime.now(),
  );
});

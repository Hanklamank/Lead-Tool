import 'package:freezed_annotation/freezed_annotation.dart';

part 'forecast_data.freezed.dart';
part 'forecast_data.g.dart';

@freezed
class ForecastData with _$ForecastData {
  const factory ForecastData({
    required int month,
    required double predictedRevenue,
    required double confidenceHigh,
    required double confidenceLow,
    required double actualRevenue,
    @Default([]) List<String> contributingFactors,
  }) = _ForecastData;

  factory ForecastData.fromJson(Map<String, dynamic> json) =>
      _$ForecastDataFromJson(json);
}

@freezed
class Deal with _$Deal {
  const factory Deal({
    required String id,
    required String name,
    required String accountName,
    required double value,
    required String stage,
    required DateTime closeDate,
    required double probability,
    required String ownerId,
    required String ownerName,
    @Default(0.0) double riskScore,
    @Default([]) List<String> riskFactors,
    String? notes,
  }) = _Deal;

  factory Deal.fromJson(Map<String, dynamic> json) => _$DealFromJson(json);
}

@freezed
class ExpansionOpportunity with _$ExpansionOpportunity {
  const factory ExpansionOpportunity({
    required String id,
    required String accountName,
    required String accountId,
    required double potentialRevenue,
    required double probability,
    required String opportunityType,
    required List<String> signals,
    String? recommendedAction,
    DateTime? suggestedTiming,
  }) = _ExpansionOpportunity;

  factory ExpansionOpportunity.fromJson(Map<String, dynamic> json) =>
      _$ExpansionOpportunityFromJson(json);
}

@freezed
class ChurnRiskAccount with _$ChurnRiskAccount {
  const factory ChurnRiskAccount({
    required String id,
    required String accountName,
    required double arr,
    required double churnProbability,
    required List<String> riskIndicators,
    required String healthScore,
    required DateTime lastEngagement,
    String? assignedCsm,
    String? recommendedIntervention,
  }) = _ChurnRiskAccount;

  factory ChurnRiskAccount.fromJson(Map<String, dynamic> json) =>
      _$ChurnRiskAccountFromJson(json);
}

@freezed
class ForecastDashboardData with _$ForecastDashboardData {
  const factory ForecastDashboardData({
    required List<ForecastData> forecast,
    required List<Deal> atRiskDeals,
    required List<ExpansionOpportunity> upsideOpportunities,
    required List<ChurnRiskAccount> churnRiskAccounts,
    required int atRiskDealsCount,
    required double upsidePotential,
    required double arrAtRisk,
    required DateTime lastUpdated,
  }) = _ForecastDashboardData;

  factory ForecastDashboardData.fromJson(Map<String, dynamic> json) =>
      _$ForecastDashboardDataFromJson(json);
}

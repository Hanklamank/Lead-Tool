import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/api_client.dart';
import '../models/forecast_data.dart';
import 'api_provider.dart';

final forecastProvider = FutureProvider<ForecastDashboardData>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  return await apiClient.getForecastData(months: 3);
});

final revenueForecastProvider = FutureProvider.family<List<ForecastData>, int>(
  (ref, months) async {
    final apiClient = ref.watch(apiClientProvider);
    return await apiClient.getRevenueForecast(months: months);
  },
);

final atRiskDealsProvider = FutureProvider.family<List<Deal>, double>(
  (ref, threshold) async {
    final apiClient = ref.watch(apiClientProvider);
    return await apiClient.getAtRiskDeals(threshold: threshold);
  },
);

final expansionOpportunitiesProvider = FutureProvider<List<ExpansionOpportunity>>(
  (ref) async {
    final apiClient = ref.watch(apiClientProvider);
    return await apiClient.getExpansionOpportunities();
  },
);

final churnRiskAccountsProvider = FutureProvider.family<List<ChurnRiskAccount>, double>(
  (ref, threshold) async {
    final apiClient = ref.watch(apiClientProvider);
    return await apiClient.getChurnRiskAccounts(threshold: threshold);
  },
);

// Auto-refresh provider
final autoRefreshProvider = StreamProvider<int>((ref) {
  return Stream.periodic(const Duration(minutes: 5), (count) => count);
});

// Combined provider that refreshes automatically
final autoRefreshForecastProvider = Provider<AsyncValue<ForecastDashboardData>>((ref) {
  ref.watch(autoRefreshProvider);
  return ref.watch(forecastProvider);
});

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/forecast_data.dart';
import '../models/lead.dart';
import '../models/opportunity.dart';
import '../models/lead_score.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: 'https://api.salesaipro.com/v1')
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  // Forecast endpoints
  @GET('/analytics/forecast')
  Future<ForecastDashboardData> getForecastData({
    @Query('months') int months = 3,
  });

  @GET('/analytics/forecast/revenue')
  Future<List<ForecastData>> getRevenueForecast({
    @Query('months') int months = 3,
  });

  @GET('/analytics/deals/at-risk')
  Future<List<Deal>> getAtRiskDeals({
    @Query('threshold') double threshold = 0.7,
  });

  @GET('/analytics/opportunities/expansion')
  Future<List<ExpansionOpportunity>> getExpansionOpportunities();

  @GET('/analytics/accounts/churn-risk')
  Future<List<ChurnRiskAccount>> getChurnRiskAccounts({
    @Query('threshold') double threshold = 0.6,
  });

  // Lead endpoints
  @GET('/leads')
  Future<List<Lead>> getLeads({
    @Query('status') String? status,
    @Query('limit') int limit = 50,
    @Query('offset') int offset = 0,
  });

  @GET('/leads/{id}')
  Future<Lead> getLead(@Path('id') String id);

  @POST('/leads')
  Future<Lead> createLead(@Body() Map<String, dynamic> lead);

  @PUT('/leads/{id}')
  Future<Lead> updateLead(
    @Path('id') String id,
    @Body() Map<String, dynamic> updates,
  );

  @DELETE('/leads/{id}')
  Future<void> deleteLead(@Path('id') String id);

  // Lead scoring
  @GET('/leads/{id}/score')
  Future<LeadScore> getLeadScore(@Path('id') String id);

  @POST('/leads/{id}/score/refresh')
  Future<LeadScore> refreshLeadScore(@Path('id') String id);

  // Opportunity endpoints
  @GET('/opportunities')
  Future<List<Opportunity>> getOpportunities({
    @Query('stage') String? stage,
    @Query('limit') int limit = 50,
    @Query('offset') int offset = 0,
  });

  @GET('/opportunities/{id}')
  Future<Opportunity> getOpportunity(@Path('id') String id);

  @POST('/opportunities')
  Future<Opportunity> createOpportunity(@Body() Map<String, dynamic> opportunity);

  @PUT('/opportunities/{id}')
  Future<Opportunity> updateOpportunity(
    @Path('id') String id,
    @Body() Map<String, dynamic> updates,
  );
}

class DioFactory {
  static Dio create({
    required String baseUrl,
    String? authToken,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        },
      ),
    );

    // Add interceptors
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));

    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          // Handle errors globally
          if (error.response?.statusCode == 401) {
            // Handle unauthorized
          }
          handler.next(error);
        },
      ),
    );

    return dio;
  }
}

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/api_client.dart';
import 'auth_provider.dart';

final dioProvider = Provider<Dio>((ref) {
  final authState = ref.watch(authProvider);
  final authToken = authState.maybeWhen(
    authenticated: (token, _) => token,
    orElse: () => null,
  );

  return DioFactory.create(
    baseUrl: 'https://api.salesaipro.com/v1',
    authToken: authToken,
  );
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiClient(dio);
});

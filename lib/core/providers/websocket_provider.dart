import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/websocket_client.dart';
import 'auth_provider.dart';

final websocketClientProvider = Provider<WebSocketClient>((ref) {
  final authState = ref.watch(authProvider);
  final authToken = authState.maybeWhen(
    authenticated: (token, _) => token,
    orElse: () => 'anonymous',
  );

  final client = WebSocketClient(
    url: 'wss://api.salesaipro.com/ws',
    authToken: authToken,
  );

  ref.onDispose(() {
    client.dispose();
  });

  return client;
});

final websocketMessagesProvider = StreamProvider<WebSocketMessage>((ref) {
  final client = ref.watch(websocketClientProvider);
  client.connect();
  return client.messages;
});

// Specific event streams
final dealAtRiskStreamProvider = StreamProvider<Map<String, dynamic>>((ref) {
  return ref.watch(websocketMessagesProvider.stream).where(
    (message) => message.event == WebSocketEvent.dealAtRisk,
  ).map((message) => message.data);
});

final forecastUpdatedStreamProvider = StreamProvider<Map<String, dynamic>>((ref) {
  return ref.watch(websocketMessagesProvider.stream).where(
    (message) => message.event == WebSocketEvent.forecastUpdated,
  ).map((message) => message.data);
});

final churnAlertStreamProvider = StreamProvider<Map<String, dynamic>>((ref) {
  return ref.watch(websocketMessagesProvider.stream).where(
    (message) => message.event == WebSocketEvent.churnAlert,
  ).map((message) => message.data);
});

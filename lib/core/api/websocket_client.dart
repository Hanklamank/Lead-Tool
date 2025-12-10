import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:logger/logger.dart';

enum WebSocketEvent {
  leadUpdated,
  dealAtRisk,
  forecastUpdated,
  churnAlert,
  expansionOpportunity,
  scoreChanged,
}

class WebSocketMessage {
  final WebSocketEvent event;
  final Map<String, dynamic> data;
  final DateTime timestamp;

  WebSocketMessage({
    required this.event,
    required this.data,
    required this.timestamp,
  });

  factory WebSocketMessage.fromJson(Map<String, dynamic> json) {
    return WebSocketMessage(
      event: _parseEvent(json['event'] as String),
      data: json['data'] as Map<String, dynamic>,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  static WebSocketEvent _parseEvent(String eventName) {
    switch (eventName) {
      case 'lead.updated':
        return WebSocketEvent.leadUpdated;
      case 'deal.at_risk':
        return WebSocketEvent.dealAtRisk;
      case 'forecast.updated':
        return WebSocketEvent.forecastUpdated;
      case 'churn.alert':
        return WebSocketEvent.churnAlert;
      case 'expansion.opportunity':
        return WebSocketEvent.expansionOpportunity;
      case 'score.changed':
        return WebSocketEvent.scoreChanged;
      default:
        throw ArgumentError('Unknown event: $eventName');
    }
  }
}

class WebSocketClient {
  final String url;
  final String authToken;
  final Logger _logger = Logger();

  WebSocketChannel? _channel;
  final _messageController = StreamController<WebSocketMessage>.broadcast();
  Timer? _reconnectTimer;
  bool _isConnecting = false;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;

  Stream<WebSocketMessage> get messages => _messageController.stream;

  WebSocketClient({
    required this.url,
    required this.authToken,
  });

  Future<void> connect() async {
    if (_isConnecting || _channel != null) return;

    _isConnecting = true;
    try {
      final uri = Uri.parse('$url?token=$authToken');
      _channel = WebSocketChannel.connect(uri);

      await _channel!.ready;
      _logger.i('WebSocket connected');
      _reconnectAttempts = 0;
      _isConnecting = false;

      _channel!.stream.listen(
        _handleMessage,
        onError: _handleError,
        onDone: _handleDisconnect,
        cancelOnError: false,
      );
    } catch (e) {
      _logger.e('WebSocket connection error: $e');
      _isConnecting = false;
      _scheduleReconnect();
    }
  }

  void _handleMessage(dynamic data) {
    try {
      final jsonData = jsonDecode(data as String) as Map<String, dynamic>;
      final message = WebSocketMessage.fromJson(jsonData);
      _messageController.add(message);
    } catch (e) {
      _logger.e('Error parsing WebSocket message: $e');
    }
  }

  void _handleError(Object error) {
    _logger.e('WebSocket error: $error');
    _scheduleReconnect();
  }

  void _handleDisconnect() {
    _logger.w('WebSocket disconnected');
    _channel = null;
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      _logger.e('Max reconnect attempts reached');
      return;
    }

    _reconnectTimer?.cancel();
    final delay = Duration(seconds: 2 * (_reconnectAttempts + 1));
    _reconnectTimer = Timer(delay, () {
      _reconnectAttempts++;
      _logger.i('Reconnecting... (attempt $_reconnectAttempts)');
      connect();
    });
  }

  void send(Map<String, dynamic> data) {
    if (_channel == null) {
      _logger.w('Cannot send message: WebSocket not connected');
      return;
    }

    try {
      _channel!.sink.add(jsonEncode(data));
    } catch (e) {
      _logger.e('Error sending WebSocket message: $e');
    }
  }

  Future<void> disconnect() async {
    _reconnectTimer?.cancel();
    await _channel?.sink.close();
    _channel = null;
    _isConnecting = false;
    _reconnectAttempts = 0;
  }

  void dispose() {
    disconnect();
    _messageController.close();
  }
}

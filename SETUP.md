# SalesAI Pro - Setup Guide

An AI-powered sales intelligence and forecasting platform built with Flutter.

## Features

### Forecast Dashboard
- **3-Month Revenue Forecast**: Visual representation of predicted revenue with confidence intervals
- **Deals at Risk**: Identify deals that need attention with risk scoring
- **Expansion Opportunities**: Discover upsell and cross-sell opportunities
- **Churn Risk Analysis**: Monitor accounts at risk of churning with health scores

### Architecture

```
lib/
├── main.dart
├── core/
│   ├── api/
│   │   ├── api_client.dart          # Retrofit API client
│   │   └── websocket_client.dart    # Real-time WebSocket connection
│   ├── models/
│   │   ├── forecast_data.dart       # Forecast and dashboard models
│   │   ├── lead.dart                # Lead models
│   │   ├── opportunity.dart         # Opportunity models
│   │   └── lead_score.dart          # Lead scoring models
│   └── providers/
│       ├── api_provider.dart        # API client provider
│       ├── auth_provider.dart       # Authentication state
│       ├── forecast_provider.dart   # Forecast data providers
│       └── websocket_provider.dart  # WebSocket providers
├── features/
│   └── analytics/
│       ├── screens/
│       │   └── forecast_dashboard_screen.dart
│       └── widgets/
│           ├── deal_risk_card.dart
│           ├── expansion_opportunity_card.dart
│           └── churn_risk_card.dart
└── shared/
    └── widgets/
        ├── loading_indicator.dart
        └── error_view.dart
```

## Getting Started

### Prerequisites
- Flutter SDK 3.0.0 or higher
- Dart SDK 3.0.0 or higher

### Installation

1. Install dependencies:
```bash
flutter pub get
```

2. Generate code (for Freezed, Retrofit, etc.):
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

3. Run the app:
```bash
flutter run
```

## State Management

This project uses **Riverpod** for state management:
- `FutureProvider` for async data fetching
- `StreamProvider` for real-time WebSocket updates
- `StateNotifier` for authentication state

## API Integration

The app connects to the SalesAI Pro backend API:
- Base URL: `https://api.salesaipro.com/v1`
- WebSocket: `wss://api.salesaipro.com/ws`

### Key Endpoints
- `GET /analytics/forecast` - Get forecast dashboard data
- `GET /analytics/deals/at-risk` - Get at-risk deals
- `GET /analytics/opportunities/expansion` - Get expansion opportunities
- `GET /analytics/accounts/churn-risk` - Get churn risk accounts

## Data Models

All models use **Freezed** for immutability and **json_serializable** for JSON serialization:

- `ForecastData`: Revenue forecast with confidence intervals
- `Deal`: Deal information with risk scoring
- `ExpansionOpportunity`: Upsell/cross-sell opportunities
- `ChurnRiskAccount`: Accounts at risk of churning
- `Lead`: Lead information and activities
- `Opportunity`: Sales opportunities

## Charts & Visualization

Using **Syncfusion Flutter Charts** for:
- Line charts for revenue trends
- Range area charts for confidence intervals
- Interactive tooltips and legends

## Real-time Updates

WebSocket integration provides real-time notifications for:
- Deal risk changes
- Forecast updates
- Churn alerts
- Score changes

## Testing

Run tests:
```bash
flutter test
```

## Code Generation

After modifying models or API clients, regenerate code:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Or watch for changes:
```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

## License

Proprietary - All rights reserved

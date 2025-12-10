import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Models
class DashboardStats {
  final int hotLeads;
  final int openDeals;
  final double forecastAmount;
  final double winRate;

  DashboardStats({
    required this.hotLeads,
    required this.openDeals,
    required this.forecastAmount,
    required this.winRate,
  });
}

class Lead {
  final String id;
  final int score;
  final String company;
  final String contact;

  Lead({
    required this.id,
    required this.score,
    required this.company,
    required this.contact,
  });
}

class PipelineStage {
  final String name;
  final double value;

  PipelineStage({required this.name, required this.value});
}

class PipelineHealth {
  final List<PipelineStage> stages;
  final double totalValue;

  PipelineHealth({required this.stages, required this.totalValue});
}

enum CallSentiment { positive, neutral, negative }

class Call {
  final String id;
  final CallSentiment sentiment;
  final String company;
  final Duration duration;
  final int dealScore;

  Call({
    required this.id,
    required this.sentiment,
    required this.company,
    required this.duration,
    required this.dealScore,
  });
}

class CampaignStats {
  final int sentToday;
  final double replyRate;
  final int meetingsBooked;

  CampaignStats({
    required this.sentToday,
    required this.replyRate,
    required this.meetingsBooked,
  });
}

class ForecastData {
  final String month;
  final double revenue;

  ForecastData({required this.month, required this.revenue});
}

class Forecast {
  final List<ForecastData> data;
  final double q1Total;

  Forecast({required this.data, required this.q1Total});
}

class TeamMember {
  final String name;
  final String avatar;
  final double quota; // Percentage 0-100

  TeamMember({required this.name, required this.avatar, required this.quota});
}

class TeamStats {
  final List<TeamMember> members;

  TeamStats({required this.members});
}

// Providers
final dashboardStatsProvider = FutureProvider<DashboardStats>((ref) async {
  await Future.delayed(const Duration(seconds: 1));
  return DashboardStats(
    hotLeads: 24,
    openDeals: 12,
    forecastAmount: 125.5,
    winRate: 32.5,
  );
});

final topLeadsProvider = FutureProvider<List<Lead>>((ref) async {
  await Future.delayed(const Duration(seconds: 1));
  return [
    Lead(id: '1', score: 98, company: 'TechCorp GmbH', contact: 'M. Mueller'),
    Lead(id: '2', score: 85, company: 'Innovate SA', contact: 'S. Weber'),
    Lead(id: '3', score: 72, company: 'Global Traders', contact: 'J. Schmidt'),
  ];
});

final pipelineHealthProvider = FutureProvider<PipelineHealth>((ref) async {
  await Future.delayed(const Duration(seconds: 1));
  return PipelineHealth(
    stages: [
      PipelineStage(name: 'Discovery', value: 30),
      PipelineStage(name: 'Proposal', value: 45),
      PipelineStage(name: 'Negotiation', value: 25),
    ],
    totalValue: 450.0,
  );
});

final recentCallsProvider = FutureProvider<List<Call>>((ref) async {
  await Future.delayed(const Duration(seconds: 1));
  return [
    Call(
      id: '1',
      sentiment: CallSentiment.positive,
      company: 'Alpha Inc',
      duration: const Duration(minutes: 12),
      dealScore: 88,
    ),
    Call(
      id: '2',
      sentiment: CallSentiment.neutral,
      company: 'Beta Ltd',
      duration: const Duration(minutes: 5),
      dealScore: 45,
    ),
  ];
});

final campaignStatsProvider = FutureProvider<CampaignStats>((ref) async {
  await Future.delayed(const Duration(seconds: 1));
  return CampaignStats(sentToday: 145, replyRate: 12.4, meetingsBooked: 3);
});

final forecastProvider = FutureProvider<Forecast>((ref) async {
  await Future.delayed(const Duration(seconds: 1));
  return Forecast(
    data: [
      ForecastData(month: 'Jan', revenue: 40),
      ForecastData(month: 'Feb', revenue: 55),
      ForecastData(month: 'Mar', revenue: 30), // Projected
    ],
    q1Total: 125.0,
  );
});

final teamStatsProvider = FutureProvider<TeamStats>((ref) async {
  await Future.delayed(const Duration(seconds: 1));
  return TeamStats(
    members: [
      TeamMember(
        name: 'Alice',
        avatar: 'https://i.pravatar.cc/150?u=alice',
        quota: 85,
      ),
      TeamMember(
        name: 'Bob',
        avatar: 'https://i.pravatar.cc/150?u=bob',
        quota: 62,
      ),
      TeamMember(
        name: 'Charlie',
        avatar: 'https://i.pravatar.cc/150?u=charlie',
        quota: 95,
      ),
    ],
  );
});

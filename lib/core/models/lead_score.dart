import 'package:freezed_annotation/freezed_annotation.dart';

part 'lead_score.freezed.dart';
part 'lead_score.g.dart';

@freezed
class LeadScore with _$LeadScore {
  const factory LeadScore({
    required String leadId,
    required double totalScore,
    required ScoreBreakdown breakdown,
    required List<String> positiveSignals,
    required List<String> negativeSignals,
    required String recommendation,
    required DateTime calculatedAt,
    String? nextBestAction,
  }) = _LeadScore;

  factory LeadScore.fromJson(Map<String, dynamic> json) =>
      _$LeadScoreFromJson(json);
}

@freezed
class ScoreBreakdown with _$ScoreBreakdown {
  const factory ScoreBreakdown({
    required double demographicScore,
    required double behaviorScore,
    required double engagementScore,
    required double companyFitScore,
    Map<String, double>? customScores,
  }) = _ScoreBreakdown;

  factory ScoreBreakdown.fromJson(Map<String, dynamic> json) =>
      _$ScoreBreakdownFromJson(json);
}

@freezed
class ScorePrediction with _$ScorePrediction {
  const factory ScorePrediction({
    required String leadId,
    required double conversionProbability,
    required double predictedValue,
    required int predictedDaysToClose,
    required double confidenceInterval,
    required List<String> keyFactors,
  }) = _ScorePrediction;

  factory ScorePrediction.fromJson(Map<String, dynamic> json) =>
      _$ScorePredictionFromJson(json);
}

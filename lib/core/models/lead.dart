import 'package:freezed_annotation/freezed_annotation.dart';

part 'lead.freezed.dart';
part 'lead.g.dart';

@freezed
class Lead with _$Lead {
  const factory Lead({
    required String id,
    required String email,
    required String? firstName,
    required String? lastName,
    required String? company,
    required String? title,
    required String? phone,
    required LeadSource source,
    required LeadStatus status,
    required double score,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? assignedTo,
    Map<String, dynamic>? customFields,
    @Default([]) List<String> tags,
    @Default([]) List<Activity> activities,
  }) = _Lead;

  factory Lead.fromJson(Map<String, dynamic> json) => _$LeadFromJson(json);
}

@freezed
class Activity with _$Activity {
  const factory Activity({
    required String id,
    required String type,
    required String description,
    required DateTime timestamp,
    required String? performedBy,
    Map<String, dynamic>? metadata,
  }) = _Activity;

  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);
}

enum LeadSource {
  @JsonValue('web')
  web,
  @JsonValue('referral')
  referral,
  @JsonValue('event')
  event,
  @JsonValue('cold_outreach')
  coldOutreach,
  @JsonValue('partner')
  partner,
  @JsonValue('other')
  other,
}

enum LeadStatus {
  @JsonValue('new')
  newLead,
  @JsonValue('contacted')
  contacted,
  @JsonValue('qualified')
  qualified,
  @JsonValue('proposal')
  proposal,
  @JsonValue('negotiation')
  negotiation,
  @JsonValue('won')
  won,
  @JsonValue('lost')
  lost,
}

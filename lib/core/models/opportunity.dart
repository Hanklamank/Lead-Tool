import 'package:freezed_annotation/freezed_annotation.dart';

part 'opportunity.freezed.dart';
part 'opportunity.g.dart';

@freezed
class Opportunity with _$Opportunity {
  const factory Opportunity({
    required String id,
    required String name,
    required String accountId,
    required String accountName,
    required double amount,
    required OpportunityStage stage,
    required double probability,
    required DateTime closeDate,
    required String ownerId,
    required String ownerName,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? description,
    String? nextSteps,
    @Default([]) List<Contact> contacts,
    @Default([]) List<OpportunityProduct> products,
    Map<String, dynamic>? customFields,
  }) = _Opportunity;

  factory Opportunity.fromJson(Map<String, dynamic> json) =>
      _$OpportunityFromJson(json);
}

@freezed
class Contact with _$Contact {
  const factory Contact({
    required String id,
    required String name,
    required String email,
    String? phone,
    String? role,
    bool? isPrimaryContact,
  }) = _Contact;

  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);
}

@freezed
class OpportunityProduct with _$OpportunityProduct {
  const factory OpportunityProduct({
    required String id,
    required String name,
    required double quantity,
    required double unitPrice,
    required double totalPrice,
  }) = _OpportunityProduct;

  factory OpportunityProduct.fromJson(Map<String, dynamic> json) =>
      _$OpportunityProductFromJson(json);
}

enum OpportunityStage {
  @JsonValue('prospecting')
  prospecting,
  @JsonValue('qualification')
  qualification,
  @JsonValue('needs_analysis')
  needsAnalysis,
  @JsonValue('proposal')
  proposal,
  @JsonValue('negotiation')
  negotiation,
  @JsonValue('closed_won')
  closedWon,
  @JsonValue('closed_lost')
  closedLost,
}

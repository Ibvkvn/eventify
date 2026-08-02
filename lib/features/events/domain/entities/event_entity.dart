enum EventVisibility {public, private}

class EventEntity {
  final String id;
  final String title;
  final String createdBy;
  final DateTime createdAt;
  final EventVisibility eventVisibility;
  final String joinCode;
  final int memberCount;

  const EventEntity({
    required this.id,
    required this.title,
    required this.createdBy,
    required this.createdAt,
    required this.eventVisibility,
    required this.joinCode,
    this.memberCount = 0,
  });
}
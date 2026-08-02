import 'package:eventify/features/events/domain/entities/event_entity.dart';

abstract class EventRepository {
  Future<EventEntity> createEvent({
    required String title,
    required String createdBy,
    required EventVisibility eventVisibility
  });

  Future<EventEntity?> getEventByCode(String joinCode);
  Future<EventEntity?> getEventById(String eventId);
  Future<void> joinEvent({required String userId, required String eventId});
  Future<bool> isMember({required String eventId, required String userId});
  Stream<List<EventEntity>> watchUserEvents(String userId);
  Stream<List<EventEntity>> watchPublicEvents();
  
}
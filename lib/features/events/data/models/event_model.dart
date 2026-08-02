import 'package:eventify/features/events/domain/entities/event_entity.dart';

class EventModel extends EventEntity{
  const EventModel({
    required super.id,
    required super.title,
    required super.createdBy,
    required super.eventVisibility,
    required super.joinCode,
    super.memberCount,
    required super.createdAt
  });

  factory EventModel.fromMap(Map<String, dynamic>map, String id){
    return EventModel(
      id: id, 
      title: map['title'] as String, 
      createdBy: map['createdBy'] as String, 
      eventVisibility: (map['eventVisibility'] as String) == "public" ? EventVisibility.public : EventVisibility.private, 
      joinCode: map['joinCode'] as String, 
      createdAt: (map['createdAt'] as dynamic).toDate() as DateTime,
      memberCount: map['memberCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'title': title,
      'createdBy': createdBy,
      'eventVisibility': eventVisibility == EventVisibility.public ? 'public' : 'private',
      'joinCode': joinCode,
      'memberCount': memberCount,
      'createdAt': createdAt
    };
  }
}
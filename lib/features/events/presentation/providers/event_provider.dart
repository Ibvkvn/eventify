import 'package:eventify/features/auth/domain/entities/user_entity.dart';
import 'package:eventify/features/auth/presentation/providers/auth_provider.dart';
import 'package:eventify/features/events/data/repositories/event_repository_implementation.dart';
import 'package:eventify/features/events/domain/entities/event_entity.dart';
import 'package:eventify/features/events/domain/repositories/event_repository.dart';
import 'package:eventify/features/media/domain/entities/media_entity.dart';
import 'package:eventify/features/media/domain/repositories/media_repository.dart';
import 'package:eventify/features/media/domain/repositories/media_repository_implementation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final eventRepositoryProvider = Provider<EventRepository>((ref){
  return EventRepositoryImplementation();
});

final mediaRepositoryProvider = Provider<MediaRepository>((ref){
  return MediaRepositoryImplementation();
});

final publicEventsProvider = StreamProvider<List<EventEntity>>((ref){
  // return ref.watch(eventRepositoryProvider).watchPublicEvents();
  return ref.watch(eventRepositoryProvider).watchPublicEvents().map((events) {
    debugPrint('📍 public events found: ${events.length} — ${events.map((e) => e.title).toList()}');
    return events;
  });
});

final publicFeedProvider = StreamProvider<List<MediaEntity>>((ref){
  final eventIds = ref.watch(publicEventIdsProvider);
  return ref.watch(mediaRepositoryProvider).watchMediaForEvents(eventIds);
});

final eventIdProvider = FutureProvider.family<EventEntity?, String>((ref, eventId){
  return ref.watch(eventRepositoryProvider).getEventById(eventId);
});

final userIdProvider = FutureProvider.family<UserEntity?, String>((ref, userId){
  return ref.watch(authRepositoryProvider).getUserById(userId);
});

final userMediaProvider = StreamProvider.family<List<MediaEntity>, String>((ref, userId){
  return ref.watch(mediaRepositoryProvider).watchUserMedia(userId);
});

final userEventProvider = StreamProvider.family<List<EventEntity>, String>((ref, userId){
  return ref.watch(eventRepositoryProvider).watchUserEvents(userId);
});

final publicEventIdsProvider = Provider<List<String>>((ref){
  return ref.watch(publicEventsProvider.select(
    (asyncEvents) => asyncEvents.value?.map((e) => e.id).toList() ?? [],
  ));
});
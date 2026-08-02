import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventify/features/events/data/models/event_model.dart';
import 'package:eventify/features/events/domain/entities/event_entity.dart';
import 'package:eventify/features/events/domain/repositories/event_repository.dart';

class EventRepositoryImplementation implements EventRepository{
  final FirebaseFirestore _firebaseFirestore;

  EventRepositoryImplementation({FirebaseFirestore? firebaseFirestore}): _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _events => _firebaseFirestore.collection("events");

  @override 
  Future<EventEntity> createEvent({
    required String title, 
    required String createdBy, 
    required EventVisibility eventVisibility
  }) async {
    final joinCode = await _generateUniqueCode();
    final docRef = _events.doc();
    final event = EventModel(
      id: docRef.id, 
      title: title, 
      createdBy: createdBy, 
      eventVisibility: eventVisibility, 
      joinCode: joinCode, 
      createdAt: DateTime.now(), 
      memberCount: 0
    );
    await docRef.set(event.toMap());
    return event;
  }

  @override
  Future<EventEntity?> getEventByCode(String joinCode) async{
    final query = await _events.where('joinCode', isEqualTo: joinCode).limit(1).get();
    if(query.docs.isEmpty){
      return null;
    }
    final doc = query.docs.first;
    return EventModel.fromMap(doc.data(), doc.id);
  }

  @override
  Future<EventEntity?> getEventById(String eventId) async {
    final doc = await _events.doc(eventId).get();
    if(!doc.exists){
      return null;
    }
    return EventModel.fromMap(doc.data()!, doc.id);
  }

  @override
  Future<void> joinEvent({required String eventId, required String userId}) async {
    final eventRef = _events.doc(eventId);
    final memberRef = eventRef.collection('members').doc(userId);
    final memberDoc = await memberRef.get();

    if (memberDoc.exists) return;

    await _firebaseFirestore.runTransaction((transaction) async {
      transaction.set(memberRef, {'joinedAt': DateTime.now()});
      transaction.update(eventRef, {'memberCount': FieldValue.increment(1)});
    });
  }

  @override
  Future<bool> isMember({required String eventId, required String userId}) async {
    final doc = await _events.doc(eventId).collection("users").doc(userId).get();
    return doc.exists;
  }

  @override
  Stream<List<EventEntity>> watchUserEvents(String userId) {
    final createdStream = _events.where("createdBy", isEqualTo: userId).snapshots();
    final joinedStream = _firebaseFirestore.collectionGroup("members").where(FieldPath.documentId, isEqualTo: userId).snapshots();

    return createdStream.asyncMap((createdSnap) async {
      final created = createdSnap.docs.map((d) => EventModel.fromMap(d.data(), d.id)).toList();
      final joinedSnap = await joinedStream.first;
      final joinedEventsId = joinedSnap.docs.map((d) => d.reference.parent.parent!.id);
      final joinedEvents = <EventEntity> [];
      for (final eventId in joinedEventsId){
        if (created.any((e) => e.id == eventId)){
          continue;
        }
        final doc = await _events.doc(eventId).get();
        if (doc.exists){
          joinedEvents.add(EventModel.fromMap(doc.data()!, doc.id));
        }
      }

      return[...created, ...joinedEvents];
    });
  }

  @override
  Stream<List<EventEntity>> watchPublicEvents () {
    return _events.where('eventVisibility', isEqualTo: 'public').snapshots().map((snap){
      return snap.docs.map((d) => EventModel.fromMap(d.data(), d.id)).toList();
    });
  }

  Future<String> _generateUniqueCode() async {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final random = Random.secure();

    while(true){
      final code = List.generate(5, (generator) => chars[random.nextInt(chars.length)]).join();
      final existing = await getEventByCode(code);

      if(existing == null){
        return code;
      }
    }
  }
}
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventify/features/media/data/models/media_model.dart';
import 'package:eventify/features/media/domain/entities/media_entity.dart';
import 'package:eventify/features/media/domain/repositories/media_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MediaRepositoryImplementation implements MediaRepository{
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseStorage _firebaseStorage;

  MediaRepositoryImplementation({
    FirebaseFirestore? firebaseFireStore,
    FirebaseStorage? firebaseStorage,
  }) : 
  _firebaseFirestore = firebaseFireStore ?? FirebaseFirestore.instance,
  _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  CollectionReference<Map<String, dynamic>> get _media => _firebaseFirestore.collection("media");

  @override
  Future<MediaEntity> uploadMedia({
    required String eventId,
    required String uploadedBy,
    required String mediaPath,
    required MediaType fileType
  }) async {
    final docRef = _media.doc();
    final file = File(mediaPath);
    final storageRef = _firebaseStorage.ref("events/$eventId/media/${docRef.id}");
    await storageRef.putFile(file);
    final url = await storageRef.getDownloadURL();
    final media = MediaModel(
      id: docRef.id, 
      eventId: eventId, 
      mediaType: fileType, 
      uploadedBy: uploadedBy, 
      mediaUrl: url, 
      thumbnailUrl: null,
      createdAt: DateTime.now()
    );

    await docRef.set(media.toMap());
    return media;
  }

  @override 
  Stream<List<MediaEntity>> watchEventMedia(String eventId){
    return _media
    .where("eventId", isEqualTo: eventId)
    .orderBy("createdAt", descending: true)
    .snapshots()
    .map(
      (snap) => snap.docs.map((d) => MediaModel.fromMap(d.data(), d.id)).toList()
    );
  }

  @override
  Stream<List<MediaEntity>> watchMediaForEvents(List<String> eventIds){
    if(eventIds.isEmpty){
      return Stream.value([]);
    }

    final limitedIds = eventIds.take(10).toList();
    return _media
    .where("eventId", whereIn: limitedIds)
    .orderBy("createdAt", descending: true)
    .snapshots()
    .map(
      (snap) => snap.docs.map((d) => MediaModel.fromMap(d.data(), d.id)).toList()
    );
  }
}
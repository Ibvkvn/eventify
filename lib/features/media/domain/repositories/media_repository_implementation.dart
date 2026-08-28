  import 'dart:convert';

  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:eventify/features/media/data/models/media_model.dart';
  import 'package:eventify/features/media/domain/entities/media_entity.dart';
  import 'package:eventify/features/media/domain/repositories/media_repository.dart';
  import 'package:http/http.dart' as http;

  class MediaRepositoryImplementation implements MediaRepository{
    final FirebaseFirestore _firebaseFirestore;
    // final FirebaseStorage _firebaseStorage;

    MediaRepositoryImplementation({
      FirebaseFirestore? firebaseFireStore,
      // FirebaseStorage? firebaseStorage,
    }) : 
    _firebaseFirestore = firebaseFireStore ?? FirebaseFirestore.instance;
    // _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

    static const String _cloudinaryCloudName = "ankfhkbq";
    static const String _cloudinaryUploadPreset = "first_trial";

    CollectionReference<Map<String, dynamic>> get _media => _firebaseFirestore.collection("media");

    Future<String?> _uploadToCloudinary (String mediaPath, MediaType mediaType) async {
      final resourceType = mediaType == MediaType.video ? "video" : "image";
      final uri = Uri.parse("https://api.cloudinary.com/v1_1/$_cloudinaryCloudName/$resourceType/upload");

      final request = http.MultipartRequest("POST", uri)
      ..fields["upload_preset"] = _cloudinaryUploadPreset
      ..files.add(await http.MultipartFile.fromPath("file", mediaPath));

      final streamResponse = await request.send();
      final response = await http.Response.fromStream(streamResponse);

      if(response.statusCode != 200){
        throw Exception("cloudinary upload failed $response");
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data["secure_url"] as String;
    }

    @override
    Future<MediaEntity> uploadMedia({
      required String eventId,
      required String uploadedBy,
      required String mediaPath,
      required MediaType fileType
    }) async {
      final docRef = _media.doc();
      final url = await _uploadToCloudinary(mediaPath, fileType);

      final media = MediaModel(
        id: docRef.id, 
        eventId: eventId, 
        mediaType: fileType, 
        uploadedBy: uploadedBy, 
        mediaUrl: url!, 
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

    @override
    Stream<List<MediaEntity>> watchUserMedia (String userId) {
      return _media
      .where('uploadedBy', isEqualTo: userId)
      .orderBy("createdAt", descending: true)
      .snapshots()
      .map((snap) => snap.docs.map((d) => MediaModel.fromMap(d.data(), d.id)).toList());
    }
  }
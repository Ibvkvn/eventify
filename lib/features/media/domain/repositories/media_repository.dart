import 'package:eventify/features/media/domain/entities/media_entity.dart';

abstract class MediaRepository {
  Future<MediaEntity> uploadMedia({
    required String eventId,
    required String uploadedBy,
    required String mediaPath,
    required MediaType fileType
  });

  Stream<List<MediaEntity>> watchEventMedia(String eventId);

  Stream<List<MediaEntity>> watchMediaForEvents(List<String> eventIds);
}
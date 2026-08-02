enum MediaType{photo, video}

class MediaEntity {
  final String id;
  final String eventId;
  final String uploadedBy;
  final String mediaUrl;
  final MediaType mediaType;
  final String? thumbnailUrl;
  final DateTime createdAt;

  MediaEntity({
    required this.id,
    required this.eventId,
    required this.uploadedBy,
    required this.mediaUrl,
    required this.mediaType,
    this.thumbnailUrl,
    required this.createdAt,
  });
}
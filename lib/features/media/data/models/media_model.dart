import 'package:eventify/features/media/domain/entities/media_entity.dart';

class MediaModel extends MediaEntity{
  MediaModel({
    required super.id,
    required super.eventId,
    required super.mediaType,
    required super.uploadedBy,
    required super.mediaUrl,
    super.thumbnailUrl,
    required super.createdAt
  });

  factory MediaModel.fromMap(Map<String, dynamic> map, String id){
    return MediaModel(
      id: id, 
      eventId: map["eventId"] as String, 
      mediaType: (map["mediaType"] as String) =="video" ? MediaType.video : MediaType.photo, 
      uploadedBy: map["uploadedBy"] as String, 
      mediaUrl: map["mediaUrl"] as String, 
      createdAt: (map["createdAt"] as dynamic).toDate() as DateTime
    );
  }

  Map<String, dynamic> toMap() {
    return{
      "eventId": eventId,
      "mediaType": mediaType == MediaType.video ? "video" : "photo",
      "uploadedBy": uploadedBy,
      "mediaUrl": mediaUrl,
      "createdAt": createdAt
    };
  }
}
import 'package:eventify/features/media/domain/entities/media_entity.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ThumbnailTile extends StatelessWidget {
  final MediaEntity media;

  const ThumbnailTile({
    super.key,
    required this.media
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = media.mediaType == MediaType.photo ? media.mediaUrl : media.thumbnailUrl;

    return Container(
      color: Theme.of(context).colorScheme.onSurface,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (imageUrl != null)
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              height: 100,
              errorBuilder: (context, error, stackTrace) => PhosphorIcon(PhosphorIcons.videoCamera())
            )
          else
            Center(child: Text("error"),)
        ],
      ),
    );
  }
}
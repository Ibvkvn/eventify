import 'package:eventify/core/widgets/custom_progress_indicator.dart';
import 'package:eventify/core/widgets/divider_widget.dart';
import 'package:eventify/features/events/presentation/providers/event_provider.dart';
import 'package:eventify/features/media/domain/entities/media_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class UsersScreen extends ConsumerWidget {
  final String userId;
  const UsersScreen({
    super.key,
    required this.userId
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userIdProvider(userId));
    final userMediaAsync = ref.watch(userMediaProvider(userId));

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(
            horizontal: 24,
          ),
          child: userAsync.when(
            data: (user) =>  SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(user!.userName),
                          if (user.displayName != null)
                            Text(user.displayName!)
                        ],
                      ),
                      CircleAvatar(
                        radius: 48,
                        backgroundImage: user.displayPictureUrl != null ? NetworkImage("${user.displayPictureUrl}") : null,
                      )
                    ],
                  ),
                  SizedBox(height: 18,),
                  Dividerwidget(text: "${user.userName} posts"),
                  SizedBox(height: 18,),
                  Consumer(
                    builder: (context, ref, _) {
                      return userMediaAsync.when(
                        data: (data) {
                          if(data.isEmpty){
                            return Center(
                              child: Text("No Posts yet"),
                            );
                          }
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 2,
                              mainAxisSpacing: 2
                            ), 
                            itemCount: data.length,
                            itemBuilder: (context, index){
                              final media = data[index];
                              return ThumbnailTile(media: media);
                            },
                          );
                        }, 
                        error: (_, _){
                          return Center(child: Text("something went wrong, try again"),);
                        }, 
                        loading: (){return CustomProgressIndicator();}
                      );
                    }
                  ),
                ],
              ),
            ),
            loading: () => CustomProgressIndicator(),
            error: (error, stackTrace) {
              return Center(
                child: Text("something went wrong"),
              );
            },
          ),
        ),
      ),
    );
  }
}

class ThumbnailTile extends StatelessWidget {
  final MediaEntity media;

  const ThumbnailTile({
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
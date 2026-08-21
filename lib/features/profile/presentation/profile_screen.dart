import 'package:eventify/core/widgets/custom_progress_indicator.dart';
import 'package:eventify/core/widgets/divider_widget.dart';
import 'package:eventify/features/auth/presentation/providers/auth_provider.dart';
import 'package:eventify/features/events/presentation/providers/event_provider.dart';
import 'package:eventify/features/media/domain/entities/media_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(authStateChangesProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 24),
          child: userAsync.when(
            data: (data){
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 44,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                              "${data!.displayName}"
                            ),
                            Text(
                              data.userName
                            )
                          ],
                        ),
                        CircleAvatar(
                          radius: 48,
                          backgroundImage: data.displayPictureUrl != null ? NetworkImage("${data.displayPictureUrl}") : null,
                        )
                      ],
                    ),
                    SizedBox(height: 18,),
                    Dividerwidget(text: "My posts"),
                    Consumer(builder: (context, ref, _){
                      final mediaAsync = ref.watch(userMediaProvider(data.id));

                      return mediaAsync.when(
                        data: (data){
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
                            itemBuilder: (context, index){
                              final media = data[index];
                              return _ThumbnailTile(media: media);
                            },
                          );
                        }, 
                        error: (_, __){
                          return Center(
                            child: Text("an error occured $__ "),
                          );
                        }, 
                        loading: (){
                          return Center(
                            child: CustomProgressIndicator(),
                          );
                        }
                      );
                    })
                  ],
                ),
              );
            },
            loading: (){
              return Center(
                child: CustomProgressIndicator(),
              );
            },
            error: (_, __){
              return Center(
                child: Text("something went wrong"),
              );
            },
          ),
        )
      )
    );
  }
}

class _ThumbnailTile extends StatelessWidget {
  final MediaEntity media;

  const _ThumbnailTile({
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
              errorBuilder: (context, error, stackTrace) => PhosphorIcon(PhosphorIcons.videoCamera())
            )
          else
            Center(child: Text("error"),)
        ],
      ),
    );
  }
}
import 'package:eventify/core/widgets/custom_progress_indicator.dart';
import 'package:eventify/features/auth/presentation/providers/auth_provider.dart';
import 'package:eventify/features/events/presentation/providers/event_provider.dart';
import 'package:eventify/features/media/domain/entities/media_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MediaOverlay extends ConsumerWidget {
  final MediaEntity media;
  const MediaOverlay({
    super.key,
    required this.media
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(eventIdProvider(media.id));
    final userAsync = ref.watch(userIdProvider(media.uploadedBy));
    final currentUser = ref.watch(authStateChangesProvider).value;

    return Positioned(
      left: -40,
      right: 16,
      bottom: 64,
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                eventAsync.when(
                  data: (data){
                    return Text(
                      data?.title ?? "unkown Room",
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Theme.of(context).colorScheme.tertiaryFixed),
                    );
                  }, 
                  error: (object, stackTrace){
                    return SizedBox.shrink();
                  }, 
                  loading: (){
                    return CustomProgressIndicator();
                  }
                ),
                SizedBox(height: 4,),
                userAsync.when(
                  data: (data) => Text('@${data!.userName}'), 
                  error: (object, stackTrace){
                    return CustomProgressIndicator(color: Theme.of(context).colorScheme.error,);
                  }, 
                  loading: (){
                    return CustomProgressIndicator();
                  }
                ),
                SizedBox(height: 4,),
                eventAsync.when(
                  data: (event){
                    if (event != null || currentUser == null){
                      return SizedBox.shrink();
                    }
                    return Container(
                      height: 40,
                      width: 80,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(12)
                      ),
                      child: Text(
                        "join event!",
                        style: TextStyle(color: Theme.of(context).colorScheme.tertiaryFixed),
                      ),
                    );
                  }, 
                  error: (_, _){
                    return SizedBox.shrink();
                  }, 
                  loading: (){
                    return CustomProgressIndicator();
                  }
                )
              ],
            )
          )
        ],
      ),
    );
  }
}
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
    final eventAsync = ref.watch(eventIdProvider(media.eventId));
    final userAsync = ref.watch(userIdProvider(media.uploadedBy));
    final currentUser = ref.watch(authStateChangesProvider).value;
    final joinEventAsync = ref.watch(eventRepositoryProvider);

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
                  data: (data) => Text(
                    data?.title ?? "unknown room",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 20),
                  ), 
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
                    if (event == null || currentUser == null){
                      return SizedBox.shrink();
                    }
                    return JoinRoomWidget(currentUserId: currentUser.email, eventId: event.id);
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

class JoinRoomWidget extends ConsumerStatefulWidget {
  final String currentUserId;
  final String eventId;

  const JoinRoomWidget({
    super.key,
    required this.currentUserId,
    required this.eventId
  });

  @override
  ConsumerState<JoinRoomWidget> createState() => _JoinRoomWidgetState();
}

class _JoinRoomWidgetState extends ConsumerState<JoinRoomWidget> {
  bool? isMemeber;
  bool isJoining = false;

  @override
  void initState (){
    super.initState();
    checkMemberShip();
  }

  Future<void> checkMemberShip() async {
    final result = await ref.watch(eventRepositoryProvider).isMember(eventId: widget.eventId, userId: widget.currentUserId);
    if(mounted){
      setState(() {
        isMemeber = result;
      });
    }
  }

  Future<void> handleJoinRoom() async {
    setState(() {
      isJoining = true;
    });
    await ref.read(eventRepositoryProvider).joinEvent(userId: widget.currentUserId, eventId: widget.eventId);
    if(mounted){
      setState(() {
        isMemeber = true;
        isJoining = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: isMemeber == true ? null : handleJoinRoom, 
      child: isJoining ? 
      CustomProgressIndicator() 
      : 
      Text(
        isMemeber == true ? "already a member" : "join event!",
        style: Theme.of(context).textTheme.labelLarge,
      )
    );
  }
}
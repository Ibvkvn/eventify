import 'package:eventify/features/auth/presentation/providers/auth_provider.dart';
import 'package:eventify/features/events/domain/entities/event_entity.dart';
import 'package:eventify/features/events/presentation/providers/event_provider.dart';
import 'package:eventify/features/media/domain/entities/media_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedRoomScreen extends ConsumerStatefulWidget {
  final String mediaFilePath;
  const SelectedRoomScreen({super.key, required this.mediaFilePath});

  @override
  ConsumerState<SelectedRoomScreen> createState() => _SelectedRoomScreenState();
}

class _SelectedRoomScreenState extends ConsumerState<SelectedRoomScreen> {
  EventEntity? selectedEvent;
  bool isUploading = false;

  Future<void> pickRoom() async {
    final currentUser = ref.watch(authStateChangesProvider).value;

    if(currentUser == null) return;

    final selected = await showModalBottomSheet<EventEntity>(context: context, isDismissible: true, builder: (context){return Center(child: Text("data"),);});

    if(selected != null){
      setState(() {
        selectedEvent = selected;
      });
    }
  }

  Future<void> postMedia() async {
    if(selectedEvent == null) return;

    final currentUser = ref.watch(authStateChangesProvider).value;
    if(currentUser == null) return;

    setState(() {
      isUploading = true;
    });

    try{
      await ref.watch(mediaRepositoryProvider).uploadMedia(eventId: selectedEvent!.id, uploadedBy: currentUser.id, mediaPath: widget.mediaFilePath, fileType: MediaType.photo);

      if(mounted){
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    } catch (e){
      if(mounted){
        setState(() {
          isUploading = false;
          debugPrint("upload failed");
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
import 'dart:io';

import 'package:eventify/core/widgets/custom_progress_indicator.dart';
import 'package:eventify/features/auth/presentation/providers/auth_provider.dart';
import 'package:eventify/features/events/domain/entities/event_entity.dart';
import 'package:eventify/features/events/presentation/providers/event_provider.dart';
import 'package:eventify/features/media/domain/entities/media_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

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

    final selected = await showModalBottomSheet<EventEntity>(
      context: context, 
      backgroundColor: Theme.of(context).colorScheme.tertiary.withOpacity(0.6), 
      isDismissible: true, 
      builder: (context) => _RoomSelector(userId: currentUser.id)
    );

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
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.file(File(widget.mediaFilePath), fit: BoxFit.contain,),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: PhosphorIcon(PhosphorIcons.x(), color: Colors.white,),
                  ),
                ),
              ),
            )
          ),

          Positioned(
            left: 0, right: 0, bottom: 0,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    InkWell(
                      onTap: pickRoom,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(12)
                        ),
                        child: Row(
                          children: [
                            PhosphorIcon(PhosphorIcons.usersThree(), color: Theme.of(context).colorScheme.tertiary, size: 20,),
                            SizedBox(width: 10,),
                            Expanded(
                              child: Text(
                                selectedEvent == null ? "Select room to post to" : selectedEvent!.title,
                                style: Theme.of(context).textTheme.bodyLarge
                              )
                            ),
                            PhosphorIcon(PhosphorIcons.caretRight(), size: 18, color: Theme.of(context).colorScheme.tertiary,)
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 12,),
                    FilledButton(
                      onPressed: (selectedEvent == null || isUploading) ? null : postMedia, 
                      child: isUploading ?  SizedBox(
                        height: 20,
                        width: 20,
                        child: CustomProgressIndicator(),
                      ) : Text(
                        "upload media",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary
                        ),
                      )
                    )
                  ],
                ),
              )
            )
          ),
        ],
      ),
    );
  }
}

class _RoomSelector extends ConsumerWidget {
  final String userId;

  const _RoomSelector({required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userEventsAsync = ref.watch(userEventProvider(userId));

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Post to: ",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.surface)
            ),
            SizedBox(height: 12,),
            Flexible(
              child: userEventsAsync.when(
                data: (data){
                  if(data.isEmpty){
                    return Center(
                      child: Text("you are currently not in any event"),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (build, index){
                      final event = data[index];
                      
                      return ListTile(
                        title: Text(event.title),
                        subtitle: Text("${event.memberCount} members"),
                        onTap: () => Navigator.pop(context, event)
                      );
                    }
                  );
                }, 
                error: (_, _){
                  return Center(
                    child: Text("something went wrong: _, _"),
                  );
                }, 
                loading: (){
                  return Center(
                    child: SizedBox(
                      height: 20, width: 20,
                      child: CustomProgressIndicator(),
                    ),
                  );
                }
              )
            )
          ],
        )
      ),
    );
  }
}
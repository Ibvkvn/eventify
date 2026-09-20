import 'package:eventify/core/widgets/custom_progress_indicator.dart';
import 'package:eventify/core/widgets/text_field_widget.dart';
import 'package:eventify/features/auth/presentation/providers/auth_provider.dart';
import 'package:eventify/features/events/domain/entities/event_entity.dart';
import 'package:eventify/features/events/presentation/providers/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HomeTopBar extends ConsumerWidget {
  final VoidCallback onSearch;
  final VoidCallback createRoom;
  const HomeTopBar({
    super.key,
    required this.onSearch,
    required this.createRoom
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return SafeArea(
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 40,
                padding: EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.tertiaryFixed
                  )
                ),
                child: Text(
                  "search for a friend or an event",
                  style: Theme.of(context).textTheme.labelMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            SizedBox(width: 6,),
            FilledButton(
              onPressed: () =>  showDialog(context: context, builder: (_) => CreateEventRoomWidget()),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(9)
                ),
                backgroundColor: Theme.of(context).colorScheme.tertiaryFixed
              ),
              child: PhosphorIcon(PhosphorIcons.plus(),)
            ),
          ],
        ),
      ),
    );
  }
}

class CreateEventRoomWidget extends ConsumerStatefulWidget {
  const CreateEventRoomWidget({super.key});

  @override
  ConsumerState<CreateEventRoomWidget> createState() => _CreateEventRoomWidgetState();
}

class _CreateEventRoomWidgetState extends ConsumerState<CreateEventRoomWidget> {
  final eventTitleController = TextEditingController();
  EventVisibility eventVisibility = EventVisibility.public;
  bool isCreating = false;
  String? errorText;


  @override 
  void dispose(){
    eventTitleController.dispose();
    super.dispose();
  }

  Future<void> createEventRoom() async {
    final title = eventTitleController.text.trim();
    if(title.isEmpty){
      setState(() {
        errorText = "room title is required";
      });
      return;
    }

    final user = ref.read(authStateChangesProvider).value;
    if (user == null) return;

    setState(() {
      isCreating = true;
    });

    try{
      final event =  await ref.read(eventRepositoryProvider).createEvent(title: title, createdBy: user.id, eventVisibility: eventVisibility);

      if(!mounted) return;
      Navigator.pop(context);
      showDialog(
        context: context, 
        builder: (_) => AlertDialog(
          title: Center(child: Text("room created!")),
          content: Text(
            event.joinCode,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        )
      );
    }
    catch(e){
      if(!mounted) return;

      setState(() {
        isCreating = false;
        errorText = "could not create the room";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(12)
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("create an event room", style: Theme.of(context).textTheme.titleMedium,),
          SizedBox(height: 12,),
          Textfieldwidget(
            hintText: "e.g boys night out", 
            textEditingController: eventTitleController, 
            errorText: errorText, 
            onChanged:(value) {
              if(errorText != null){
                setState(() {
                  errorText = null;
                });
              }
            },
          ),
          SizedBox(height: 16,),
          SegmentedButton<EventVisibility>(
            segments: [
              ButtonSegment(value: EventVisibility.public, label: Text("public")),
              ButtonSegment(value: EventVisibility.private, label: Text("private"))
            ], 
            selected: {eventVisibility},
            onSelectionChanged: (p0) {
              setState(() {
                eventVisibility = p0.first;
              });
            },
          ),
          SizedBox(
            height: 16,
          ),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: isCreating ? null : createEventRoom, 
              child: isCreating? CustomProgressIndicator() : Text("create room")
            ),
          )
        ],
      ),
    );
  }
}
import 'package:eventify/core/widgets/custom_progress_indicator.dart';
import 'package:eventify/core/widgets/divider_widget.dart';
import 'package:eventify/core/widgets/media_overlay.dart';
import 'package:eventify/features/auth/presentation/providers/auth_provider.dart';
import 'package:eventify/features/events/presentation/providers/event_provider.dart';
import 'package:eventify/features/profile/presentation/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class EventScreen extends ConsumerWidget {
  final String eventId;
  const EventScreen({
    super.key, 
    required this.eventId
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(authStateChangesProvider);
    final eventAsync = ref.watch(eventIdProvider(eventId));
    final mediaAsync = ref.watch(eventMediaProvider(eventId));

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Consumer(
            builder: (context, ref, _){
              return eventAsync.when(
                data: (data){
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () => Navigator.pop(context),
                              child: PhosphorIcon(PhosphorIcons.arrowLeft()))
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                data!.title,
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                            ),
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).colorScheme.tertiary
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            PhosphorIcon(PhosphorIcons.usersThree()),
                            SizedBox(width: 3,),
                            Text(
                              "${data.memberCount} members"
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            userAsync.when(
                              data: (data) {
                                return JoinRoomWidget(currentUserId: data!.id, eventId: eventId);
                              },
                              error: (error, stackTrace) {
                                return CustomProgressIndicator();
                              },
                              loading: () {
                                return CustomProgressIndicator();
                              },
                            ),
                            // SizedBox(width: 8,),
                            Text(
                              data.joinCode, 
                              style: Theme.of(context).textTheme.headlineSmall,
                            )
                          ],
                        ),
                        Dividerwidget(text: "posts"),
                        Consumer(builder: (context, ref, _){
                          return mediaAsync.when(
                            data: (data){
                              if(data.isEmpty){
                                return Center(
                                  child: Text("no posts yet"),
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
                              return Center(
                                child: CustomProgressIndicator(),
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
                error: (_, _){
                  return Center(
                    child: Text("somthing went wrong ✌"),
                  );
                }, 
                loading: (){
                  return Center(
                    child: CustomProgressIndicator(),
                  );
                }
              );
            }
          )
        ),
      ),
    );
  }
}
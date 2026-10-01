import 'package:eventify/core/widgets/custom_progress_indicator.dart';
import 'package:eventify/core/widgets/divider_widget.dart';
import 'package:eventify/core/widgets/thumbnail_widget.dart';
import 'package:eventify/features/events/presentation/providers/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
                        error: (_,__){
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
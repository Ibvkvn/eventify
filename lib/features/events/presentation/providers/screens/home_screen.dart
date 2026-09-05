import 'package:eventify/core/widgets/custom_progress_indicator.dart';
import 'package:eventify/core/widgets/media_overlay.dart';
import 'package:eventify/features/events/presentation/providers/event_provider.dart';
import 'package:eventify/features/media/domain/entities/media_entity.dart';
import 'package:eventify/features/media/presentation/camera_tab_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {  
  @override
  Widget build(BuildContext context) {
    final feed = ref.watch(publicFeedProvider);

    return Scaffold(
      body: feed.when(
        data: (mediaList){
          if (mediaList.isEmpty){
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "no posts right now. be the first to post!",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(height: 6,),
                  FilledButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CameraTabScreen()));
                  }, 
                  child: Text("make a post")
                )
                ],
              )
            );
          }
          return PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: mediaList.length,
            itemBuilder: (context, index){
              return _MediaTile(media: mediaList[index]);
            }
          );
        }, 
        error: (err, stack) => Center(child: Text("something went wrong: $err"),), 
        loading: (){
          return Center(
            child: CustomProgressIndicator(),
          );
        }
      )
    );
  }
}

class _MediaTile extends StatelessWidget {
  final MediaEntity media;
  const _MediaTile({
    required this.media,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children:[ 
        Container(
          color: Colors.black,
          width: double.infinity,
          height: double.infinity,
          child: media.mediaType == MediaType.photo ?
          Image.network(
            media.mediaUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress){
              if (progress == null){
                return child;
              }
              return Center(child: CustomProgressIndicator(),);
            },
            errorBuilder:(context, error, stackTrace) {
              return  Center(
                child: PhosphorIcon(PhosphorIcons.imageBroken()),);
            },
          ) : 
          Center(
            child: PhosphorIcon(PhosphorIcons.videoCamera())
          ), 
        ),
        MediaOverlay(media: media)
      ]
    );
  }
}
import 'package:eventify/core/widgets/custom_progress_indicator.dart';
import 'package:eventify/core/widgets/divider_widget.dart';
import 'package:eventify/core/widgets/text_field_widget.dart';
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
    final profileAsync = ref.read(authControllerProvider.notifier);
    final TextEditingController displayNameController = TextEditingController();
    final TextEditingController bioController = TextEditingController();
    final TextEditingController tiktokUrlController = TextEditingController();
    final TextEditingController instagramUrlController = TextEditingController();

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
                              "${data!.displayName==null ?  data.id.substring(0,12) : data.displayName}",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text(
                              "@${data.userName}"
                            ),
                            ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context, 
                                  builder: (context) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadiusGeometry.circular(6)
                                    ),
                                    title: Text("edit your profile"),
                                    content: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                              onTap: (){
                                                profileAsync.updateUserProfile(
                                                  uid: "r", 
                                                  bio: bioController.text, 
                                                  displayName: displayNameController.text, 
                                                  tiktokUrl: tiktokUrlController.text, 
                                                  instagramUrl: instagramUrlController.text
                                                );
                                              },
                                              child: PhosphorIcon(PhosphorIcons.thumbsUp())
                                            ),
                                            GestureDetector(
                                              child: PhosphorIcon(PhosphorIcons.x())
                                            )
                                          ],
                                        ),
                                        Textfieldwidget(title: "display name", hintText: " ", textEditingController: displayNameController,),
                                        Textfieldwidget(title: "bio", hintText: " ", textEditingController: bioController,),
                                        Textfieldwidget(title: "tiktok username", hintText: " ", textEditingController: tiktokUrlController,),
                                        Textfieldwidget(title: "instagram username", hintText: " ", textEditingController: instagramUrlController,),
                                      ],
                                    ),
                                  )
                                );
                              },
                              child: Text("edit profile"),
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
                    SizedBox(height: 18,),
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
                            itemCount: data.length,
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
            error: (_, _){
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

class UpdateUserProfileTab {
  static OverlayEntry? overlayEntry;

  static void show(BuildContext buildContext, WidgetRef ref, {required String userId}){
    hide();

    final userAsync = ref.read(authControllerProvider.notifier);
    final overlay = Overlay.of(buildContext);
    final TextEditingController displayNameController = TextEditingController();
    final TextEditingController bioController = TextEditingController();
    final TextEditingController tiktokUrlController = TextEditingController();
    final TextEditingController instagramUrlController = TextEditingController();

    overlayEntry = OverlayEntry(
      builder: (buildContext) => Positioned(
        child: Material(
          color: Colors.transparent,
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      userAsync.updateUserProfile(
                        uid: userId, 
                        bio: bioController.text, 
                        displayName: displayNameController.text, 
                        tiktokUrl: tiktokUrlController.text, 
                        instagramUrl: instagramUrlController.text
                      );
                      hide();
                    },
                    child: PhosphorIcon(PhosphorIcons.thumbsUp())
                  ),
                  GestureDetector(
                    onTap: () => hide(),
                    child: PhosphorIcon(PhosphorIcons.x())
                  )
                ],
              ),
              Textfieldwidget(title: "display name", hintText: " ", textEditingController: displayNameController,),
              Textfieldwidget(title: "bio", hintText: " ", textEditingController: bioController,),
              Textfieldwidget(title: "tiktok username", hintText: " ", textEditingController: tiktokUrlController,),
              Textfieldwidget(title: "instagram username", hintText: " ", textEditingController: instagramUrlController,),
            ],
          ),
        )
      ),
    );

    overlay.insert(overlayEntry!);
  }

  static void hide(){
    overlayEntry!.remove();
    overlayEntry = null;
  }

}

class _UpdateUserProfileTab extends StatelessWidget {
  const _UpdateUserProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint("edit profile");
    return Container(
      height: 60,
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.black
      ),
      child: Column(
        children: [Text("edie prof")],
      ),
    );
    
  }
}



import 'package:eventify/features/media/presentation/selected_room_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CameraTabScreen extends StatelessWidget {
  const CameraTabScreen({super.key});

  Future<void> capturePhoto(BuildContext buildContext) async {
    final picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);

    if (photo == null || !buildContext.mounted) return;

    Navigator.push(
      buildContext, 
      MaterialPageRoute(
        builder: (buildContext) => SelectedRoomScreen(mediaFilePath: photo.path)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: PhosphorIcon(PhosphorIcons.arrowLeft())),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PhosphorIcon(PhosphorIcons.camera(), size: 64),
            const SizedBox(height: 16),
            Text('Capture a moment', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => capturePhoto(context),
              child: const Text('Take Photo'),
            ),
          ],
        ),
      ),
    );
  }
}
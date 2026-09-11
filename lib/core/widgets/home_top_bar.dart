import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HomeTopBar extends StatelessWidget {
  final VoidCallback onSearch;
  final VoidCallback createRoom;
  const HomeTopBar({
    super.key,
    required this.onSearch,
    required this.createRoom
  });

  @override
  Widget build(BuildContext context) {
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
                ),
              ),
            ),
            SizedBox(width: 6,),
            FilledButton(
              onPressed: (){}, 
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(9)
                ),
                backgroundColor: Theme.of(context).colorScheme.tertiaryFixed
              ),
              child: PhosphorIcon(PhosphorIcons.plus(),)
            )
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class Dividerwidget extends StatelessWidget {
  final String text;

  const Dividerwidget({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(thickness: 1, color: Theme.of(context).colorScheme.outline.withOpacity(0.3),)),
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 12), 
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)
            )
          ),
        ),
        Expanded(child: Divider(thickness: 1, color: Theme.of(context).colorScheme.outline.withOpacity(0.3)))
      ],
    );
  }
}
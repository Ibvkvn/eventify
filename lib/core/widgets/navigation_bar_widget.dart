import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class NavigationBarWidget extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;

  const NavigationBarWidget({
    super.key,
    required this.index,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      (icon: PhosphorIcons.house()),
      (icon: PhosphorIcons.camera()),
      (icon: PhosphorIcons.user())
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Container(
        width: double.infinity,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: Theme.of(context).colorScheme.tertiary.withOpacity(0.6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (i){
            final item = items[i];
            final isSelected = i == index;
      
            return GestureDetector(
              onTap: (){
                onTap(i);
              },
              child: PhosphorIcon(
                item.icon,
                color: isSelected? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.onSurface,
              ),
            );
          }),
        ),
      ),
    );
  }
}
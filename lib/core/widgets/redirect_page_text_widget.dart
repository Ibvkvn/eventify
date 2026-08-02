import 'package:flutter/material.dart';

class RedirectPageTextWidget extends StatelessWidget {
  final String message;
  final String redirectedPage;
  final VoidCallback? onTap;
  
  const RedirectPageTextWidget({
    super.key,
    required this.message,
    required this.redirectedPage,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            redirectedPage,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600
            ),
          ),
        )
      ],
    );
  }
}
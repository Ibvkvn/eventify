import 'package:flutter/material.dart';

class TermsCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> ?onChanged;

  const TermsCheckbox({
    super.key,
    required this.value,
    this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: Checkbox(
            value: value, 
            onChanged: onChanged,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(4)
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsetsGeometry.only(top: 2),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "By agreeing to the ",
                    style: Theme.of(context).textTheme.bodyMedium
                  ),
                  TextSpan(
                    text: "terms and conditions, you are ",
                    style: Theme.of(context).textTheme.bodyMedium
                  ), 
                  TextSpan(
                    text: "entering a legally binded agreement with the service provider.",
                    style: Theme.of(context).textTheme.bodyMedium
                  )
                ]
              ),
            ),
          ),
        ),
      ],
    );
  }
}
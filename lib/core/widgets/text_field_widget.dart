import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class Textfieldwidget extends StatefulWidget {
  final String title;
  final String hintText;
  final bool obscureText;
  final TextEditingController? textEditingController;
  final String? errorText;
  final ValueChanged<String>? onChanged;


  const Textfieldwidget({
    super.key,
    required this.title,
    required this.hintText,
    this.obscureText = false,
    this.textEditingController,
    this.errorText,
    this.onChanged
  });

  @override
  State<Textfieldwidget> createState() => _TextfieldwidgetState();
}

class _TextfieldwidgetState extends State<Textfieldwidget> {
  late bool _obscureText;

  @override
  void initState(){
    super.initState();
    _obscureText = widget.obscureText;
  }
  @override
  Widget build(BuildContext context) {
    

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        SizedBox(height: 6,),
        TextField(
          controller: widget.textEditingController,
          obscureText: _obscureText,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            hintText: widget.hintText, 
            hintStyle: Theme.of(context).textTheme.bodyMedium,
            errorText: widget.errorText,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 14
            ),
            suffixIcon: widget.obscureText? IconButton(
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              }, 
              icon: PhosphorIcon(_obscureText? PhosphorIcons.eyeSlash() : PhosphorIcons.eye())
            ) : null,
          ),
        ),
      ],
    );
  }
}
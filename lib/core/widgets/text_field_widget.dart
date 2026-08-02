import 'package:flutter/material.dart';

class Textfieldwidget extends StatefulWidget {
  final String title;
  final String hintText;
  final bool obscureText;
  final TextEditingController? textEditingController;


  const Textfieldwidget({
    super.key,
    required this.title,
    required this.hintText,
    this.obscureText = false,
    this.textEditingController
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
          decoration: InputDecoration(
            hintText: widget.hintText, 
            hintStyle: Theme.of(context).textTheme.bodyMedium,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 14
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            suffixIcon: widget.obscureText? IconButton(
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              }, 
              icon: Icon(_obscureText? Icons.visibility_off : Icons.visibility)
            ) : null,
          ),
        ),
      ],
    );
  }
}
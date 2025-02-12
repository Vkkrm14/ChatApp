import 'package:flutter/material.dart';
class MessageField extends StatelessWidget {
  TextEditingController textcontroller;
  final String text;
  bool obscuretext;
  final FocusNode? focusNode;
  void Function()? onTap;
  MessageField({super.key,required this.textcontroller,required this.text,required this.obscuretext,this.focusNode,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        focusNode: focusNode,
        obscureText: obscuretext,
        controller: textcontroller,
        decoration: InputDecoration(
            hintText: text,
            suffixIcon: IconButton(
              onPressed: onTap,
              icon: Icon(Icons.photo),
            ),
            hintStyle:TextStyle(color: Theme.of(context).colorScheme.primary) ,
            fillColor: Theme.of(context).colorScheme.tertiary,
            filled: true,
            enabledBorder: OutlineInputBorder(
                borderSide:
                BorderSide(color: Theme.of(context).colorScheme.tertiary)),
            focusedBorder: OutlineInputBorder(
                borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary))),
      ),
    );;
  }
}

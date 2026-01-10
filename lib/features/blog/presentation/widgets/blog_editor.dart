import 'package:flutter/material.dart';

class BlogEditor extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  const BlogEditor({
    super.key,
    required this.controller,
    required this.hintText,
  });


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      maxLines: null, //used to make new lines once each line is filled.
      validator: (value) { //to check if the fields are not empty.
        if(value!.isEmpty){
          return '$hintText is missing';
        }
        return null;
      },
    );
  }
}

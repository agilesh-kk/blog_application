import 'package:flutter/material.dart';

class AuthFields extends StatelessWidget {
  final String hintText; //gets the hint text has argument when the class is initialized
  final TextEditingController controller;
  final bool isObsucure;

  const AuthFields({
    super.key, 
    required this.hintText,
    required this.controller,
    this.isObsucure = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(hintText: hintText),
      validator: (value) {
        if (value!.isEmpty) {
          return "$hintText is missing"; 
        }
        return null;
      },
      
      obscureText: isObsucure,
    );
  }
}


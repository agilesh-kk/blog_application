import 'package:flutter/material.dart';

class YourProfilePage extends StatefulWidget {
  static const String pageName = '/your-profile-page';
  const YourProfilePage({super.key});

  @override
  State<YourProfilePage> createState() => _YourProfilePageState();
}

class _YourProfilePageState extends State<YourProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your profile"),
      ),
    );
  }
}
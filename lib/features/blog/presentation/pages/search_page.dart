import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  static const String pageName = '/search-page';
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
        centerTitle : true,
      ),
    );
  }
}
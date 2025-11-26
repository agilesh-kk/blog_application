import 'package:blog_app/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BlogPage extends StatelessWidget {
  static const String pageName = '/home';
  const BlogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blog App"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: (){
              context.goNamed(AddNewBlogPage.pageName);
            }, 
            icon: Icon(Icons.add_circle),
          )
        ],
      ),
    );
  }
}
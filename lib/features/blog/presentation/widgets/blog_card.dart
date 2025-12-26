import 'package:blog_app/core/utils/calculate_reading_time.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_viewer_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BlogCard extends StatelessWidget {
  final Blog blog;
  final Color color;
  final VoidCallback onBlogTap;
  const BlogCard({
    super.key, 
    required this.blog, 
    required this.color, 
    required this.onBlogTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //on tap function to decide whether go to allblogs or the blogs published by the user from the yourprofile tab.
      onTap: onBlogTap,
      child: Container(
        height: 200,
        margin: EdgeInsets.all(16).copyWith(
          bottom: 5,
        ),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    //the contents from the list are iterated and assigned to the chip text.
                    children:
                        blog.topics
                            .map(
                              (e) => Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Chip(
                                  label: Text(e),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ),
                Text(
                  blog.title, 
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text("${calculateReadingTime(blog.content)} min"),
          ],
        ),
      ),
    );
  }
}

import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:hive/hive.dart';

abstract interface class BlogLocalDataSource {
  // NOTE: Writing to storage is async, so we return Future<void>
  Future<void> uploadLocalBlogs({required List<BlogModel> blogs});
  
  // NOTE: Reading from an open Hive box is synchronous (instant)
  List<BlogModel> loadBlogs();
}

class BlogLocalDataSourceImpl implements BlogLocalDataSource {
  final Box box;
  BlogLocalDataSourceImpl(this.box);

  @override
  List<BlogModel> loadBlogs() {
    // 1. Check if box is empty to avoid errors
    if (box.isEmpty) {
      return [];
    }

    // 2. Use 'box.values' to get all data at once (no need for loops/indices)
    return box.values.map((blogData) {
      // 3. Hive stores data as 'dynamic', so we cast it to Map<String, dynamic>
      // to ensure it matches what BlogModel.fromJson expects.
      return BlogModel.fromJson(Map<String, dynamic>.from(blogData));
    }).toList();
  }

  @override
  Future<void> uploadLocalBlogs({required List<BlogModel> blogs}) async {
    // 1. Clear previous cache asynchronously
    await box.clear();

    // 2. Convert all models to JSON format
    // 'addAll' is much faster than looping through 'put'
    final blogsJson = blogs.map((blog) => blog.toJson()).toList();
    
    // 3. Write all to storage
    await box.addAll(blogsJson);
  }
}
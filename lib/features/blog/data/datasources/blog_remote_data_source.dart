import 'dart:io';

import 'package:blog_app/core/errors/exceptions.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDataSource {
  Future<BlogModel> uploadBlog(BlogModel blog);
  Future<String> uploadImage({
    required XFile image,
    required BlogModel blog,
  });
}

class BlogRemoteDataSourceImpl implements BlogRemoteDataSource{
  final SupabaseClient supabaseClient;

  BlogRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<BlogModel> uploadBlog(BlogModel blog) async {
    try{
      final blogData = await supabaseClient.from('blogs').insert(blog.toJson()).select();

      return BlogModel.fromJson(blogData.first);
    }
    catch(e){
      throw ServerExceptions(e.toString());
    }
  }
  
  @override
  Future<String> uploadImage({required XFile image, required BlogModel blog,}) async {
    try{
      // Supabase storage expects a dart:io `File` on non-web platforms.
      final File file = File(image.path);

      await supabaseClient.storage.from('blog_images').upload(blog.id, file);

      return supabaseClient.storage.from('blog_images').getPublicUrl(blog.id);
    }
    catch(e){
      throw ServerExceptions(e.toString());
    }
  }

}
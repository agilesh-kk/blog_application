import 'dart:io';

import 'package:blog_app/core/errors/exceptions.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:blog_app/features/blog/data/models/users_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDataSource {
  Future<BlogModel> uploadBlog(BlogModel blog);
  Future<String> uploadImage({required XFile image, required BlogModel blog});
  Future<List<BlogModel>> getAllBlogs();
  Future<List<BlogModel>> yourBlogs({required String posterId});
  Future<List<UsersModel>> getAllUsers();
}

class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final SupabaseClient supabaseClient;

  BlogRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<BlogModel> uploadBlog(BlogModel blog) async {
    try {
      // 1. Create a generic Map from the blog model
      // We use a Map<String, dynamic> so we can modify it
      final blogMap = blog.toJson();

      // 2. Remove the field that Supabase hates
      blogMap.remove('poster_name');

      // 3. Send the CLEANED map (blogMap) to Supabase
      final blogData = await supabaseClient
        .from('blogs')
        .insert(blogMap) // <--- Send the map, NOT blog.toJson()
        .select();

      return BlogModel.fromJson(blogData.first);
    }
    //catching postgres exceptions
    on PostgrestException catch(e){
      throw ServerExceptions(e.message);
    }
    catch (e) {
      throw ServerExceptions(e.toString());
    }
  }

  @override
  Future<String> uploadImage({
    required XFile image,
    required BlogModel blog,
  }) async {
    try {
      // Supabase storage expects a dart:io `File` on non-web platforms.
      final File file = File(image.path);

      await supabaseClient.storage.from('blog_images').upload(blog.id, file);

      return supabaseClient.storage.from('blog_images').getPublicUrl(blog.id);
    } 
    on StorageException catch(e){
      throw ServerExceptions(e.message);
    }
    catch (e) {
      throw ServerExceptions(e.toString());
    }
  }

  //to get all the blogs present in the database
  @override
  Future<List<BlogModel>> getAllBlogs() async {
    try {
      //since the posterId is the foreign key which refers to the profiles table
      final blogs = await supabaseClient.from('blogs').select('*, profiles(name)');

      return blogs
          .map(
            (blog) => BlogModel.fromJson(
              blog,
            ).copyWith(posterName: blog['profiles']['name']), //adding the posterName to the blog structure
          )
          .toList();
    }
    on PostgrestException catch(e){
      throw ServerExceptions(e.message);
    }
    catch (e) {
      throw ServerExceptions(e.toString());
    }
  }
  
  //fetches all the blogs related to the logged-in user
  @override
  Future<List<BlogModel>> yourBlogs({required String posterId}) async {
    try{
      final blogs = await supabaseClient.from('blogs').select('*, profiles(name)').eq('poster_id', posterId);

      return blogs
          .map(
            (blog) => BlogModel.fromJson(
              blog,
            ).copyWith(posterName: blog['profiles']['name']), //adding the posterName to the blog structure
          )
          .toList(); 
    }
    on PostgrestException catch(e){
      throw ServerExceptions(e.message);
    }
    catch (e) {
      throw ServerExceptions(e.toString());
    }
  }
  
  @override
  Future<List<UsersModel>> getAllUsers() async{
    try{
      final users = await supabaseClient.from('profiles').select('id, name');

      return users.map(
        (user) => UsersModel.fromMap(user), 
      ).toList();
    }
    on PostgrestException catch(e){
      throw ServerExceptions(e.message);
    }
    catch(e){
      throw ServerExceptions(e.toString());
    }
  }
}

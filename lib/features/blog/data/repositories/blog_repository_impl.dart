import 'package:blog_app/core/constants/constants.dart';
import 'package:blog_app/core/errors/exceptions.dart';
import 'package:blog_app/core/errors/failure.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/features/blog/data/datasources/blog_local_data_source.dart';
import 'package:blog_app/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

//implementation of blogRepository from the domain layer.
class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;
  final ConnectionChecker connectionChecker;
  final BlogLocalDataSource blogLocalDataSource;

  BlogRepositoryImpl(
    this.blogRemoteDataSource,
    this.connectionChecker,
    this.blogLocalDataSource,
  );

  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required XFile image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async {
    try {

      //checking the internet connection
      if(!await(connectionChecker.isConnected)){
        return left(Failure(Constants.noConnectionErrorMessage));
      }

      BlogModel blogModel = BlogModel(
        id: const Uuid().v1(),
        posterId: posterId,
        title: title,
        content: content,
        imageUrl: '', //will be updated later on
        topics: topics,
        updatedAt: DateTime.now(),
      );

      //uploads the image to supabase and gives the imageUrl
      final imageUrl = await blogRemoteDataSource.uploadImage(
        image: image,
        blog: blogModel,
      );

      //this updates the imageUrl
      blogModel = blogModel.copyWith(imageUrl: imageUrl);

      //uploading the blog to the database
      final uploadedBlog = await blogRemoteDataSource.uploadBlog(blogModel);
      return right(uploadedBlog); //returning the blog
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs() async {
    try {

      //checking the internet connection
      if(!await(connectionChecker.isConnected)){
        final blogs = blogLocalDataSource.loadBlogs();
        //print(blogs);
        return right(blogs);
      }
      final blogs = await blogRemoteDataSource.getAllBlogs(); //fetches the blogs from the supabase
      blogLocalDataSource.uploadlocalBlogs(blogs: blogs); //loads the blogs to local storage
      //print(blogs);
      return right(blogs);
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    }
  }
}

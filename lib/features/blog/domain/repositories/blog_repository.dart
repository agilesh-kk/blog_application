import 'package:blog_app/core/errors/failure.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/entities/users.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';

//interface for the repository of uploading and fetching the blogs
abstract interface class BlogRepository {
  Future<Either<Failure, Blog>> uploadBlog({
    required XFile image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  });

  Future<Either<Failure, List<Blog>>> getAllBlogs();

  Future<Either<Failure, List<Blog>>> yourBlogs({required String posterId});

  Future<Either<Failure, List<Users>>> listOfUsers();
}
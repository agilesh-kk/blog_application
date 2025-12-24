import 'package:blog_app/core/errors/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';


class YourBlogs implements UseCase<List<Blog>, YourBlogsParms>{
  final BlogRepository blogRepository;

  YourBlogs(this.blogRepository);
  @override
  Future<Either<Failure, List<Blog>>> call(YourBlogsParms params) async{
    return await blogRepository.yourBlogs(posterId: params.posterId);
  }

}

class YourBlogsParms{
  final String posterId;
  YourBlogsParms({required this.posterId});
}
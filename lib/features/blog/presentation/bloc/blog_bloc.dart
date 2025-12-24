import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:blog_app/features/blog/domain/usecases/your_blogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;
  final YourBlogs _yourBlogs;

  BlogBloc({required UploadBlog uploadBlog, required GetAllBlogs getAllBlogs, required YourBlogs yourBlogs})
    : _uploadBlog = uploadBlog,
      _getAllBlogs = getAllBlogs,
      _yourBlogs = yourBlogs,
      super(BlogInitial()) {
    //initially loading screen is shown
    on<BlogEvent>((event, emit) => emit(BlogLoading()));

    on<UploadBlogEvent>(_onUploadBlogEvent);
    on<GetAllBlogsEvent>(_onGetAllBlogsEvent);
    on<YourBlogsEvent>(_onyourBlogsEvent);
  }

  void _onUploadBlogEvent(
    UploadBlogEvent event,
    Emitter<BlogState> emit,
  ) async {
    //uploadBlog from the usecase
    final res = await _uploadBlog(
      UploadBlogParams(
        posterId: event.posterId,
        title: event.title,
        content: event.content,
        image: event.image,
        topics: event.topics,
      ),
    );

    res.fold((l) => emit(BlogFailure(l.message)), (r) => emit(BlogUploadSuccess()));

    final res2 = await _getAllBlogs(NoParams());
    res2.fold((l) => emit(BlogFailure(l.message)), (blogs) => emit(BlogsDisplaySuccess(blogs)));
  }

  void _onGetAllBlogsEvent(GetAllBlogsEvent event, Emitter<BlogState> emit) async {
    final res = await _getAllBlogs(NoParams());

    return res.fold(
      (l) => emit(BlogFailure(l.message)), 
      (r) => emit(BlogsDisplaySuccess(r)),
    );
  }

  void _onyourBlogsEvent(YourBlogsEvent event, Emitter<BlogState> emit) async{
    final res = await _yourBlogs(
      YourBlogsParms(
        posterId: event.posterId
      )
    );
    return res.fold(
      (l)=>emit(BlogFailure(l.message)),
      (r)=>emit(BlogsDisplaySuccess(r)),
    );
  }
}

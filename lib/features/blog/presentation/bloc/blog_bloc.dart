import 'package:blog_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog uploadBlog;

  BlogBloc(this.uploadBlog) : super(BlogInitial()) {
    //initially loading screen is shown
    on<BlogEvent>((event, emit) => emit(BlogLoading()));

    on<UploadBlogEvent>(_onUploadBlogEvent);
  }

  void _onUploadBlogEvent(
    UploadBlogEvent event,
    Emitter<BlogState> emit,
  ) async {
    //uploadBlog from the usecase
    final res = await uploadBlog(
      UploadBlogParams(
        posterId: event.posterId,
        title: event.title,
        content: event.content,
        image: event.image,
        topics: event.topics,
      ),
    );

    res.fold(
      (l)=> emit(BlogFailure(l.message)), 
      (r)=> emit(BlogSuccess()),
    );
  }
}

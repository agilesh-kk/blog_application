import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/pages/signin_page.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/poster_blog_viewer_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PosterPage extends StatelessWidget {
  static const String pageName = '/poster-page';
  final String? name;
  final String id;
  const PosterPage({super.key, required this.name, required this.id});

  @override
  Widget build(BuildContext context) {
    final posterName = name ?? 'Unknown';
    return Scaffold(
      appBar: AppBar(
        title: Text(posterName),
        centerTitle : true,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if(state is AuthInitial){
            context.goNamed(SigninPage.pageName);
          }
        },
        child: BlocConsumer<BlogBloc, BlogState>(
          listener: (context, state) {
            if (state is BlogFailure) {
              return showSnackbar(context, state.error);
            }
          },
          builder: (context, state) {
            if (state is BlogLoading) {
              return const Loader();
            }
            if (state is BlogsDisplaySuccess) {
              final userBlogs = state.blogs
                  .where((blog) => blog.posterId == id)
                  .toList();
              return Scrollbar(
                child: ListView.builder(
                  itemCount: userBlogs.length,
                  itemBuilder: (context, index) {
                    final blog = userBlogs[index];
                    return BlogCard(
                      onBlogTap: () {
                        context.pushNamed(PosterBlogViewerPage.pageName, extra: blog);
                      },
                      blog: blog,
                      color:
                          //changing the color according to the index of the cards
                          index % 2 == 0
                              ? AppPallete.gradient1
                              : AppPallete.gradient2,
                    );
                  },
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
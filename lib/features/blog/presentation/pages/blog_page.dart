import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_viewer_page.dart';
import 'package:blog_app/features/blog/presentation/pages/your_profile_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BlogPage extends StatefulWidget {
  static const String pageName = '/home';
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  //this runs after the app starts
  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(GetAllBlogsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blog App"),
        centerTitle: true,
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
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
            return RefreshIndicator( //refresh indicator 
              onRefresh: () async {
                context.read<BlogBloc>().add(GetAllBlogsEvent());
              },
              child: Scrollbar(
                child: ListView.builder(
                  itemCount: state.blogs.length,
                  itemBuilder: (context, index) {
                    final blog = state.blogs[index];
                    return BlogCard(
                      onBlogTap: (){
                        context.goNamed(BlogViewerPage.pageName, extra: blog);
                      },
                      blog: blog,
                      color:
                        //changing the color according to the index of the cards
                          index % 2 == 0
                              ? AppPallete.gradient1
                              : AppPallete.gradient2
                    );
                  },
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

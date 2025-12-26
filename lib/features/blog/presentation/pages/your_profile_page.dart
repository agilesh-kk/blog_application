import 'package:blog_app/core/common/cubits/app%20user/app_user_cubit.dart';
import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class YourProfilePage extends StatefulWidget {
  static const String pageName = '/your-profile-page';
  const YourProfilePage({super.key});

  @override
  State<YourProfilePage> createState() => _YourProfilePageState();
}

class _YourProfilePageState extends State<YourProfilePage> {
  
  //when the page is rendered it fetches the blogs posted by the user.
  @override
  void initState() {
    super.initState();
    final userId = (context.read<AppUserCubit>().state as AppUserIsSignedin).user.id;
    context.read<BlogBloc>().add(YourBlogsEvent(posterId: userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //to display the name of the user
        title: Text((context.read<AppUserCubit>().state as AppUserIsSignedin).user.name,
          //style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
            return Scrollbar(
              child: ListView.builder(
                itemCount: state.blogs.length,
                itemBuilder: (context, index) {
                  final blog = state.blogs[index];
                  return BlogCard(
                    onBlogTap: (){
                      context.goNamed('blog-viewer-profile', extra: blog);
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
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
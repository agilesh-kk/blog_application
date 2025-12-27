import 'package:blog_app/core/common/cubits/app%20user/app_user_cubit.dart';
import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/show_confirmation_dialog.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/pages/signin_page.dart';
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
    final state = context.read<AppUserCubit>().state;
    if (state is AppUserIsSignedin) {
      //context.read<BlogBloc>().add(YourBlogsEvent(posterId: state.user.id));
      //context.read<BlogBloc>().add(GetAllBlogsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final appUserState = context.watch<AppUserCubit>().state;

    // If the user is NOT signed in (which happens instantly when you click logout),
    // we return a Loader immediately. 
    // This stops the code below from trying to read 'user.name' on a null user.
    if (appUserState is! AppUserIsSignedin) {
      return const Scaffold(
        body: Loader(),
      );
    }

    final currentUser = appUserState.user;
    return Scaffold(
      appBar: AppBar(
        //to display the name of the user
        title: Text(appUserState.user.name),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert), // The three dots icon
            onSelected: (value) async {
              if (value == 'logout') {
                // Trigger the logout event in your Bloc
                final shouldLogout = await showConfirmationDialog(context, 'Log out?', Icons.warning_amber_outlined);
                if(shouldLogout == true && context.mounted){
                  context.read<AuthBloc>().add(AuthUserSignOut());
                }
                //context.read<AuthBloc>().add(AuthUserSignOut());
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app, color: AppPallete.gradient3),
                      SizedBox(width: 8),
                      Text('Logout'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
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
                  .where((blog) => blog.posterId == currentUser.id)
                  .toList();
              return Scrollbar(
                child: ListView.builder(
                  itemCount: userBlogs.length,
                  itemBuilder: (context, index) {
                    final blog = userBlogs[index];
                    return BlogCard(
                      onBlogTap: () {
                        context.goNamed('blog-viewer-profile', extra: blog);
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

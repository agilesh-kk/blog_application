import 'package:blog_app/core/common/cubits/app%20user/app_user_cubit.dart';
import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/core/common/widgets/bottom_navigation_shell.dart';

import 'package:blog_app/core/theme/app_theme.dart';
import 'package:blog_app/core/utils/go_router_refresh_stream.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/pages/signin_page.dart';
import 'package:blog_app/features/auth/presentation/pages/signup_page.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/entities/users.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:blog_app/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_viewer_page.dart';
import 'package:blog_app/features/blog/presentation/pages/poster_blog_viewer_page.dart';
import 'package:blog_app/features/blog/presentation/pages/poster_page.dart';
import 'package:blog_app/features/blog/presentation/pages/search_page.dart';
import 'package:blog_app/features/blog/presentation/pages/your_blogs_viewer_page.dart';
import 'package:blog_app/features/blog/presentation/pages/your_profile_page.dart';
import 'package:blog_app/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies(); //this function is used for initializing the database instance from the dependency file
  runApp(
    MultiBlocProvider(
      providers: [
        //app user signed in cubit
        BlocProvider(
          create: (_) => serviceLocator<AppUserCubit>(), //loads the app_user_cubit contents from the dependency file
        ),
        //bloc
        BlocProvider(
          create: (_) => serviceLocator<AuthBloc>(), //loads the Authbloc contents from the dependency file
        ),
        BlocProvider(
          create: (_) => serviceLocator<BlogBloc>(), //loads the Blogbloc contents from the dependency file
        ),
      ],
      child: MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final GoRouterRefreshStream _refreshStream; //declaring the refreshstream object
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthUserIsSignedIn());
    //This tells GoRouter: "Whenever AppUserCubit changes, check the redirects!"
    _refreshStream = GoRouterRefreshStream(context.read<AppUserCubit>().stream);
  }

  @override
  void dispose() {
    // 3. Dispose the listener to prevent memory leaks
    _refreshStream.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Blog app',
      routerConfig: _router, //routing setup
      theme: AppTheme.darkThemeMode,
      //home: const LoginPage(),
    );
  }

  late final _router = GoRouter(
    initialLocation: '/',
    refreshListenable: _refreshStream, //added the refreshStream to the router
    redirect: (context, state) {
      final isSignedIn = context.read<AppUserCubit>().state is AppUserIsSignedin;
      
      // If user is logged in and tries to access auth pages, redirect to home
      if (isSignedIn && 
          (state.matchedLocation == SigninPage.pageName || 
           state.matchedLocation == '/${SignupPage.pageName}')) {
        return BlogPage.pageName;
      }

      // If user is not logged in and tries to access protected pages
      if (!isSignedIn && !state.matchedLocation.startsWith(SigninPage.pageName)) {
        return SigninPage.pageName;
      }

      return null; // no redirect needed
    },
    routes: [
      // GoRoute(
      //   path: BlogPage.pageName,
      //   builder: (context, state) => BlocSelector<AppUserCubit, AppUserState, bool>(
      //     selector: (state) => state is AppUserIsSignedin,
      //     builder: (context, isLoggedIn) {
      //       // If not logged in, redirect to sign in page
      //       if (!isLoggedIn) return const SigninPage();
      //       // Replace this with your home page
      //       return BlogPage();
      //     },
      //   ),
      // ),
      GoRoute(
        name: SigninPage.pageName,
        path: SigninPage.pageName,
        builder: (context, state) => const SigninPage(),
        routes: [
          GoRoute(
            name: SignupPage.pageName,
            path: SignupPage.pageName,
            builder: (context, state) => const SignupPage(),
          ),
        ],
      ),

      //Shell routing for navigation bar.
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return BottomNavigationShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              // Named route for blog home page
              GoRoute(
                name: BlogPage.pageName,
                path: BlogPage.pageName,
                builder: (context, state) => const BlogPage(),
                routes: [
                  GoRoute(
                    name: BlogViewerPage.pageName,
                    path: BlogViewerPage.pageName,
                    builder: (context, state) {
                      //adding the blog while routing
                      final blog = state.extra as Blog;
                      return BlogViewerPage(blog: blog);
                    },
                  ),
                  GoRoute(
                    name: PosterPage.pageName,
                    path: PosterPage.pageName,
                    builder: (context, state)  {
                      final args = state.extra as Users;
                      //final id = state.extra as User;
                      return PosterPage(name: args.name, id: args.id);
                    },
                  ),
                    
                      GoRoute(
                        name: PosterBlogViewerPage.pageName,
                        path: PosterBlogViewerPage.pageName,
                        builder: (context, state) {
                          //adding the blog while routing
                          final blog = state.extra as Blog;
                          return PosterBlogViewerPage(blog: blog);
                        }, 
                      ),
                    
                  
                  GoRoute(
                    name: '/your-profile',
                    path: '/your-profile',
                    builder: (context, state) => const YourProfilePage(),
                  ),
                ],
              ),
            ]
          ),

          //branch for add-new-blog-page
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: AddNewBlogPage.pageName,
                path: AddNewBlogPage.pageName,
                builder: (context, state) => const AddNewBlogPage(),
              ),
            ],
          ),

          //brach for serach page
          // StatefulShellBranch(
          //   routes: [
          //     GoRoute(
          //       name: SearchPage.pageName,
          //       path: SearchPage.pageName,
          //       builder: (context, state) => const SearchPage(),
          //     )
          //   ],
          // ),

          //branch for your profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: YourProfilePage.pageName,
                path: YourProfilePage.pageName,
                builder: (context, state) => const YourProfilePage(),
                routes: [
                  GoRoute(
                    name: YourBlogsViewerPage.pageName, //gave a separate page for yourblogs page.
                    path: YourBlogsViewerPage.pageName,
                    builder: (context, state) {
                      //adding the blog while routing
                      final blog = state.extra as Blog;
                      return YourBlogsViewerPage(blog: blog);
                    },
                  )
                ]
              ),
            ],
          ),
        ]
      ),   
    ],
  );
}

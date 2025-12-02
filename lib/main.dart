import 'package:blog_app/core/common/cubits/app%20user/app_user_cubit.dart';

import 'package:blog_app/core/theme/app_theme.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/pages/signin_page.dart';
import 'package:blog_app/features/auth/presentation/pages/signup_page.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:blog_app/features/blog/presentation/pages/add_new_blog_page.dart';
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

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthUserIsSignedIn());
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

  final _router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isSignedIn = context.read<AppUserCubit>().state is AppUserIsSignedin;
      
      // If user is logged in and tries to access auth pages, redirect to home
      if (isSignedIn && 
          (state.matchedLocation == SigninPage.pageName || 
           state.matchedLocation == '/${SignupPage.pageName}')) {
        return '/';
      }

      // If user is not logged in and tries to access protected pages
      if (!isSignedIn && !state.matchedLocation.startsWith(SigninPage.pageName)) {
        return SigninPage.pageName;
      }

      return null; // no redirect needed
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => BlocSelector<AppUserCubit, AppUserState, bool>(
          selector: (state) => state is AppUserIsSignedin,
          builder: (context, isLoggedIn) {
            // If not logged in, redirect to sign in page
            if (!isLoggedIn) return const SigninPage();
            // Replace this with your home page
            return BlogPage();
          },
        ),
      ),
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
      // Named route for blog home page
      GoRoute(
        name: BlogPage.pageName,
        path: BlogPage.pageName,
        builder: (context, state) => const BlogPage(),
        routes: [
          GoRoute(
            name: AddNewBlogPage.pageName,
            path: AddNewBlogPage.pageName,
            builder: (context, state) => const AddNewBlogPage(),
          ),
        ],
      ),      
    ],
  );
}

import 'package:blog_app/core/common/cubits/app%20user/app_user_cubit.dart';
import 'package:blog_app/core/secrets/app_secrets.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_sources.dart';
import 'package:blog_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_app/features/auth/domain/usecases/current_user.dart';
import 'package:blog_app/features/auth/domain/usecases/user_signin.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:blog_app/features/blog/data/repositories/blog_repository_impl.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:blog_app/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

//database initialization
Future<void> initDependencies() async {
  _initAuth(); //Authentication
  _initBlog(); //Blogs
  final supabase = await Supabase.initialize(
    //initializes supabase connection
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );
  serviceLocator.registerLazySingleton(
    () => supabase.client,
  ); //registers the supabase instance

  //registering core dependencies
  serviceLocator.registerLazySingleton(() => AppUserCubit());
}

void _initAuth() {
  //registering all the implementations for authentication feature
  //database
  serviceLocator
    ..registerFactory<AuthRemoteDataSources>(
      () => AuthRemoteDataSourcesImpl(
        supabaseClient: serviceLocator<SupabaseClient>(),
      ),
    )
    //repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(serviceLocator()),
    )
    //usecases
    ..registerFactory(() => UserSignUp(serviceLocator()))
    ..registerFactory(() => UserSignin(serviceLocator()))
    ..registerFactory(() => CurrentUser(serviceLocator()))
    //Bloc
    ..registerLazySingleton(
      //registers only one time, this helps to maintain the state and avoiding unnecessary initializations
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userSignin: serviceLocator(),
        currentuser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}

void _initBlog() {
  serviceLocator
    //database
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(serviceLocator()),
    )
    //repository
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(serviceLocator()),
    )
    //usecase
    ..registerFactory(() => UploadBlog(serviceLocator()))
    ..registerFactory(() => GetAllBlogs(serviceLocator()))
    //bloc
    ..registerLazySingleton(
      () =>
          BlogBloc(
            uploadBlog: serviceLocator(), 
            getAllBlogs: serviceLocator(),
          ),
    );
}

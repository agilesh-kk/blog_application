part of 'init_dependencies.dart';

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

  //initialising Hive storage
  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

  serviceLocator.registerLazySingleton(
    () => supabase.client,
  ); //registers the supabase instance

  //declaring the local storage with the name
  serviceLocator.registerLazySingleton(()=> Hive.box(name: 'blogs')); 

  serviceLocator.registerFactory(
    () => InternetConnection(),
  ); //internet connection checking

  //registering core dependencies
  serviceLocator.registerLazySingleton(() => AppUserCubit());
  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(serviceLocator()),
  );
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
      () => AuthRepositoryImpl(
        serviceLocator(),//this is for the repository 
        serviceLocator(),//this is for the internet connection checking
      ),
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
    //remote database
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(serviceLocator()),
    )
    //local storage
    ..registerFactory<BlogLocalDataSource>(()=>BlogLocalDataSourceImpl(serviceLocator(),),)
    //repository
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
        serviceLocator()
      ),
    )
    //usecase
    ..registerFactory(() => UploadBlog(serviceLocator()))
    ..registerFactory(() => GetAllBlogs(serviceLocator()))
    //bloc
    ..registerLazySingleton(
      () =>
          BlogBloc(uploadBlog: serviceLocator(), getAllBlogs: serviceLocator()),
    );
}

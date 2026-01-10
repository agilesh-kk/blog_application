part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );

  serviceLocator.registerLazySingleton(() => supabase.client);

  // --- HIVE CONFIGURATION (Fixed for Hive v2) ---
  
  // 1. Initialize Hive for Flutter (Replaces getApplicationDocumentsDirectory)
  await Hive.initFlutter();


  // 2. Open the Box explicitly BEFORE registering it
  // This is async, so we must await it here.
  final blogsBox = await Hive.openBox('blogs');

  // 3. Register the already opened box instance
  serviceLocator.registerLazySingleton(() => blogsBox);

  // ---------------------------------------------

  serviceLocator.registerFactory(
    () => InternetConnection(),
  );

  // Core Dependencies
  serviceLocator.registerLazySingleton(() => AppUserCubit());
  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(serviceLocator()),
  );
}

void _initAuth() {
  serviceLocator
    ..registerFactory<AuthRemoteDataSources>(
      () => AuthRemoteDataSourcesImpl(
        supabaseClient: serviceLocator<SupabaseClient>(),
      ),
    )
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
      ),
    )
    ..registerFactory(() => UserSignUp(serviceLocator()))
    ..registerFactory(() => UserSignin(serviceLocator()))
    ..registerFactory(() => CurrentUser(serviceLocator()))
    ..registerFactory(() => UserSignout(serviceLocator()))
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userSignin: serviceLocator(),
        currentuser: serviceLocator(),
        appUserCubit: serviceLocator(),
        userSignout: serviceLocator(),
      ),
    );
}

void _initBlog() {
  serviceLocator
    // Remote Database
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(serviceLocator()),
    )
    // Local Storage
    // usage: serviceLocator() automatically finds the registered 'Box'
    ..registerFactory<BlogLocalDataSource>(
      () => BlogLocalDataSourceImpl(serviceLocator()),
    )
    // Repository
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    )
    // Use Cases
    ..registerFactory(() => UploadBlog(serviceLocator()))
    ..registerFactory(() => GetAllBlogs(serviceLocator()))
    ..registerFactory(() => YourBlogs(serviceLocator()))
    // Bloc
    ..registerLazySingleton(
      () => BlogBloc(
        uploadBlog: serviceLocator(),
        getAllBlogs: serviceLocator(),
        yourBlogs: serviceLocator(),
      ),
    );
}
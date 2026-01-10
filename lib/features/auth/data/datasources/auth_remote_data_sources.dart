import 'package:blog_app/core/errors/exceptions.dart';
import 'package:blog_app/features/auth/data/model/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

//this file connects to the supabase, being a remote data source

abstract interface class AuthRemoteDataSources {
  Session? get curretnUserSession;
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> signinWithEmailPassword({
    required String email,
    required String password,
  });

  Future<UserModel?> getCurrentUserData();

  Future<void> signout();
}

//authentication implementations
class AuthRemoteDataSourcesImpl implements AuthRemoteDataSources {
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourcesImpl({required this.supabaseClient});

  @override
  Session? get curretnUserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel> signinWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        password: password,
        email: email,
      );
      if (response.user == null) {
        throw const ServerExceptions('User is null');
      }
      return UserModel.fromJson(response.user!.toJson()).copyWith();
    }
    on AuthException catch(e){
      throw ServerExceptions(e.message);
    }
     catch (e) {
      throw ServerExceptions(e.toString());
    }
  }


  @override
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {
          'name': name, //the key 'name' has the value String name
        },
      );
      if (response.user == null) {
        throw const ServerExceptions('User is null');
      }
      return UserModel.fromJson(response.user!.toJson()).copyWith();
    }
    on AuthException catch(e){
      throw ServerExceptions(e.message);
    }
    catch (e) {
      throw ServerExceptions(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if(curretnUserSession!=null){
        final userData = await supabaseClient
          .from('profiles')
          .select()
          .eq(
            'id', 
            curretnUserSession!.user.id
          );
          return UserModel.fromJson(userData.first).copyWith(
            email: curretnUserSession!.user.email,
          );
      }
      else{
        return null;
      }
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }

  //signout feature.
  @override
  Future<void> signout() async{
    try{
      await supabaseClient.auth.signOut();
    }
    on AuthException catch(e){
      throw ServerExceptions(e.message);
    }
    catch(e){
      throw ServerExceptions(e.toString());
    }
  }
}

//db pass=a5sqn9gti1@


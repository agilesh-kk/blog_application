import 'package:blog_app/core/constants/constants.dart';
import 'package:blog_app/core/errors/exceptions.dart';
import 'package:blog_app/core/errors/failure.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_sources.dart';
import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/features/auth/data/model/user_model.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
//import 'package:supabase_flutter/supabase_flutter.dart' as sb;
//import 'package:fpdart/src/either.dart';

//implementations of the interfaces created in domain layer
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSources remoteDataSources;
  final ConnectionChecker connectionChecker;
  const AuthRepositoryImpl(this.remoteDataSources, this.connectionChecker);

  @override
  Future<Either<Failure, User>> currentUser() async {
    try{
      //no internet part
      if(!await(connectionChecker.isConnected)){
        //intialising the session variablle with the currentUserSession
        final session = remoteDataSources.curretnUserSession;

        //if the user not logged in
        if(session == null){
          return left(Failure('User not logged in!'));  
        }
        
        //if the user was logged in when the internet was present
        return right(
          UserModel(
            id: session.user.id,
            name: '',
            email: session.user.email ?? '',
          )
        );
      }
      
      final user = await remoteDataSources.getCurrentUserData();
      if(user==null){
        return left(Failure('User not logged in!'));
      }

      return right(user);
    }
    on ServerExceptions catch(e){
      return left(Failure(e.message));
    }
  }
                             
  @override                 
  Future<Either<Failure, User>> signinWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return _getuser(() async => await remoteDataSources.signinWithEmailPassword(
        email: email,
        password: password,
      ),
    );
  }


  @override
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    return _getuser(() async => await remoteDataSources.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  //created a function for try and catch, since it is repeatedly used in the codes, also making it easier to add any othre exceptions and other validations.
  Future<Either<Failure, User>> _getuser(Future<User> Function()fn) async {
    try{
      if(!await(connectionChecker.isConnected)){
        return left(Failure(Constants.noConnectionErrorMessage));
      }

      final user = await fn();
      return right(user); //right function gives success message, the argument passed inside the right() is received as success
    }
    
    on ServerExceptions catch (e){
      return left(Failure(e.message)); //returns a Failure class message
    }
  }
  
  @override
  Future<Either<Failure, void>> signOut() async {
    try{
      await remoteDataSources.signout();
      return right(null);
    }
    on ServerExceptions catch (e){
      return left(Failure(e.message)); //returns a Failure class message
    }
    catch (e) {
      return left(Failure(e.toString()));
    }
  }
}


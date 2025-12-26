import 'package:blog_app/core/errors/failure.dart';
import 'package:blog_app/core/common/entities/user.dart';
import 'package:fpdart/fpdart.dart';

//creating the interface for the repository (it is independent)

abstract interface class AuthRepository {
  Future <Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future <Either<Failure, User>> signinWithEmailPassword({
    required String email,
    required String password,
  });

  Future <Either<Failure, User>> currentUser();

  Future<Either<Failure, void>> signOut();
}



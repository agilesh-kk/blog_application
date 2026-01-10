import 'package:blog_app/core/errors/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserSignin implements UseCase<User, UserLoginParams> {
  final AuthRepository authRepository;
  const UserSignin(this.authRepository);
  @override
  Future<Either<Failure, User>> call(UserLoginParams params) {
    return authRepository.signinWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}


class UserLoginParams {
  final String email;
  final String password;

  UserLoginParams({required this.email, required this.password});
}


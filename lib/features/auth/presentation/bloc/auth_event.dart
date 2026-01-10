part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthSignUp extends AuthEvent {
  final String name;
  final String email;
  final String password;

  AuthSignUp({
    required this.name,
    required this.email,
    required this.password,
  });
}

final class AuthSignin extends AuthEvent{
  final String email;
  final String password;

  AuthSignin({
    required this.email, 
    required this.password,
  });
}

final class AuthUserIsSignedIn extends AuthEvent {}

final class AuthUserSignOut extends AuthEvent{}

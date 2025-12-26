// import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart';
import 'package:blog_app/core/common/cubits/app%20user/app_user_cubit.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/features/auth/domain/usecases/current_user.dart';
import 'package:blog_app/features/auth/domain/usecases/user_signin.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:blog_app/features/auth/domain/usecases/user_signout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserSignin _userLogin;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;
  final UserSignout _usersignout;
  AuthBloc({
    required UserSignUp userSignUp,
    required UserSignin userSignin,
    required CurrentUser currentuser,
    required AppUserCubit appUserCubit,
    required UserSignout userSignout,
  }) : _userSignUp = userSignUp,
       _userLogin = userSignin,
       _currentUser = currentuser,
       _appUserCubit = appUserCubit,
       _usersignout = userSignout,
       super(AuthInitial()) {
    on<AuthEvent>((_, emit)=> emit(AuthLoading()));
    on<AuthSignUp>(_onAuthSignUp); // created individual functions for catching the events
    on<AuthSignin>(_onAuthSignin);
    on<AuthUserIsSignedIn>(_isUserSignedIn);
    on<AuthUserSignOut>(_onAuthSignOut);
  }

  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    //emit(AuthLoading());
    final res = await _userSignUp(
      UserSignUpParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _onAuthSignin(AuthSignin event, Emitter<AuthState> emit) async {
    //emit(AuthLoading());
    final res = await _userLogin(
      UserLoginParams(email: event.email, password: event.password),
    );

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  //for getting the current user data
  void _isUserSignedIn(AuthUserIsSignedIn event, Emitter<AuthState> emit) async {
    final res = await _currentUser(NoParams());

    return res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => _emitAuthSuccess(r, emit),
    );
  }

  //handles the signout feature.
  void _onAuthSignOut(AuthUserSignOut event, Emitter<AuthState> emit) async {
    final res = await _usersignout(NoParams());
    
    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (_) { // Use '_' because the success value is void/null
         _appUserCubit.updateUser(null); // Ensure AppUserCubit handles null
         emit(AuthInitial()); // Reset state to Initial
      },
    );
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emit){
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }
}


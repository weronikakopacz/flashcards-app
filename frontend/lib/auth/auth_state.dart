part of 'auth_bloc.dart';

class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthStateLoading extends AuthState {}

class AuthError extends AuthState {
  final String errorMessage;

  const AuthError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

class AuthLoggedIn extends AuthState {
  final String accessToken;

  const AuthLoggedIn({required this.accessToken});

  @override
  List<Object?> get props => [accessToken];
}

class AuthRegistered extends AuthState {}
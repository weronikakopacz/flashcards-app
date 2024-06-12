import 'package:bloc/bloc.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:equatable/equatable.dart';

part 'auth_state.dart';
part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc(this.authService) : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(AuthStateLoading());
      final error = await authService.loginUser(event.email, event.password);
      if (error == null) {
        final accessToken = authService.getAccessToken();
        if (accessToken != null) {
          emit(AuthLoggedIn(accessToken: accessToken));
        } else {
          emit(const AuthError(errorMessage: 'Failed to retrieve access token'));
        }
      } else {
        emit(AuthError(errorMessage: error));
      }
    });

    on<RegisterEvent>((event, emit) async {
      emit(AuthStateLoading());
      final error = await authService.registerUser(event.email, event.password);
      if (error == null) {
        emit(AuthRegistered());
      } else {
        emit(AuthError(errorMessage: error));
      }
    });

    on<RegisteredEvent>((event, emit) {
      emit(AuthRegistered());
    });
  }
}
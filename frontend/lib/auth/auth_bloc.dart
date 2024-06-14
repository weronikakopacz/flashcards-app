import 'package:bloc/bloc.dart';
import 'package:frontend/auth/shared_preferences.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_state.dart';
part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;
  final SharedPreferences prefs;

  AuthBloc(this.authService, {required this.prefs}) : super(AuthInitial()) {
    on<LoginEvent>(_handleLoginEvent);
    on<RegisterEvent>(_handleRegisterEvent);
    on<LogoutEvent>(_handleLogoutEvent);
    on<RegisteredEvent>(_handleRegisteredEvent);
    on<CheckLoginEvent>(_handleCheckLoginEvent);
  }

  void _handleLoginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthStateLoading());
    final error = await authService.loginUser(event.email, event.password);
    if (error == null) {
      final accessToken = authService.getAccessToken();
      if (accessToken != null) {
        await saveAccessToken(accessToken);
        await saveLoginState(true);
        emit(AuthLoggedIn(accessToken: accessToken));
      } else {
        emit(const AuthError(errorMessage: 'Failed to retrieve access token'));
      }
    } else {
      emit(AuthError(errorMessage: error));
    }
  }

  void _handleRegisterEvent(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthStateLoading());
    final error = await authService.registerUser(event.email, event.password);
    if (error == null) {
      emit(AuthRegistered());
    } else {
      emit(AuthError(errorMessage: error));
    }
  }

  void _handleLogoutEvent(LogoutEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthStateLoading());
      final accessToken = await readAccessToken();
      final result = await authService.logoutUser(accessToken!);
      if (result == null) {
        await clearAccessToken();
        await saveLoginState(false);
        emit(AuthLoggedOut());
      } else {
        emit(const AuthError(errorMessage: 'Logout failed'));
      }
    } catch (error) {
      emit(AuthError(errorMessage: 'Error during logout: $error'));
    }
  }

  void _handleRegisteredEvent(RegisteredEvent event, Emitter<AuthState> emit) {
    emit(AuthRegistered());
  }

  void _handleCheckLoginEvent(CheckLoginEvent event, Emitter<AuthState> emit) async {
    final isLoggedIn = await readLoginState();
    final accessToken = await readAccessToken();
    if (isLoggedIn && accessToken != null) {
      emit(AuthLoggedIn(accessToken: accessToken));
    } else {
      emit(AuthLoggedOut());
    }
  }
}
import 'package:bloc/bloc.dart';
import 'package:frontend/auth/auth_event.dart';
import 'package:frontend/auth/auth_state.dart';
import 'package:frontend/services/auth_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc(this.authService) : super(AuthInitial());

  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is LoginEvent) {
      yield AuthLoggedIn();
    } else if (event is RegisterEvent) {
      yield AuthRegistered();
    } else if (event is RegisteredEvent) {
      yield AuthLoggedIn();
    }
  }
}
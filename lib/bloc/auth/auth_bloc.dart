import 'package:bloc/bloc.dart';
import 'package:chat/tools/auth_service.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this.auth) : super(AuthState()) {
    on<LoginEvent>(onLogin);
    on<RegisterEvent>(onRegister);
    on<LogOutEvent>(onLogOut);
  }

  final AuthService auth;

  Future<void> onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final user = await auth.login(event.email, event.password);
    if (user != null) {
      emit(state.copyWith(status: AuthStatus.success, user: user));
    } else {
      emit(state.copyWith(status: AuthStatus.error));
    }
  }

  Future<void> onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final user = await auth.signUp(event.email, event.password);
    if (user != null) {
      emit(state.copyWith(user: user, status: AuthStatus.success));
    } else {
      emit(state.copyWith(status: AuthStatus.error));
    }
  }

  Future<void> onLogOut(LogOutEvent event, Emitter<AuthState> emit) async {
    await auth.logOut();
    emit(state.copyWith(status: AuthStatus.loggedOut));
  }
}

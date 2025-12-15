part of 'auth_bloc.dart';

enum AuthStatus { initial, loading, success, error, loggedOut }

class AuthState extends Equatable {
  const AuthState({this.status = AuthStatus.initial, this.user});
  final AuthStatus status;
  final User? user;

  AuthState copyWith({AuthStatus? status, User? user}) {
    return AuthState(user: user ?? this.user, status: status ?? this.status);
  }

  @override
  List<Object?> get props => [status, user];
}

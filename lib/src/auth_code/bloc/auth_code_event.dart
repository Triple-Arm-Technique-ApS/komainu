part of 'auth_code_bloc.dart';

enum AuthCodeEventType { initial, callback, started }

class AuthCodeEvent extends Equatable {
  final AuthCodeEventType type;
  final Uri? callback;
  const AuthCodeEvent(this.type, this.callback);

  @override
  List<Object> get props => [type];

  /// The initial state
  factory AuthCodeEvent.start() {
    return const AuthCodeEvent(AuthCodeEventType.initial, null);
  }

  factory AuthCodeEvent.callback(Uri callback) {
    return AuthCodeEvent(AuthCodeEventType.initial, callback);
  }
}

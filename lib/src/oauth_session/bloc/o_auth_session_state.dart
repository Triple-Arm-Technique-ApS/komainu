part of 'o_auth_session_bloc.dart';

@immutable
class OAuthSessionState {
  /// [auhtorized] is true if the current session holds
  /// an access token that is not [expired]
  bool get authorized => !initial && !expired;

  /// [expired] is true if the current session holds
  /// an access token that is [expired]
  bool get expired => !initial && credentials!.isExpired;

  /// [initial] means that the session currently int in an authorized state.
  bool get initial => credentials == null;
  final Credentials? credentials;

  const OAuthSessionState(this.credentials);

  factory OAuthSessionState.initial() => const OAuthSessionState(null);
}

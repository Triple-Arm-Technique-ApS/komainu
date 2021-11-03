part of 'o_auth_session_bloc.dart';

enum OAuthSessionStateStatus {
  unauthorized,
  authorized,
  expired,
}

@immutable
class OAuthSessionState {
  final Credentials? credentials;
  final OAuthSessionStateStatus status;
  const OAuthSessionState._(this.credentials, this.status);

  factory OAuthSessionState.initial() => const OAuthSessionState._(
        null,
        OAuthSessionStateStatus.unauthorized,
      );

  factory OAuthSessionState.authorized(Credentials credentials) =>
      OAuthSessionState._(
        credentials,
        OAuthSessionStateStatus.authorized,
      );

  factory OAuthSessionState.expired() => const OAuthSessionState._(
        null,
        OAuthSessionStateStatus.expired,
      );
}

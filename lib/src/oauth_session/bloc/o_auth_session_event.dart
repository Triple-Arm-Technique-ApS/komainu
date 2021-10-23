part of 'o_auth_session_bloc.dart';

@immutable
abstract class OAuthSessionEvent {}

class OAuthSignOutEvent implements OAuthSessionEvent {}

class OAuthSignInEvent implements OAuthSessionEvent {
  final Credentials credentials;

  OAuthSignInEvent(this.credentials);
}

class _CredentialsLoaded implements OAuthSessionEvent {
  final Credentials? credentials;

  _CredentialsLoaded(this.credentials);
}

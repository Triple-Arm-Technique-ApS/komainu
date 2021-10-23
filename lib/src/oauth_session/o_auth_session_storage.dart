import 'package:flutter/foundation.dart';
import 'package:oauth2/oauth2.dart';

typedef OAuthSessionCreator = OAuthSessionStorage Function();

/// Interface for [OAuthSessionStorage] which can be replaced
/// with an custom implementation.
abstract class OAuthSessionStorage {
  /// When [beginSession] is called at the start of either
  /// the [OAuthSessionListener], the [OAuthSessionBuilder] or the [OAuthSessionConsumer]
  /// during initialization to determinate the state of the stored session.
  Future<Credentials?> beginSession();

  /// After and successful sign in [persist] is called with
  /// the [Credentials] obtained after signin.
  Future persist(Credentials credentials);

  /// After a successful sign out or an expired token [endSession] is called
  /// and the implementation must remove the invalid token.
  Future endSession();
}

/// Default implementation of the [OAuthSessionStorage]
class MemoryAuthSessionStorage implements OAuthSessionStorage {
  Credentials? credentials;

  @override
  Future<Credentials?> beginSession() {
    return SynchronousFuture(credentials);
  }

  @override
  Future endSession() {
    credentials = null;
    return SynchronousFuture(null);
  }

  @override
  Future persist(Credentials credentials) {
    credentials = credentials;
    return SynchronousFuture(null);
  }
}

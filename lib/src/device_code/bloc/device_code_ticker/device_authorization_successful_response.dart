import 'package:flutter/foundation.dart';

/// TODO: maybe removed since it isn't used.
@immutable
class DeviceAuthorizationSuccessfulResponse {
  /// Always "Bearer.
  final String tokenType;

  /// If an access token was returned, this lists the scopes the access token is valid for.
  final String scope;

  /// Number of seconds before the included access token is valid for.
  final int expiresIn;

  /// Issued for the scopes that were requested.
  final String accessToken;

  /// Issued if the original [scope] parameter included the openid scope.
  final String idToken;

  /// Issued if the original scope parameter included offline_access.
  final String refreshToken;

  const DeviceAuthorizationSuccessfulResponse({
    required this.tokenType,
    required this.scope,
    required this.expiresIn,
    required this.accessToken,
    required this.idToken,
    required this.refreshToken,
  });

  factory DeviceAuthorizationSuccessfulResponse.fromJson(
      Map<String, dynamic> json) {
    return DeviceAuthorizationSuccessfulResponse(
      tokenType: json['token_type'] as String,
      scope: json['scope'] as String,
      expiresIn: json['expires_in'] as int,
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      idToken: json['id_token'] as String,
    );
  }
}

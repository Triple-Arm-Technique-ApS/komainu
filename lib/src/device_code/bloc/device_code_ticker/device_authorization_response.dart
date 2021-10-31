import 'package:flutter/foundation.dart';

@immutable
class DeviceAuthorizationResponse {
  /// A long string used to verify the session between the client and the authorization server.
  /// The client uses this parameter to request the access token from the authorization server.
  final String deviceCode;

  /// A short string shown to the user that's used to identify the session on a secondary device.
  final String userCode;

  ///	The URI the user should go to with the [userCode] in order to sign in.
  final Uri verificationUri;

  /// The number of seconds before the [deviceCode] and [userCode] expire.
  final int expiresIn;

  /// The number of seconds the client should wait between polling requests.
  final int interval;

  /// A human-readable string with instructions for the user.
  /// This can be localized by including a query parameter
  /// in the request of the form ?mkt=xx-XX, filling in the appropriate language culture code.
  final String message;

  const DeviceAuthorizationResponse({
    required this.deviceCode,
    required this.userCode,
    required this.verificationUri,
    required this.expiresIn,
    required this.interval,
    required this.message,
  });

  factory DeviceAuthorizationResponse.fromJson(Map<String, dynamic> json) {
    return DeviceAuthorizationResponse(
      userCode: json['user_code'] as String,
      deviceCode: json['device_code'] as String,
      verificationUri: Uri.parse(json['verification_uri'] as String),
      expiresIn: json['expires_in'] as int,
      interval: json['interval'] as int,
      message: json['message'] as String,
    );
  }
}

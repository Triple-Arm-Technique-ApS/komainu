import 'package:flutter/foundation.dart';
import 'package:oauth2/oauth2.dart';

@immutable
class DeviceCodeTickerEvent {
  /// [expired] is true if either expiresIn treshold is passed
  /// or error code expired is recieved while polling the token
  /// endpoint.
  final bool expired;

  /// The end user [declined] the authorization request.
  final bool declined;

  /// The device code sent to the token endpoint wasn't recognized.
  final bool badVerificationCode;

  /// An [unexpected] error was recieved.
  final bool unexpected;

  /// [credentials] are set if a success response is recieved from the
  /// token endpoint.
  final Credentials? credentials;

  const DeviceCodeTickerEvent({
    required this.expired,
    required this.declined,
    required this.badVerificationCode,
    required this.unexpected,
    this.credentials,
  });

  /// [successful] if the sign in flow completes and [credentials] are received.
  bool get successful => credentials != null;

  /// If all other properties is false then the polling loop is still [running]
  bool get running =>
      !successful &&
      !expired &&
      !declined &&
      !badVerificationCode &&
      !unexpected;

  factory DeviceCodeTickerEvent.successful(Credentials credentials) {
    return DeviceCodeTickerEvent(
      expired: credentials.isExpired,
      declined: false,
      badVerificationCode: false,
      unexpected: false,
      credentials: credentials,
    );
  }
  factory DeviceCodeTickerEvent.badVerificationCode() {
    return const DeviceCodeTickerEvent(
      expired: false,
      declined: false,
      badVerificationCode: true,
      unexpected: false,
    );
  }

  factory DeviceCodeTickerEvent.expired() {
    return const DeviceCodeTickerEvent(
      expired: true,
      declined: false,
      badVerificationCode: false,
      unexpected: false,
    );
  }
  factory DeviceCodeTickerEvent.declined() {
    return const DeviceCodeTickerEvent(
      expired: false,
      declined: true,
      badVerificationCode: false,
      unexpected: false,
    );
  }
  factory DeviceCodeTickerEvent.unexpected() {
    return const DeviceCodeTickerEvent(
      expired: false,
      declined: false,
      badVerificationCode: false,
      unexpected: true,
    );
  }

  factory DeviceCodeTickerEvent.running() {
    return const DeviceCodeTickerEvent(
      expired: false,
      declined: false,
      badVerificationCode: false,
      unexpected: false,
    );
  }
}

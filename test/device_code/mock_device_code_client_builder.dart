import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:komainu/komainu.dart';
import 'package:mocktail/mocktail.dart';

class MockClient extends Mock implements Client {}

const String dummyAccessToken =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c';

typedef AuthorizationCallback = Future<Response> Function(
  String userCode,
  String deviceCode,
  Uri verificationUri,
);

typedef TokenCallback = Future<Response> Function();

class MockDeviceCodeClientBuilder {
  static Client create(
    AuthorizationCallback authorizationCallback,
    TokenCallback tokenCallback,
    OAuthConfiguration configuration,
    String deviceCode,
    String userCode,
    Uri verificationUri,
  ) {
    final client = MockClient();
    when(
      () => client.post(
        configuration.tokenEndpoint,
        body: {
          'client_id': configuration.clientId,
          'grant_type': 'urn:ietf:params:oauth:grant-type:device_code',
          'device_code': deviceCode
        },
      ),
    ).thenAnswer(
      (_) => tokenCallback(),
    );

    when(
      () => client.post(
        configuration.authorizationEndpoint,
        body: {
          'client_id': configuration.clientId,
          'scope': configuration.scope.join(' '),
        },
      ),
    ).thenAnswer(
      (_) => authorizationCallback(userCode, deviceCode, verificationUri),
    );

    return client;
  }

  static Future<Response> createRunningResponse() {
    return _createBadRequestResponse('authorization_pending');
  }

  static Future<Response> createDeclinedResponse() {
    return _createBadRequestResponse('authorization_declined');
  }

  static Future<Response> createBadVerificationCodeResponse() {
    return _createBadRequestResponse('bad_verification_code');
  }

  static Future<Response> createExpiredCodeResponse() {
    return _createBadRequestResponse('expired_token');
  }

  static Future<Response> createAuthorizationSuccessfulResponse(
    String userCode,
    String deviceCode,
    Uri verificationUri,
  ) {
    return SynchronousFuture(
      Response(
          jsonEncode({
            'user_code': userCode,
            'device_code': deviceCode,
            'verification_uri': verificationUri.toString(),
            'expires_in': 3000,
            'interval': 1,
            'message': 'Test Message'
          }),
          200),
    );
  }

  static Future<Response> _createBadRequestResponse(String error) {
    return SynchronousFuture(Response(jsonEncode({'error': error}), 400));
  }

  static Future<Response> createSuccessResponse() {
    return SynchronousFuture(
      Response(
        jsonEncode(
          {'access_token': dummyAccessToken},
        ),
        200,
      ),
    );
  }
}

import 'dart:convert';

import 'package:http/http.dart';
import 'package:oauth2/oauth2.dart';

import 'device_code_ticker_event.dart';
import 'device_polling_response.dart';

class DeviceCodeTicker {
  Stream<DeviceCodeTickerEvent> tick({
    required String clientId,
    required Uri tokenEndpoint,
    required String deviceCode,
    required int interval,
    required int expiresIn,
  }) {
    return Stream.periodic(Duration(seconds: interval), (x) => x * interval)
        .asyncMap((secondsSinceStart) async {
      if (secondsSinceStart > expiresIn) {
        return DeviceCodeTickerEvent.expired();
      }
      final response = await _requestToken(
        clientId: clientId,
        deviceCode: deviceCode,
        tokenEndpoint: tokenEndpoint,
      );
      switch (response.statusCode) {
        case 200:
          return DeviceCodeTickerEvent.successful(
            Credentials.fromJson(
              jsonDecode(response.body),
            ),
          );
        case 400:
          return _handleBadRequest(response);
        default:
          return DeviceCodeTickerEvent.unexpected();
      }
    });
  }

  Future<Response> _requestToken({
    required Uri tokenEndpoint,
    required String clientId,
    required String deviceCode,
  }) async {
    final payload = {
      'client_id': clientId,
      'grant_type': 'urn:ietf:params:oauth:grant-type:device_code',
      'device_code': deviceCode
    };

    return await post(tokenEndpoint, body: payload);
  }

  DeviceCodeTickerEvent _handleBadRequest(Response response) {
    final dto = DevicePollingResponse.fromJson(
      jsonDecode(response.body),
    );

    final error = dto.error;

    if (error == 'authorization_pending') {
      return DeviceCodeTickerEvent.running();
    }

    if (error == 'authorization_declined') {
      return DeviceCodeTickerEvent.declined();
    }

    if (error == 'bad_verification_code') {
      return DeviceCodeTickerEvent.badVerificationCode();
    }

    if (error == 'expired_token') {
      return DeviceCodeTickerEvent.expired();
    }

    return DeviceCodeTickerEvent.unexpected();
  }
}

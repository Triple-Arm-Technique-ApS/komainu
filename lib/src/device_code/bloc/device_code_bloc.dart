import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:oauth2/oauth2.dart' as oauth;

import '../../building_blocks/building_blocks.dart';
import 'device_code_ticker/device_authorization_response.dart';
import 'device_code_ticker/device_code_ticker.dart';
import 'device_code_ticker/device_code_ticker_event.dart';

part 'device_code_event.dart';
part 'device_code_state.dart';

typedef ConfigureOAuthCreator = OAuthConfiguration Function();

class DeviceCodeBloc extends Bloc<DeviceCodeEvent, DeviceCodeState> {
  final DeviceCodeTicker _ticker;
  final Client client;
  final OAuthConfiguration configuration;

  DeviceCodeBloc(this.client, this.configuration)
      : _ticker = DeviceCodeTicker(client),
        super(DeviceCodeState.initial()) {
    on<DeviceCodeStartStopEvent>(
      (event, emit) async {
        if (event.status == DeviceCodeStartStopStatus.started) {
          emit(DeviceCodeState.loading());
          try {
            var response = await initializeAuthorization();
            emit(
              DeviceCodeState.running(
                response.userCode,
                response.verificationUri,
              ),
            );
            await emit.forEach(
              getTickerStream(response),
              onData: _mapTickerEventToDeviceCodeState,
            );
            // _beginPollingTokenEndpoint(response);
          } on HttpException catch (e) {
            emit(
              DeviceCodeState.failed(
                FailureDetails(
                  statusCode: e.statusCode,
                  reasonPhrase: e.reasonPhrase,
                  body: e.body,
                  message: e.message,
                ),
              ),
            );
          }
        }
        if (event.status == DeviceCodeStartStopStatus.cancelled) {
          emit(
            DeviceCodeState.cancelled(),
          );
        }
      },
      transformer: restartable(),
    );
  }

  Future<DeviceAuthorizationResponse> initializeAuthorization() async {
    try {
      final payload = {
        'client_id': configuration.clientId,
        'scope': configuration.scope.join(' '),
      };
      final response = await client.post(
        configuration.deviceAuthorizationEndpoint!,
        body: payload,
      );
      if (response.statusCode < 200 || response.statusCode > 299) {
        throw HttpException(
          statusCode: response.statusCode,
          reasonPhrase: response.reasonPhrase,
          body: response.body,
        );
      }
      return DeviceAuthorizationResponse.fromJson(jsonDecode(response.body));
    } on HttpException catch (_) {
      rethrow;
    } catch (e) {
      throw HttpException(
        statusCode: 0,
        reasonPhrase: 'Unexpected',
        body: 'Exception was thrown: $e',
      );
    }
  }

  Stream<DeviceCodeTickerEvent> getTickerStream(
    DeviceAuthorizationResponse response,
  ) {
    return _ticker.tick(
      configuration: configuration,
      deviceCode: response.deviceCode,
      interval: response.interval,
      expiresIn: response.expiresIn,
    );
  }

  DeviceCodeState _mapTickerEventToDeviceCodeState(
    DeviceCodeTickerEvent event,
  ) {
    if (event.running) {
      return DeviceCodeState.running(state.userCode!, state.verificationUri!);
    }
    add(DeviceCodeStartStopEvent.stop());
    if (event.badVerificationCode) {
      return DeviceCodeState.badVerificationCode();
    } else if (event.declined) {
      return DeviceCodeState.declined();
    } else if (event.expired) {
      return DeviceCodeState.expired();
    } else if (event.unexpected) {
      return DeviceCodeState.failed(
        FailureDetails(
          statusCode: event.exception!.statusCode,
          reasonPhrase: event.exception!.reasonPhrase,
          body: event.exception!.body,
          message: event.exception!.message,
        ),
      );
    } else if (event.successful) {
      return DeviceCodeState.success(event.credentials!);
    } else {
      return DeviceCodeState.running(state.userCode!, state.verificationUri!);
    }
  }
}

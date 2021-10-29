import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

import '../../building_blocks/building_blocks.dart';
import '../device_code_ticker/device_authorization_response.dart';
import '../device_code_ticker/device_code_ticker.dart';
import '../device_code_ticker/device_code_ticker_event.dart';

part 'device_code_event.dart';
part 'device_code_state.dart';

class DeviceCodeBloc extends Bloc<DeviceCodeEvent, DeviceCodeState> {
  final DeviceCodeTicker _ticker;
  final Client client;
  final OAuthConfiguration configuration;

  StreamSubscription<DeviceCodeTickerEvent>? _tickerSubscription;

  DeviceCodeBloc(this.client, this.configuration)
      : _ticker = DeviceCodeTicker(client),
        super(DeviceCodeState.initial()) {
    on<DeviceCodeEvent>((event, emit) async {
      if (event is DeviceCodeStartEvent) {
        emit(DeviceCodeState.loading());
        _tickerSubscription?.cancel();
        try {
          var response = await initializeAuthorization();
          emit(
            DeviceCodeState.running(
              response.userCode,
              response.verificationUri,
            ),
          );
          _tickerSubscription = _ticker
              .tick(
            configuration: configuration,
            deviceCode: response.deviceCode,
            interval: response.interval,
            expiresIn: response.expiresIn,
          )
              .listen(
            (event) {
              if (event.badVerificationCode) {
                emit(DeviceCodeState.badVerificationCode());
              } else if (event.declined) {
                emit(DeviceCodeState.declined());
              } else if (event.expired) {
                emit(DeviceCodeState.expired());
              } else if (event.unexpected) {
                emit(
                  DeviceCodeState.failed(
                    DeviceCodeFailureDetails(
                      statusCode: event.exception!.statusCode,
                      reasonPhrase: event.exception!.reasonPhrase,
                      body: event.exception!.body,
                      message: event.exception!.message,
                    ),
                  ),
                );
              } else if (event.successful) {
                emit(DeviceCodeState.success());
              } else {
                emit(
                  DeviceCodeState.running(
                    response.userCode,
                    response.verificationUri,
                  ),
                );
              }
            },
          );
        } on HttpException catch (e) {
          emit(
            DeviceCodeState.failed(
              DeviceCodeFailureDetails(
                statusCode: e.statusCode,
                reasonPhrase: e.reasonPhrase,
                body: e.body,
                message: e.message,
              ),
            ),
          );
        }
      }
    });
  }

  Future<DeviceAuthorizationResponse> initializeAuthorization() async {
    try {
      final payload = {
        'client_id': configuration.clientId,
        'scope': configuration.scope,
      };
      final response =
          await client.post(configuration.authorizationEndpoint, body: payload);
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

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }
}

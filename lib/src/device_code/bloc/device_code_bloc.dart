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
    on<_TickerEvent>((event, emit) async {
      switch (event.status) {
        case _TickerStatus.badCode:
          emit(DeviceCodeState.badVerificationCode());
          break;
        case _TickerStatus.declined:
          emit(DeviceCodeState.declined());
          break;
        case _TickerStatus.expired:
          emit(DeviceCodeState.expired());
          break;
        case _TickerStatus.failure:
          emit(DeviceCodeState.failed(event.failureDetails!));
          break;
        case _TickerStatus.running:
          emit(
            DeviceCodeState.running(state.userCode!, state.verificationUri!),
          );
          break;
        case _TickerStatus.success:
          emit(
            DeviceCodeState.success(),
          );
          break;
        default:
      }
    });
    on<DeviceCodeEvent>((event, emit) async {
      if (event is DeviceCodeStartEvent) {
        emit(DeviceCodeState.loading());
        try {
          var response = await initializeAuthorization();
          emit(
            DeviceCodeState.running(
              response.userCode,
              response.verificationUri,
            ),
          );
          _beginPollingTokenEndpoint(response);
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
    });
  }

  Future<DeviceAuthorizationResponse> initializeAuthorization() async {
    try {
      final payload = {
        'client_id': configuration.clientId,
        'scope': configuration.scope.join(' '),
      };
      final response = await client.post(
        configuration.authorizationEndpoint,
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

  void _beginPollingTokenEndpoint(DeviceAuthorizationResponse response) {
    _tickerSubscription?.cancel();
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
          add(_TickerEvent(status: _TickerStatus.badCode));
          _tickerSubscription?.cancel();
        } else if (event.declined) {
          add(_TickerEvent(status: _TickerStatus.declined));
          _tickerSubscription?.cancel();
        } else if (event.expired) {
          add(_TickerEvent(status: _TickerStatus.expired));
          _tickerSubscription?.cancel();
        } else if (event.unexpected) {
          add(
            _TickerEvent(
              status: _TickerStatus.failure,
              failureDetails: FailureDetails(
                statusCode: event.exception!.statusCode,
                reasonPhrase: event.exception!.reasonPhrase,
                body: event.exception!.body,
                message: event.exception!.message,
              ),
            ),
          );
          _tickerSubscription?.cancel();
        } else if (event.successful) {
          add(_TickerEvent(status: _TickerStatus.success));
          _tickerSubscription?.cancel();
        } else {
          add(_TickerEvent(status: _TickerStatus.running));
        }
      },
    );
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }
}

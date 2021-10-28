import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
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
        super(DeviceCodeInitial()) {
    on<DeviceCodeEvent>((event, emit) async {
      if (event is DeviceCodeStartEvent) {
        emit(DeviceCodeStateInitializing());
        _tickerSubscription?.cancel();
        try {
          var response = await initializeAuthorization();
          emit(
            DeviceCodeReadyState(response.verificationUri, response.userCode),
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
                emit(DeviceCodeBadVerificationCodeState());
              } else if (event.declined) {
                emit(DeviceCodeAuthorizationDeclinedState());
              } else if (event.expired) {
                emit(DeviceCodeExpiredState());
              } else if (event.unexpected) {
                emit(DeviceCodeUnexpectedFailureState());
              } else if (event.successful) {
                emit(DeviceCodeSucceedState());
              }
            },
          );
        } on HttpException catch (e) {
          /// emit unexepected error while initializing the device code authroization.
        }
        // _tickerSubscription = _ticker.tick(
        //   clientId: clientId,
        //   tokenEndpoint: tokenEndpoint,
        //   deviceCode: deviceCode,
        //   interval: interval,
        //   expiresIn: expiresIn,
        // );
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

import 'package:bloc_test/bloc_test.dart';
import 'package:komainu/komainu.dart';
import 'package:komainu/src/device_code/bloc/device_code_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'mock_device_code_client_builder.dart';

class MockDeviceCodeBloc extends MockBloc<DeviceCodeEvent, DeviceCodeState>
    implements DeviceCodeBloc {}

// Fake WellKnown Configuration Event
class FakeDeviceCodeEvent extends Fake implements DeviceCodeEvent {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeDeviceCodeEvent());
  });

  mainBloc();
}

void mainBloc() {
  group(
    'DeviceCodeBloc',
    () {
      const userCode = '12345';
      final verificationUri = Uri.parse('https://device.code/');
      final successAuthorizationEndpoint = Uri.parse(
        'https://device.code/authorize',
      );

      final tokenEndpoint = Uri.parse('https://device.code/token');

      const clientId = '12-321-123';

      const scope = ['User.Read'];

      const deviceCode = '1234';

      final configuration = OAuthConfiguration(
        clientId,
        Uri.parse('https://does.not/matter'),
        scope,
        successAuthorizationEndpoint,
        null,
        null,
        tokenEndpoint,
        successAuthorizationEndpoint,
      );

      blocTest<DeviceCodeBloc, DeviceCodeState>(
        'emits [loading, running, declined] when the authorization request is successful and the token request is declined',
        build: () => DeviceCodeBloc(
          MockDeviceCodeClientBuilder.create(
            MockDeviceCodeClientBuilder.createAuthorizationSuccessfulResponse,
            MockDeviceCodeClientBuilder.createDeclinedResponse,
            configuration,
            deviceCode,
            userCode,
            verificationUri,
          ),
          configuration,
        ),
        act: (bloc) => bloc.add(DeviceCodeStartStopEvent.start()),
        wait: const Duration(seconds: 2),
        expect: () => [
          DeviceCodeState.loading(),
          DeviceCodeState.running(userCode, verificationUri),
          DeviceCodeState.declined()
        ],
      );

      blocTest<DeviceCodeBloc, DeviceCodeState>(
        'emits [loading, running, badVerificationCode] when the authorization request is successful and the token request contains a bad code',
        build: () => DeviceCodeBloc(
          MockDeviceCodeClientBuilder.create(
            MockDeviceCodeClientBuilder.createAuthorizationSuccessfulResponse,
            MockDeviceCodeClientBuilder.createBadVerificationCodeResponse,
            configuration,
            deviceCode,
            userCode,
            verificationUri,
          ),
          configuration,
        ),
        act: (bloc) => bloc.add(DeviceCodeStartStopEvent.start()),
        wait: const Duration(seconds: 2),
        expect: () => [
          DeviceCodeState.loading(),
          DeviceCodeState.running(userCode, verificationUri),
          DeviceCodeState.badVerificationCode()
        ],
      );
      blocTest<DeviceCodeBloc, DeviceCodeState>(
        'emits [loading, running, expired] when the authorization request is successful and the token request contains a running',
        build: () => DeviceCodeBloc(
          MockDeviceCodeClientBuilder.create(
            MockDeviceCodeClientBuilder.createAuthorizationSuccessfulResponse,
            MockDeviceCodeClientBuilder.createExpiredCodeResponse,
            configuration,
            deviceCode,
            userCode,
            verificationUri,
          ),
          configuration,
        ),
        act: (bloc) => bloc.add(DeviceCodeStartStopEvent.start()),
        wait: const Duration(seconds: 2),
        expect: () => [
          DeviceCodeState.loading(),
          DeviceCodeState.running(userCode, verificationUri),
          DeviceCodeState.expired()
        ],
      );
      blocTest<DeviceCodeBloc, DeviceCodeState>(
        'emits [loading, running] when the authorization request is successful and the token request contains a running',
        build: () => DeviceCodeBloc(
          MockDeviceCodeClientBuilder.create(
            MockDeviceCodeClientBuilder.createAuthorizationSuccessfulResponse,
            MockDeviceCodeClientBuilder.createRunningResponse,
            configuration,
            deviceCode,
            userCode,
            verificationUri,
          ),
          configuration,
        ),
        act: (bloc) => bloc.add(DeviceCodeStartStopEvent.start()),
        wait: const Duration(seconds: 2),
        expect: () => [
          DeviceCodeState.loading(),
          DeviceCodeState.running(userCode, verificationUri),
        ],
      );
    },
  );
}

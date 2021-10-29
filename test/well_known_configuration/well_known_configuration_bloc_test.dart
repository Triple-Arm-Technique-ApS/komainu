import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:http/http.dart';
import 'package:komainu/komainu.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockWellKnownConfigurationBloc
    extends MockBloc<WellKnownConfigurationEvent, WellKnownConfigurationState>
    implements WellKnownConfigurationBloc {}

// Fake WellKnown Configuration Event
class FakeWellKnownConfigurationEvent extends Fake
    implements WellKnownConfigurationEvent {}

class MockClient extends Mock implements Client {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeWellKnownConfigurationEvent());
  });

  mainBloc();
}

void mainBloc() {
  group(
    'WellKnownConfigurationBloc',
    () {
      final client = MockClient();
      final Uri failureEndpoint =
          Uri.parse('https://endpoint.to/well-unknown/configuration');
      final Uri successEndpoint =
          Uri.parse('https://endpoint.to/well-known/configuration');
      final Uri exceptionEndpoint =
          Uri.parse('https://endpoint.to/well-failure');
      final issuer = Uri.parse('https://endpoint.to/');
      final authorizationEndpoint = Uri.parse('https://endpoint.to/authorize');
      final tokenEndpoint = Uri.parse('https://endpoint.to/token');
      final responseModeSupported = ['query'];
      final responseTypesSupported = ['code'];
      when(
        () => client.get(
          failureEndpoint,
        ),
      ).thenAnswer(
        (_) => Future.value(
          Response(
            '{ "Error": "unexpected" }',
            500,
            reasonPhrase: 'Test Failure',
          ),
        ),
      );
      when(
        () => client.get(
          successEndpoint,
        ),
      ).thenAnswer(
        (_) => Future.value(
          Response(
            jsonEncode({
              'issuer': issuer.toString(),
              'authorization_endpoint': authorizationEndpoint.toString(),
              'token_endpoint': tokenEndpoint.toString(),
              'response_modes_supported': responseModeSupported,
              'response_types_supported': responseTypesSupported
            }),
            200,
          ),
        ),
      );
      when(
        () => client.get(
          exceptionEndpoint,
        ),
      ).thenThrow(
        Exception('Test Error'),
      );
      blocTest<WellKnownConfigurationBloc, WellKnownConfigurationState>(
        'emits [] when nothing is added',
        build: () => WellKnownConfigurationBloc(client),
        expect: () => const <WellKnownConfigurationState>[],
      );

      blocTest<WellKnownConfigurationBloc, WellKnownConfigurationState>(
        'emits [WellKnownConfigurationState] with failed true if the client returns status code 500',
        build: () => WellKnownConfigurationBloc(client),
        act: (bloc) =>
            bloc.add(WellKnownConfigurationRequested(failureEndpoint)),
        wait: const Duration(seconds: 1),
        expect: () => <WellKnownConfigurationState>[
          WellKnownConfigurationState.loading(),
          WellKnownConfigurationState.failed(
            const WellKnownConfigurationFailureDetails(
              body: '{ "Error": "unexpected" }',
              statusCode: 500,
              reasonPhrase: 'Test Failure',
              message: 'HTTP request failed with status : 500 Test Failure.',
            ),
          ),
        ],
      );

      blocTest<WellKnownConfigurationBloc, WellKnownConfigurationState>(
        'emits [WellKnownConfigurationState] with successful true if the client returns status code 200',
        build: () => WellKnownConfigurationBloc(client),
        act: (bloc) =>
            bloc.add(WellKnownConfigurationRequested(successEndpoint)),
        wait: const Duration(seconds: 1),
        expect: () => <WellKnownConfigurationState>[
          WellKnownConfigurationState.loading(),
          WellKnownConfigurationState.successful(
            DiscoveryDocument(
              issuer: issuer,
              authorizationEndpoint: authorizationEndpoint,
              tokenEndpoint: tokenEndpoint,
              responseModesSupported: responseModeSupported,
              responseTypesSupported: responseTypesSupported,
            ),
          ),
        ],
      );

      blocTest<WellKnownConfigurationBloc, WellKnownConfigurationState>(
        'emits [WellKnownConfigurationState] with failed true if the client returns throws an exception',
        build: () => WellKnownConfigurationBloc(client),
        act: (bloc) => bloc.add(
          WellKnownConfigurationRequested(exceptionEndpoint),
        ),
        wait: const Duration(seconds: 1),
        expect: () => <WellKnownConfigurationState>[
          WellKnownConfigurationState.loading(),
          WellKnownConfigurationState.failed(
            const WellKnownConfigurationFailureDetails(
              statusCode: 0,
              reasonPhrase: 'Unexpected',
              body: 'Exception was thrown: Exception: Test Error',
              message: 'HTTP request failed with status : 0 Unexpected.',
            ),
          ),
        ],
      );
    },
  );
}

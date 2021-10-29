import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:komainu/src/building_blocks/exceptions/http_exception.dart';
import 'package:komainu/src/building_blocks/failure_details.dart';
import '../discovery_document.dart';
import 'package:meta/meta.dart';

import '../well_known_configuration.dart';

part 'well_known_configuration_event.dart';
part 'well_known_configuration_state.dart';

class WellKnownConfigurationBloc
    extends Bloc<WellKnownConfigurationEvent, WellKnownConfigurationState> {
  final Client client;
  WellKnownConfigurationBloc(this.client)
      : super(WellKnownConfigurationState.initial()) {
    on<WellKnownConfigurationEvent>((event, emit) async {
      if (event is WellKnownConfigurationRequested) {
        try {
          emit(
            WellKnownConfigurationState.loading(),
          );
          final discoveryDocument = await _getDiscoveryDocument(
            event.wellKnownConfigurationEndpoint,
          );
          emit(
            WellKnownConfigurationState.successful(discoveryDocument),
          );
        } on HttpException catch (exception) {
          emit(
            WellKnownConfigurationState.failed(
              FailureDetails(
                body: exception.body,
                statusCode: exception.statusCode,
                reasonPhrase: exception.reasonPhrase,
                message: exception.message,
              ),
            ),
          );
        }
      }
    });
  }

  Future<DiscoveryDocument> _getDiscoveryDocument(
    Uri wellKnownConfigurationEndpoint,
  ) async {
    try {
      final response = await client.get(wellKnownConfigurationEndpoint);
      if (response.statusCode < 200 || response.statusCode > 299) {
        throw HttpException(
          statusCode: response.statusCode,
          reasonPhrase: response.reasonPhrase,
          body: response.body,
        );
      }
      return DiscoveryDocument.fromJson(jsonDecode(response.body));
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
}

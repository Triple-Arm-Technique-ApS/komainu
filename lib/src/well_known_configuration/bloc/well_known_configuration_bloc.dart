import 'package:bloc/bloc.dart';
import '../discovery_document.dart';
import 'package:meta/meta.dart';

import '../discovery_document_exception.dart';
import '../well_known_configuration.dart';

part 'well_known_configuration_event.dart';
part 'well_known_configuration_state.dart';

class WellKnownConfigurationBloc
    extends Bloc<WellKnownConfigurationEvent, WellKnownConfigurationState> {
  WellKnownConfigurationBloc() : super(WellKnownConfigurationState.initial()) {
    on<WellKnownConfigurationEvent>((event, emit) async {
      if (event is WellKnownConfigurationRequested) {
        try {
          final discoveryDocument =
              await DiscoveryDocument.fromWellKnownConfigurationEndpoint(
            event.wellKnownConfigurationEndpoint,
          );
          emit(
            WellKnownConfigurationState.successful(discoveryDocument),
          );
        } on DiscoveryDocumentException catch (exception) {
          emit(
            WellKnownConfigurationState.failed(exception),
          );
        }
      }
    });
  }
}

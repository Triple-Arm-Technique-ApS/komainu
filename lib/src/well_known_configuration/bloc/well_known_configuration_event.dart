part of 'well_known_configuration_bloc.dart';

@immutable
abstract class WellKnownConfigurationEvent {}

class WellKnownConfigurationRequested extends WellKnownConfigurationEvent {
  final Uri wellKnownConfigurationEndpoint;

  WellKnownConfigurationRequested(this.wellKnownConfigurationEndpoint);
}

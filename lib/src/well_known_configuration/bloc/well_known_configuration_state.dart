part of 'well_known_configuration_bloc.dart';

class WellKnownConfigurationState {
  /// [exception] contains information about why the
  /// request to the identity provider failed.
  final DiscoveryDocumentException? exception;

  /// if [successful] the [discoveryDocument] won't
  /// be null.
  final DiscoveryDocument? discoveryDocument;

  /// If [successful] the identity provider returns a successful
  /// HTTP response.
  bool get successful => discoveryDocument != null;

  /// When [failed] the identity provider returns a failed
  /// HTTP response.
  bool get failed => exception != null;
  WellKnownConfigurationState._({this.exception, this.discoveryDocument});

  factory WellKnownConfigurationState.failed(
          DiscoveryDocumentException exception) =>
      WellKnownConfigurationState._(exception: exception);

  factory WellKnownConfigurationState.successful(
          DiscoveryDocument discoveryDocument) =>
      WellKnownConfigurationState._(discoveryDocument: discoveryDocument);

  factory WellKnownConfigurationState.initial() =>
      WellKnownConfigurationState._();
}

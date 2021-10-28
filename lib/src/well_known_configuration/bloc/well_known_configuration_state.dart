part of 'well_known_configuration_bloc.dart';

class WellKnownConfigurationFailure extends Equatable {
  final int statusCode;
  final String? reasonPhrase;
  final String body;
  final String message;
  const WellKnownConfigurationFailure({
    required this.statusCode,
    required this.reasonPhrase,
    required this.body,
    required this.message,
  });

  @override
  List<Object?> get props => [statusCode, reasonPhrase, body, message];
}

class WellKnownConfigurationState extends Equatable {
  /// [failure] contains information about why the
  /// request to the identity provider failed.
  final WellKnownConfigurationFailure? failure;

  /// if [successful] the [discoveryDocument] won't
  /// be null.
  final DiscoveryDocument? discoveryDocument;

  /// If [successful] the identity provider returns a successful
  /// HTTP response.
  bool get successful => discoveryDocument != null;

  /// When [failed] the identity provider returns a failed
  /// HTTP response.
  bool get failed => failure != null;
  const WellKnownConfigurationState._({
    this.failure,
    this.discoveryDocument,
  });

  factory WellKnownConfigurationState.failed(
          WellKnownConfigurationFailure exception) =>
      WellKnownConfigurationState._(failure: exception);

  factory WellKnownConfigurationState.successful(
          DiscoveryDocument discoveryDocument) =>
      WellKnownConfigurationState._(discoveryDocument: discoveryDocument);

  factory WellKnownConfigurationState.initial() =>
      const WellKnownConfigurationState._();

  @override
  List<Object?> get props => [discoveryDocument, failure];
}

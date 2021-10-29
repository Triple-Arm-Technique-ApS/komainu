part of 'well_known_configuration_bloc.dart';

class WellKnownConfigurationFailureDetails extends Equatable {
  final int statusCode;
  final String? reasonPhrase;
  final String body;
  final String message;
  const WellKnownConfigurationFailureDetails({
    required this.statusCode,
    required this.reasonPhrase,
    required this.body,
    required this.message,
  });

  @override
  List<Object?> get props => [statusCode, reasonPhrase, body, message];
}

class WellKnownConfigurationState extends Equatable {
  /// if [status] equals [WellKnownConfigurationStatus.failure] contains information about why the
  /// request to the identity provider failed.
  final WellKnownConfigurationFailureDetails? failureDetails;

  /// if [status] equals [WellKnownConfigurationStatus.successful] the [discoveryDocument] won't
  /// be null.
  final DiscoveryDocument? discoveryDocument;

  /// The current [status] of the state if [status] is [WellKnownConfigurationStatus.inital] nothing has happend
  /// yet, [WellKnownConfigurationStatus.loading] when is right before and during the request to the endpoint,
  /// [WellKnownConfigurationStatus.failure] indicates that an [Exception] was thrown or the [Response] from the
  /// endpoint contains an error code, if the [discoveryDocument]  was returned without issues [status] is set
  /// to [WellKnownConfigurationStatus.success].
  final WellKnownConfigurationStatus status;

  const WellKnownConfigurationState._({
    this.failureDetails,
    this.discoveryDocument,
    this.status = WellKnownConfigurationStatus.inital,
  });

  factory WellKnownConfigurationState.failed(
    WellKnownConfigurationFailureDetails details,
  ) =>
      WellKnownConfigurationState._(
        failureDetails: details,
        status: WellKnownConfigurationStatus.failure,
      );

  factory WellKnownConfigurationState.successful(
          DiscoveryDocument discoveryDocument) =>
      WellKnownConfigurationState._(
        discoveryDocument: discoveryDocument,
        status: WellKnownConfigurationStatus.success,
      );

  factory WellKnownConfigurationState.initial() =>
      const WellKnownConfigurationState._();

  factory WellKnownConfigurationState.loading() =>
      const WellKnownConfigurationState._(
        status: WellKnownConfigurationStatus.loading,
      );

  @override
  List<Object?> get props => [discoveryDocument, status];
}

enum WellKnownConfigurationStatus { inital, loading, success, failure }

part of 'device_code_bloc.dart';

class DeviceCodeFailureDetails extends Equatable {
  final int statusCode;
  final String? reasonPhrase;
  final String body;
  final String message;
  const DeviceCodeFailureDetails({
    required this.statusCode,
    required this.reasonPhrase,
    required this.body,
    required this.message,
  });

  @override
  List<Object?> get props => [statusCode, reasonPhrase, body, message];
}

class DeviceCodeState {
  /// The current status of the [DeviceCodeState], [DeviceCodeStatus.loading] is
  /// while the authorization request is sent to the server then if successful
  /// the [status] will become [DeviceCodeStatus.running] with [userCode] and [verificationUri]
  /// the [status] can then change to the following
  /// [DeviceCodeStatus.failure] means that an [Exception] was thrown or the status to the token
  /// endpoint was unsuccessful, [DeviceCodeStatus.badCode] means that the verification code submitted
  /// by the user was incorrect, and the flow must be restarted, [DeviceCodeStatus.declined] means the
  /// user didn't consent the requested scopes, [DeviceCodeStatus.expired] means the sign in timed out
  /// and if all goes well and the flow completes without failure [status] is [DeviceCodeStatus.success].
  ///
  final DeviceCodeStatus status;

  /// The URI the user should go to with the [userCode] in order to sign in.
  final Uri? verificationUri;

  /// A short string shown to the user that's used to identify the session on a secondary device.
  final String? userCode;

  final DeviceCodeFailureDetails? failureDetails;

  DeviceCodeState._({
    this.userCode,
    this.verificationUri,
    this.failureDetails,
    this.status = DeviceCodeStatus.initial,
  });

  factory DeviceCodeState.initial() => DeviceCodeState._();

  factory DeviceCodeState.loading() => DeviceCodeState._(
        status: DeviceCodeStatus.loading,
      );
  factory DeviceCodeState.running(String userCode, Uri verificationUri) =>
      DeviceCodeState._(
        userCode: userCode,
        verificationUri: verificationUri,
        status: DeviceCodeStatus.running,
      );

  factory DeviceCodeState.failed(DeviceCodeFailureDetails details) =>
      DeviceCodeState._(
        failureDetails: details,
        status: DeviceCodeStatus.failure,
      );

  factory DeviceCodeState.success() => DeviceCodeState._(
        status: DeviceCodeStatus.success,
      );
  factory DeviceCodeState.badVerificationCode() => DeviceCodeState._(
        status: DeviceCodeStatus.badCode,
      );
  factory DeviceCodeState.declined() => DeviceCodeState._(
        status: DeviceCodeStatus.declined,
      );

  factory DeviceCodeState.expired() => DeviceCodeState._(
        status: DeviceCodeStatus.declined,
      );
}

enum DeviceCodeStatus {
  initial,
  loading,
  running,
  failure,
  success,
  badCode,
  declined,
  expired
}

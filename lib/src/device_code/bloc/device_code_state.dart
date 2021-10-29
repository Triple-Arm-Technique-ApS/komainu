part of 'device_code_bloc.dart';

class DeviceCodeState extends Equatable {
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

  final FailureDetails? failureDetails;

  const DeviceCodeState._({
    this.userCode,
    this.verificationUri,
    this.failureDetails,
    this.status = DeviceCodeStatus.initial,
  });

  factory DeviceCodeState.initial() => const DeviceCodeState._();

  factory DeviceCodeState.loading() => const DeviceCodeState._(
        status: DeviceCodeStatus.loading,
      );
  factory DeviceCodeState.running(String userCode, Uri verificationUri) =>
      DeviceCodeState._(
        userCode: userCode,
        verificationUri: verificationUri,
        status: DeviceCodeStatus.running,
      );

  factory DeviceCodeState.failed(FailureDetails details) => DeviceCodeState._(
        failureDetails: details,
        status: DeviceCodeStatus.failure,
      );

  factory DeviceCodeState.success() => const DeviceCodeState._(
        status: DeviceCodeStatus.success,
      );
  factory DeviceCodeState.badVerificationCode() => const DeviceCodeState._(
        status: DeviceCodeStatus.badCode,
      );
  factory DeviceCodeState.declined() => const DeviceCodeState._(
        status: DeviceCodeStatus.declined,
      );

  factory DeviceCodeState.expired() => const DeviceCodeState._(
        status: DeviceCodeStatus.declined,
      );

  @override
  List<Object?> get props => [
        status,
        verificationUri,
        userCode,
        failureDetails,
      ];
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

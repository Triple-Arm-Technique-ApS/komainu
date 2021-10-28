part of 'device_code_bloc.dart';

@immutable
abstract class DeviceCodeState {}

class DeviceCodeInitial extends DeviceCodeState {}

/// The device code flow is initializing (getting authorization response from the authorization endpoint)
class DeviceCodeStateInitializing extends DeviceCodeState {}

/// Authorization response recieved successfully!
class DeviceCodeReadyState extends DeviceCodeState {
  final Uri verificationUri;
  final String userCode;

  DeviceCodeReadyState(this.verificationUri, this.userCode);
}

/// The [DeviceCodeBloc] is currently polling the token endpoint
/// and parsing the response.
class DeviceCodeRunningState extends DeviceCodeState {
  final Uri verificationUri;
  final String userCode;

  DeviceCodeRunningState(this.verificationUri, this.userCode);
}

class DeviceCodeSucceedState extends DeviceCodeState {}

class DeviceCodeUnexpectedFailureState extends DeviceCodeState {}

class DeviceCodeBadVerificationCodeState extends DeviceCodeState {}

class DeviceCodeAuthorizationDeclinedState extends DeviceCodeState {}

class DeviceCodeExpiredState extends DeviceCodeState {}

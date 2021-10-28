part of 'device_code_bloc.dart';

@immutable
abstract class DeviceCodeState {}

class DeviceCodeInitial extends DeviceCodeState {}

class DeviceCodeStateInitializing extends DeviceCodeState {}

class DeviceCodeStateReady extends DeviceCodeState {
  final Uri verificationUri;
  final String userCoder;

  DeviceCodeStateReady(this.verificationUri, this.userCoder);
}

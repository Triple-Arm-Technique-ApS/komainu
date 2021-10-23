part of 'device_code_bloc.dart';

@immutable
abstract class DeviceCodeEvent {}

class DeviceCodeCancelledEvent extends DeviceCodeEvent {}

class DeviceCodeFailedEvent extends DeviceCodeEvent {}

class DeviceCodeSuccessEvent extends DeviceCodeEvent {}

class DeviceCodeRetryEvent extends DeviceCodeEvent {}

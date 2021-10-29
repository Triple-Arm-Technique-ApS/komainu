part of 'device_code_bloc.dart';

@immutable
abstract class DeviceCodeEvent {}

class DeviceCodeCancelledEvent extends DeviceCodeEvent {}

class DeviceCodeFailedEvent extends DeviceCodeEvent {}

class DeviceCodeSuccessEvent extends DeviceCodeEvent {}

class DeviceCodeRetryEvent extends DeviceCodeEvent {}

class DeviceCodeStartEvent extends DeviceCodeEvent {}

enum _TickerStatus { running, failure, success, badCode, declined, expired }

class _TickerEvent extends DeviceCodeEvent {
  final _TickerStatus status;
  final FailureDetails? failureDetails;
  _TickerEvent({
    required this.status,
    this.failureDetails,
  });
}

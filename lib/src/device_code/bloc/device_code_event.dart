part of 'device_code_bloc.dart';

@immutable
abstract class DeviceCodeEvent {}

enum DeviceCodeStartStopStatus { started, stopped, cancelled }

class DeviceCodeStartStopEvent extends DeviceCodeEvent {
  final DeviceCodeStartStopStatus status;
  DeviceCodeStartStopEvent(this.status);

  factory DeviceCodeStartStopEvent.start() {
    return DeviceCodeStartStopEvent(DeviceCodeStartStopStatus.started);
  }

  factory DeviceCodeStartStopEvent.stop() {
    return DeviceCodeStartStopEvent(DeviceCodeStartStopStatus.stopped);
  }

  factory DeviceCodeStartStopEvent.cancel() {
    return DeviceCodeStartStopEvent(DeviceCodeStartStopStatus.cancelled);
  }
}

part of 'device_code_bloc.dart';

@immutable
abstract class DeviceCodeEvent {}

class DeviceCodeStartStopEvent extends DeviceCodeEvent {
  final bool start;

  DeviceCodeStartStopEvent(this.start);

  factory DeviceCodeStartStopEvent.start() {
    return DeviceCodeStartStopEvent(true);
  }

  factory DeviceCodeStartStopEvent.stop() {
    return DeviceCodeStartStopEvent(false);
  }
}

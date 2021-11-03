import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'bloc/device_code_bloc.dart';

export 'bloc/device_code_bloc.dart' show DeviceCodeState, DeviceCodeStatus;
export 'device_code_builder.dart';
export 'device_code_consumer.dart';
export 'device_code_listener.dart';

class DeviceCode {
  final BuildContext _context;
  DeviceCode._(this._context);
  factory DeviceCode.of(BuildContext context) {
    return DeviceCode._(context);
  }

  /// Emits an event to the [DeviceCodeBloc] to start
  /// the flow of the device code grant.
  void start() {
    _context.read<DeviceCodeBloc>().add(DeviceCodeStartStopEvent.start());
  }

  /// Attempts to cancel the polling to the device code endpoint.
  void cancel() {
    _context.read<DeviceCodeBloc>().add(DeviceCodeStartStopEvent.cancel());
  }

  void restart() {
    _context.read<DeviceCodeBloc>().add(DeviceCodeStartStopEvent.start());
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../device_code_ticker/device_code_ticker.dart';
import '../device_code_ticker/device_code_ticker_event.dart';

part 'device_code_event.dart';
part 'device_code_state.dart';

class DeviceCodeBloc extends Bloc<DeviceCodeEvent, DeviceCodeState> {
  final DeviceCodeTicker _ticker = DeviceCodeTicker();
  StreamSubscription<DeviceCodeTickerEvent>? _tickerSubscription;

  DeviceCodeBloc() : super(DeviceCodeInitial()) {
    on<DeviceCodeEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }
}

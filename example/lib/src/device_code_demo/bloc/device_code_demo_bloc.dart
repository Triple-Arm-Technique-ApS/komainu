import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'device_code_demo_event.dart';
part 'device_code_demo_state.dart';

class DeviceCodeDemoBloc extends Bloc<DeviceCodeDemoEvent, DeviceCodeDemoState> {
  DeviceCodeDemoBloc() : super(DeviceCodeDemoInitial()) {
    on<DeviceCodeDemoEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

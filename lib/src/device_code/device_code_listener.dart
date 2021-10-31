import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

import 'bloc/device_code_bloc.dart';

typedef DeviceCodeListenerCallback = void Function(
  BuildContext,
  DeviceCodeState,
);

class DeviceCodeListener extends StatelessWidget {
  final ConfigureOAuthCreator create;
  final DeviceCodeListenerCallback listener;
  final Widget? child;
  const DeviceCodeListener({
    Key? key,
    required this.create,
    required this.listener,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DeviceCodeBloc(Client(), create()),
      child: BlocListener<DeviceCodeBloc, DeviceCodeState>(
        listener: listener,
        child: child,
      ),
    );
  }
}

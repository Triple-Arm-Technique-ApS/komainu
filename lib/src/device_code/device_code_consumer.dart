import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

import 'bloc/device_code_bloc.dart';
import 'device_code_builder.dart';
import 'device_code_listener.dart';

class DeviceCodeConsumer extends StatelessWidget {
  final ConfigureOAuthCreator create;
  final DeviceCodeListenerCallback listener;
  final DeviceCodeBuilderCallback builder;
  const DeviceCodeConsumer({
    Key? key,
    required this.create,
    required this.listener,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DeviceCodeBloc(Client(), create()),
      child: BlocConsumer<DeviceCodeBloc, DeviceCodeState>(
        listener: listener,
        builder: builder,
      ),
    );
  }
}

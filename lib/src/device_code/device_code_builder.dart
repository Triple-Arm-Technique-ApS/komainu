import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

import 'bloc/device_code_bloc.dart';

typedef DeviceCodeBuilderCallback = Widget Function(
  BuildContext,
  DeviceCodeState,
);

class DeviceCodeBuilder extends StatelessWidget {
  final ConfigureOAuthCreator create;
  final DeviceCodeBuilderCallback builder;
  const DeviceCodeBuilder({
    Key? key,
    required this.create,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DeviceCodeBloc(Client(), create()),
      child: BlocBuilder<DeviceCodeBloc, DeviceCodeState>(
        builder: builder,
      ),
    );
  }
}

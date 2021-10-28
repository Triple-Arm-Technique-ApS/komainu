import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'bloc/well_known_configuration_bloc.dart';
import 'well_known_configuration_builder.dart';
import 'well_known_configuration_listener.dart';

class WellKnownConfigurationConsumer extends StatelessWidget {
  final Uri wellKnownConfigurationEndpoint;
  final WellKnownConfigurationBuilderCallback builder;
  final WellKnownConfigurationListenerCallback listener;
  const WellKnownConfigurationConsumer({
    Key? key,
    required this.wellKnownConfigurationEndpoint,
    required this.builder,
    required this.listener,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WellKnownConfigurationBloc(Client())
        ..add(WellKnownConfigurationRequested(wellKnownConfigurationEndpoint)),
      child:
          BlocConsumer<WellKnownConfigurationBloc, WellKnownConfigurationState>(
        listener: listener,
        builder: builder,
      ),
    );
  }
}

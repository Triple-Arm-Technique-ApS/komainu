import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

import 'bloc/well_known_configuration_bloc.dart';

typedef WellKnownConfigurationBuilderCallback = Widget Function(
    BuildContext, WellKnownConfigurationState);

class WellKnownConfigurationBuilder extends StatelessWidget {
  final Uri wellKnownConfigurationEndpoint;
  final WellKnownConfigurationBuilderCallback builder;
  const WellKnownConfigurationBuilder({
    Key? key,
    required this.wellKnownConfigurationEndpoint,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WellKnownConfigurationBloc(Client())
        ..add(WellKnownConfigurationRequested(wellKnownConfigurationEndpoint)),
      child:
          BlocBuilder<WellKnownConfigurationBloc, WellKnownConfigurationState>(
        builder: builder,
      ),
    );
  }
}

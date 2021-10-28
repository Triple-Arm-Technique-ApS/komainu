import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:http/http.dart';
import 'bloc/well_known_configuration_bloc.dart';

typedef WellKnownConfigurationListenerCallback = void Function(
    BuildContext, WellKnownConfigurationState);

class WellKnownConfigurationListener extends StatelessWidget {
  final Uri wellKnownConfigurationEndpoint;
  final WellKnownConfigurationListenerCallback listener;
  final Widget child;
  const WellKnownConfigurationListener({
    Key? key,
    required this.wellKnownConfigurationEndpoint,
    required this.listener,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WellKnownConfigurationBloc(Client())
        ..add(WellKnownConfigurationRequested(wellKnownConfigurationEndpoint)),
      child:
          BlocListener<WellKnownConfigurationBloc, WellKnownConfigurationState>(
        listener: listener,
        child: child,
      ),
    );
  }
}

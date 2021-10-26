import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/o_auth_session_bloc.dart';
import 'o_auth_session_builder.dart';
import 'o_auth_session_listener.dart';
import 'o_auth_session_provider.dart';

class OAuthSessionConsumer extends StatelessWidget {
  final ConfigureOAuthCreator create;
  final OAuthSessionBuilderCallback builder;
  final OAuthSessionListenerCallback listener;
  const OAuthSessionConsumer({
    Key? key,
    required this.create,
    required this.builder,
    required this.listener,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OAuthSessionProvider(
      create: create,
      child: BlocConsumer<OAuthSessionBloc, OAuthSessionState>(
        builder: builder,
        listener: listener,
      ),
    );
  }
}

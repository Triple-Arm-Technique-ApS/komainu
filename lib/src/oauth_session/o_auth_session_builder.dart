import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/o_auth_session_bloc.dart';
import 'o_auth_session_provider.dart';

typedef OAuthSessionBuilderCallback = Widget Function(
  BuildContext context,
  OAuthSessionState state,
);

class OAuthSessionBuilder extends StatelessWidget {
  final ConfigureOAuthCreator create;
  final OAuthSessionBuilderCallback builder;
  const OAuthSessionBuilder({
    Key? key,
    required this.create,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OAuthSessionProvider(
      create: create,
      child: BlocBuilder<OAuthSessionBloc, OAuthSessionState>(
        builder: builder,
      ),
    );
  }
}

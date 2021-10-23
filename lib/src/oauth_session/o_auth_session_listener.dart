import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/o_auth_session_bloc.dart';
import 'o_auth_session_provider.dart';

typedef OAuthSessionListenerCallback = void Function(
  BuildContext context,
  OAuthSessionState state,
);

class OAuthSessionListener extends StatelessWidget {
  final Widget child;
  final ConfigureOAuthCreator create;
  final OAuthSessionListenerCallback listener;
  const OAuthSessionListener({
    Key? key,
    required this.create,
    required this.child,
    required this.listener,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OAuthSessionProvider(
      create: create,
      child: BlocListener<OAuthSessionBloc, OAuthSessionState>(
        listener: listener,
        child: child,
      ),
    );
  }
}

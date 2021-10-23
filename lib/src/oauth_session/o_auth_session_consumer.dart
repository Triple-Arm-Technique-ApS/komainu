import 'package:flutter/widgets.dart';

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
    return Container();
  }
}

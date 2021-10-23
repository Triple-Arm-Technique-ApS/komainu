import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'o_auth_configuration.dart';
import 'o_auth_session.dart';
import 'o_auth_session_storage.dart';

typedef ConfigureOAuthCreator = OAuthConfiguration Function();

class OAuthSessionProvider extends StatelessWidget {
  final Widget child;
  final ConfigureOAuthCreator create;
  final OAuthSessionCreator? createStorage;
  const OAuthSessionProvider({
    Key? key,
    required this.create,
    required this.child,
    this.createStorage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OAuthSessionBloc(
        create(),
        createStorage?.call() ?? MemoryAuthSessionStorage(),
      ),
      child: child,
    );
  }
}

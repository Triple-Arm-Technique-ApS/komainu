import 'package:flutter/cupertino.dart';
import 'package:oauth2/oauth2.dart';
import 'package:provider/provider.dart';

import 'bloc/o_auth_session_bloc.dart';

export 'bloc/o_auth_session_bloc.dart';
export 'o_auth_configuration.dart';
export 'o_auth_session_builder.dart';
export 'o_auth_session_consumer.dart';
export 'o_auth_session_listener.dart';

class OAuthSession {
  final BuildContext _context;
  OAuthSession._(this._context);

  factory OAuthSession.of(BuildContext context) {
    return OAuthSession._(context);
  }

  void signOut() {
    _context.read<OAuthSessionBloc>().add(OAuthSignOutEvent());
  }

  void signIn(Credentials credentials) {
    _context.read<OAuthSessionBloc>().add(OAuthSignInEvent(credentials));
  }
}

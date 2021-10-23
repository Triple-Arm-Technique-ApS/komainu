import 'package:flutter/cupertino.dart';
import 'package:komainu/src/oauth_session/bloc/o_auth_session_bloc.dart';
import 'package:provider/provider.dart';

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
}

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:komainu/src/oauth_session/o_auth_session_storage.dart';
import 'package:oauth2/oauth2.dart';
import '../../building_blocks/building_blocks.dart';
import 'package:meta/meta.dart';

part 'o_auth_session_event.dart';
part 'o_auth_session_state.dart';

class OAuthSessionBloc extends Bloc<OAuthSessionEvent, OAuthSessionState> {
  final OAuthConfiguration configuration;
  final OAuthSessionStorage storage;
  OAuthSessionBloc(
    this.configuration,
    this.storage,
  ) : super(OAuthSessionState.initial()) {
    storage.beginSession().then(
          (credentials) => add(
            _CredentialsLoaded(credentials),
          ),
        );
    on<OAuthSignInEvent>((event, emit) {
      emit(OAuthSessionState.authorized(event.credentials));
    });

    on<OAuthSignOutEvent>((event, emit) {
      emit(OAuthSessionState.initial());
    });
  }
}

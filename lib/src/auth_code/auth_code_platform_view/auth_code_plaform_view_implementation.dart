import 'package:flutter/widgets.dart';

typedef AuthCodeCallbackHandler = bool Function(Uri uri);
typedef AuthCodeVoidCallback = void Function();

abstract class AuthCodePlatformViewImplementaion {
  /// [callbackHandler] is used to match agains the
  /// registered callback uri.
  AuthCodeCallbackHandler get callbackHandler;

  /// [onError] is called if an unexpected error occures.
  AuthCodeVoidCallback get onError;

  /// [onCancelled] is called when the user cancels the flow or closes
  /// the view.
  AuthCodeVoidCallback get onCancelled;

  /// The [authorizationEndpoint] is the oauth authorization endpoint
  /// where the client will be redirected to.
  Uri get authorizationEndpoint;

  /// The [child] widget of view.
  Widget? get child;
}

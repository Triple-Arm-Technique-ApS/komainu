import '../well_known_configuration/discovery_document.dart';

typedef OAuthConfigurationBuilder = OAuthConfiguration Function();

class OAuthConfiguration {
  /// [clientId] is the OAuth 2.0 Client Identifier valid at the Authorization Server.
  final String clientId;

  /// [redirectUri] is the redirection URI to which the response will be sent.
  final Uri redirectUri;

  /// The [scope] requested by the client.
  final List<String> scope;

  /// The OAuth 2.0 authorisation endpoint URL.
  final Uri authorizationEndpoint;

  /// REQUIRED IF OpenID Connect Provider supports OpenID Connect Session Management and
  /// is a URL at the OP to which an RP can perform a redirect to request that the End-User be logged out at the OP.
  final Uri? endSessionEndpoint;

  /// The OpenID Connect UserInfo endpoint URL.
  final Uri? userInfoEndpoint;

  /// The OAuth 2.0 Token_endpoint URL.
  /// This is REQUIRED unless only the Implicit Flow is used.
  final Uri tokenEndpoint;

  OAuthConfiguration(
    this.clientId,
    this.redirectUri,
    this.scope,
    this.authorizationEndpoint,
    this.endSessionEndpoint,
    this.userInfoEndpoint,
    this.tokenEndpoint,
  );

  factory OAuthConfiguration.fromDiscoveryDocument({
    required String clientId,
    required Uri redirectUri,
    required List<String> scope,
    required DiscoveryDocument discoveryDocument,
  }) {
    return OAuthConfiguration(
      clientId,
      redirectUri,
      scope,
      discoveryDocument.authorizationEndpoint,
      discoveryDocument.endSessionEndpoint,
      discoveryDocument.userInfoEndpoint,
      discoveryDocument.tokenEndpoint,
    );
  }
}

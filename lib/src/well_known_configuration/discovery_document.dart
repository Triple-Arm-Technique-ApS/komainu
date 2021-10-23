import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:komainu/src/well_known_configuration/discovery_document_exception.dart';

class DiscoveryDocument {
  /// The Issuer Identifier of the OpenID Connect Provider. This value is the same as the iss claim value in the ID tokens issued by this provider.
  final Uri issuer;

  /// The URL of the OpenID Connect Provider's OAuth 2.0 Authorization Endpoint.
  final Uri authorizationEndpoint;

  /// The URL of the OpenID Connect Provider's OAuth 2.0 Token Endpoint.
  final Uri tokenEndpoint;

  /// The URL of the OpenID Connect Provider's UserInfo Endpoint.
  final Uri? userInfoEndpoint;

  /// REQUIRED IF OpenID Connect Provider supports OpenID Connect Session Management and
  /// is a URL at the OP to which an RP can perform a redirect to request that the End-User be logged out at the OP.
  final Uri? endSessionEndpoint;

  /// The URL of the OpenID Connect Provider's JSON Web Key Set document.
  /// This document contains signing keys that clients use to validate the signatures from the provider.
  final Uri? jwksUri;

  /// [responseTypesSupported]  array containing a list of OAuth 2.0 response types supported by this provider.
  final List<String> responseModesSupported;

  /// [responseTypesSupported] array containing a list of OAuth 2.0 response modes supported by this provider.
  final List<String> responseTypesSupported;

  DiscoveryDocument(
      {required this.issuer,
      required this.authorizationEndpoint,
      required this.tokenEndpoint,
      required this.responseModesSupported,
      required this.responseTypesSupported,
      this.userInfoEndpoint,
      this.endSessionEndpoint,
      this.jwksUri});

  factory DiscoveryDocument.fromJson(Map<String, dynamic> json) {
    return DiscoveryDocument(
      issuer: Uri.parse(json['issuer'] as String),
      authorizationEndpoint:
          Uri.parse(json['authorization_endpoint'] as String),
      tokenEndpoint: Uri.parse(json['token_endpoint'] as String),
      userInfoEndpoint: json.containsKey('userinfo_endpoint')
          ? Uri.parse(json['userinfo_endpoint'] as String)
          : null,
      endSessionEndpoint: json.containsKey('end_session_endpoint')
          ? Uri.parse(json['end_session_endpoint'] as String)
          : null,
      responseModesSupported:
          (json['response_modes_supported'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      responseTypesSupported:
          (json['response_types_supported'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      jwksUri: json.containsKey('jwks_uri')
          ? Uri.parse(json['jwks_uri'] as String)
          : null,
    );
  }

  /// Sends a http request to the well known configuration endpoint
  /// and parses the response into a [DiscoveryDocument], if a http failure
  /// occurs an [DiscoveryDocumentException] is thrown.
  static Future<DiscoveryDocument> fromWellKnownConfigurationEndpoint(
      Uri wellKnownConfigurationEndpoint) async {
    final response = await http.get(wellKnownConfigurationEndpoint);
    if (response.statusCode < 200 && response.statusCode > 299) {
      throw DiscoveryDocumentException(
        statusCode: response.statusCode,
        reasonPhrase: response.reasonPhrase,
        body: response.body,
      );
    }

    return DiscoveryDocument.fromJson(jsonDecode(response.body));
  }
}

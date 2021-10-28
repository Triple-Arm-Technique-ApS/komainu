import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'bloc/well_known_configuration_bloc.dart';

class DiscoveryDocument extends Equatable {
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

  const DiscoveryDocument({
    required this.issuer,
    required this.authorizationEndpoint,
    required this.tokenEndpoint,
    required this.responseModesSupported,
    required this.responseTypesSupported,
    this.userInfoEndpoint,
    this.endSessionEndpoint,
    this.jwksUri,
  });

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

  /// Obtains the [DiscoveryDocument] of the [WellKnownConfigurationBloc] if
  /// the [WellKnownConfigurationState] is not in a successful state or the calling widget
  /// isn't an decentant of [WellKnownConfigurationBloc] an [Error] os thrown.
  factory DiscoveryDocument.of(BuildContext context) {
    final state = context.read<WellKnownConfigurationBloc>().state;
    assert(state.discoveryDocument != null);
    return context.read<WellKnownConfigurationBloc>().state.discoveryDocument!;
  }

  @override
  List<Object?> get props => [
        issuer,
        authorizationEndpoint,
        tokenEndpoint,
        userInfoEndpoint,
        endSessionEndpoint,
        jwksUri,
        responseModesSupported,
        responseTypesSupported
      ];
}

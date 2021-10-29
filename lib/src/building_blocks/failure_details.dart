import 'package:equatable/equatable.dart';

/// Details about a failure
class FailureDetails extends Equatable {
  /// [statusCode] is almost always a http status code
  /// unless it equals 0 then it is an unexpected [Exception] that was thrown.
  final int statusCode;

  /// [reasonPhrase] if also taken directly from an http response that isn't successful
  final String? reasonPhrase;

  /// The [body] of the response.
  final String body;
  final String message;
  const FailureDetails({
    required this.statusCode,
    required this.reasonPhrase,
    required this.body,
    required this.message,
  });

  @override
  List<Object?> get props => [statusCode, reasonPhrase, body, message];
}

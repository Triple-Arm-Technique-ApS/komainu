import 'komainu_exception.dart';

class HttpException extends KomainuException {
  final int statusCode;
  final String? reasonPhrase;
  final String body;
  HttpException({
    required this.statusCode,
    required this.reasonPhrase,
    required this.body,
  }) : super(
          message:
              'HTTP request failed with status : $statusCode $reasonPhrase.',
        );
}

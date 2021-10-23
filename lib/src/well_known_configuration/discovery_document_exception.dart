import '../building_blocks/exceptions/komainu_exception.dart';

class DiscoveryDocumentException extends KomainuException {
  final int statusCode;
  final String? reasonPhrase;
  final String body;
  DiscoveryDocumentException({
    required this.statusCode,
    required this.reasonPhrase,
    required this.body,
  }) : super(
          message:
              'HTTP request failed with status : $statusCode $reasonPhrase.',
        );
}

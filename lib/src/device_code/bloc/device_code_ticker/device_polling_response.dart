import 'package:flutter/foundation.dart';

@immutable
class DevicePollingResponse {
  final String error;
  const DevicePollingResponse({
    required this.error,
  });

  factory DevicePollingResponse.fromJson(Map<String, dynamic> json) {
    return DevicePollingResponse(
      error: json['error'] as String,
    );
  }
}

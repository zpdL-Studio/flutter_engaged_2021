
import 'dart:async';

import 'package:flutter/services.dart';

class FlutterEngaged2021 {
  static const CHANNEL = 'flutter_engaged_2021';

  static const MethodChannel _channel = const MethodChannel(CHANNEL);

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<void> showImageAlbum() =>
      _channel.invokeMethod(Method.SHOW_IMAGE_ALBUM.method);
}

enum Method {
  SHOW_IMAGE_ALBUM
}

extension MethodExtension on Method {
  String get method {
    switch(this) {
      case Method.SHOW_IMAGE_ALBUM:
        return '${FlutterEngaged2021.CHANNEL}/SHOW_IMAGE_ALBUM';
    }
  }
}

import 'dart:async';

import 'package:flutter/services.dart';

class FlutterEngaged2021 {
  static const MethodChannel _channel =
      const MethodChannel('flutter_engaged_2021');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}

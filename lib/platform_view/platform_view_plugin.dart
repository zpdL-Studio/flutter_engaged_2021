import 'package:flutter/services.dart';
import 'package:flutter_engaged_2021/data/plugin_image.dart';

import '../flutter_engaged_2021.dart';

class PlatformViewPlugin {
  static const CHANNEL = '${FlutterEngaged2021.CHANNEL}_platform_view';

  static String getViewId(int id) => "${CHANNEL}_$id";

  final int id;
  final MethodChannel _channel;
  PlatformViewPluginFlutterMethod? _method;

  PlatformViewPlugin(this.id): this._channel = MethodChannel(getViewId(id)) {
    _channel.setMethodCallHandler((call) async {
      FlutterMethod? method = methodToFlutter(call.method);
      if(method != null) {
        switch (method) {
          case FlutterMethod.ON_PLUGIN_IMAGE:
            if (call.arguments is Map) {
              PluginImage? pluginImage = PluginImage.factoryMap(call.arguments);
              if (pluginImage != null) {
                _method?.onPluginImage(pluginImage);
              }
            }
            break;
        }
      }
      return null;
    });
  }

  void setPluginFlutterMethod(PlatformViewPluginFlutterMethod? method) {
    this._method = method;
  }
}

abstract class PlatformViewPluginFlutterMethod {
  void onPluginImage(PluginImage pluginImage);
}

enum FlutterMethod {
  ON_PLUGIN_IMAGE,
}

FlutterMethod? methodToFlutter(String method) {
  switch (method) {
    case '${PlatformViewPlugin.CHANNEL}/ON_PLUGIN_IMAGE':
      return FlutterMethod.ON_PLUGIN_IMAGE;
  }
  return null;
}
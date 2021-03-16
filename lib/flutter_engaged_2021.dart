
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_engaged_2021/data/plugin_bitmap.dart';
import 'package:flutter_engaged_2021/data/plugin_image.dart';

class FlutterEngaged2021 {
  static const CHANNEL = 'flutter_engaged_2021';

  static const MethodChannel _channel = const MethodChannel(CHANNEL);

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<void> showImageAlbum() =>
      _channel.invokeMethod(Method.SHOW_IMAGE_ALBUM.method);

  static Future<List<PluginImage>> getImages() async {
    final results = await _channel.invokeMethod(Method.GET_IMAGES.method);
    final list = <PluginImage>[];
    if(results is List) {
      for(final result in results) {
        if(result is Map) {
          final pluginImage = PluginImage.factoryMap(result);
          if(pluginImage != null) {
            list.add(pluginImage);
          }
        }
      }
    }
    return list;
  }

  static Future<Uint8List?> readImageBytes(String image) {
    return _channel.invokeMethod(Method.READ_IMAGE_BYTES.method, image);
  }

  static Future<PluginBitmap?> getThumbnailBitmap(String image) async {
    final result = await _channel.invokeMethod(Method.GET_THUMBNAIL_BITMAP.method, image);
    if(result is Map) {
      return PluginBitmap.factoryMap(result);
    }
    return null;
  }
}

enum Method {
  SHOW_IMAGE_ALBUM,
  GET_IMAGES,
  READ_IMAGE_BYTES,
  GET_THUMBNAIL_BITMAP,
}

extension MethodExtension on Method {
  String get method {
    switch(this) {
      case Method.SHOW_IMAGE_ALBUM:
        return '${FlutterEngaged2021.CHANNEL}/SHOW_IMAGE_ALBUM';
      case Method.GET_IMAGES:
        return '${FlutterEngaged2021.CHANNEL}/GET_IMAGES';
      case Method.READ_IMAGE_BYTES:
        return '${FlutterEngaged2021.CHANNEL}/READ_IMAGE_BYTES';
      case Method.GET_THUMBNAIL_BITMAP:
        return '${FlutterEngaged2021.CHANNEL}/GET_THUMBNAIL_BITMAP';
    }
  }
}
import 'dart:async';
import 'dart:typed_data';

import 'map_ext.dart';
import 'dart:ui' as ui;

class PluginBitmap {
  final int width;
  final int height;
  final Uint8List buffer;

  PluginBitmap(this.width, this.height, this.buffer);

  static PluginBitmap? factoryMap(Map map) {
    int width = map.get("width") ?? 0;
    int height = map.get("height") ?? 0;
    Uint8List? buffer = map.get("buffer");

    if(width > 0 && height > 0 && buffer != null) {
      return PluginBitmap(width, height, buffer);
    }
    return null;
  }

  Future<ui.Image> decodeImageFromPixels() {
    Completer<ui.Image> c = Completer();
    ui.decodeImageFromPixels(buffer, width, height, ui.PixelFormat.rgba8888, (results) {
      c.complete(results);
    });
    return c.future;
  }
}
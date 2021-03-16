import 'dart:typed_data';

import '../flutter_engaged_2021.dart';
import 'map_ext.dart';
import 'plugin_bitmap.dart';

class PluginImage {
  final String id;

  PluginImage(this.id);

  static PluginImage? factoryMap(Map? map) {
    final id = map?.get<String>("id");
    if(id != null) {
      return PluginImage(id);
    }
    return null;
  }

  Future<Uint8List?> readBytes() => FlutterEngaged2021.readImageBytes(id);

  // Future<PluginBitmap?> thumbnailBytes() => FlutterEngaged2021.getThumbnailBitmap(id);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PluginImage &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;

}
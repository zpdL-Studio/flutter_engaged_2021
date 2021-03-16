import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_engaged_2021/data/plugin_image.dart';

class PluginImageProvider extends ImageProvider<PluginImageProvider> {

  final PluginImage pluginImage;

  const PluginImageProvider(this.pluginImage);

  @override
  Future<PluginImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<PluginImageProvider>(this);
  }

  @override
  ImageStreamCompleter load(PluginImageProvider key, decode) {
    final StreamController<ImageChunkEvent> chunkEvents = StreamController<ImageChunkEvent>();

    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, chunkEvents, decode),
      scale: 1.0,
      chunkEvents: chunkEvents.stream,
      informationCollector: () sync* {
        yield ErrorDescription('pluginImage.id: ${pluginImage.id}');
      },
    );
  }

  Future<ui.Codec> _loadAsync(PluginImageProvider key, StreamController<ImageChunkEvent> chunkEvents, DecoderCallback decode) async {
    try {
      assert(key == this);
      chunkEvents.add(ImageChunkEvent(
        cumulativeBytesLoaded: 0,
        expectedTotalBytes: 100,
      ));

      final Uint8List? bytes = await pluginImage.readBytes();
      if (bytes == null || bytes.lengthInBytes == 0) {
        // The file may become available later.
        PaintingBinding.instance?.imageCache?.evict(key);
        throw StateError('${pluginImage.id} is empty and cannot be loaded as an image.');
      }

      chunkEvents.add(ImageChunkEvent(
        cumulativeBytesLoaded: 100,
        expectedTotalBytes: 100,
      ));

      return await decode(bytes);
    } catch(e) {
      rethrow;
    } finally {
      chunkEvents.close();
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PluginImageProvider &&
          runtimeType == other.runtimeType &&
          pluginImage.id == other.pluginImage.id;

  @override
  int get hashCode => pluginImage.id.hashCode;
}
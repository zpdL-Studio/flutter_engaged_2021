import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_engaged_2021/data/plugin_image.dart';

import '../flutter_engaged_2021.dart';

class PluginThumbnailWidget extends StatefulWidget {
  final PluginImage image;

  PluginThumbnailWidget({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PluginThumbnailState();
}

class _PluginThumbnailState extends State<PluginThumbnailWidget> {
  ui.Image? _image;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _image?.dispose();
    _image = null;
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant PluginThumbnailWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget.image.id != widget.image.id) {
      if(_image != null) {
        _image?.dispose();
        _image = null;
      }
      _load();
    }
  }

  void _load() async {
    final id = widget.image.id;
    final pluginBitmap = await FlutterEngaged2021.getThumbnailBitmap(id);
    if(pluginBitmap != null) {
      final image = await pluginBitmap.decodeImageFromPixels();
      if(mounted) {
        setState(() {
          this._image = image;
        });
      } else {
        this._image = image;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final image = _image;
    if(image != null) {
      return RawImage(
        image: image,
        fit: BoxFit.cover,
      );
    }
    return Container();
  }
}
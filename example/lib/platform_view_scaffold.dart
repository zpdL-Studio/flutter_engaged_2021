import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_engaged_2021/data/plugin_image.dart';
import 'package:flutter_engaged_2021/flutter_engaged_2021.dart';
import 'package:flutter_engaged_2021/platform_view/platform_view_plugin.dart';
import 'package:flutter_engaged_2021/platform_view/platform_view_widget.dart';
import 'package:flutter_engaged_2021_example/plugin_image_view_scaffold.dart';

class PlatformViewScaffold extends StatefulWidget {
  @override
  _PlatformViewScaffoldState createState() => _PlatformViewScaffoldState();
}

class _PlatformViewScaffoldState extends State<PlatformViewScaffold> implements PlatformViewPluginFlutterMethod {

  PlatformViewPlugin? _plugin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Image album by platform view'),
        ),
        body: PlatformViewWidget(
          onPlugin: (PlatformViewPlugin? plugin) {
            _plugin?.setPluginFlutterMethod(null);
            _plugin = plugin;
            _plugin?.setPluginFlutterMethod(this);
          },
        ));
  }

  @override
  void onPluginImage(PluginImage pluginImage) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PluginImageViewScaffold(pluginImage: pluginImage)));
  }
}

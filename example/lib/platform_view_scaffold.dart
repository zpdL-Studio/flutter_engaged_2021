
import 'package:flutter/material.dart';
import 'package:flutter_engaged_2021/data/plugin_image.dart';
import 'package:flutter_engaged_2021/platform_view/platform_view_plugin.dart';
import 'package:flutter_engaged_2021/platform_view/platform_view_widget.dart';
import 'package:flutter_engaged_2021_example/plugin_image_view_scaffold.dart';

class PlatformViewScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Image album by platform view'),
        ),
        body: PlatformWidget());
  }
}

class PlatformWidget extends StatefulWidget {
  @override
  _PlatformViewState createState() => _PlatformViewState();
}

class _PlatformViewState extends State<PlatformWidget> implements PlatformViewPluginFlutterMethod {

  PlatformViewPlugin? _plugin;

  @override
  Widget build(BuildContext context) {
    return PlatformViewWidget(
      onPlugin: (PlatformViewPlugin? plugin) {
        _plugin?.setPluginFlutterMethod(null);
        _plugin = plugin;
        _plugin?.setPluginFlutterMethod(this);
      },
    );
  }

  @override
  void onPluginImage(PluginImage pluginImage) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PluginImageViewScaffold(pluginImage: pluginImage)));
  }
}
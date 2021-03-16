
import 'package:flutter/material.dart';
import 'package:flutter_engaged_2021/data/plugin_image.dart';
import 'package:flutter_engaged_2021/widget/plugin_image_provider.dart';

class PluginImageViewScaffold extends StatelessWidget {
  final PluginImage pluginImage;

  const PluginImageViewScaffold({Key? key, required this.pluginImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('image id : ${pluginImage.id}'),
        ),
        body: Center(
          child: Image(
            image: PluginImageProvider(pluginImage),
            fit: BoxFit.contain,
          ),
        ));
  }
}

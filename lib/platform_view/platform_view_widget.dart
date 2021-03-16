
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_engaged_2021/platform_view/platform_view_plugin.dart';

typedef OnPlatformViewWidgetPlugin = void Function(PlatformViewPlugin? plugin);

class PlatformViewWidget extends StatefulWidget {

  final OnPlatformViewWidgetPlugin onPlugin;

  PlatformViewWidget({Key? key, required this.onPlugin,}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PlatformViewState();
}

class _PlatformViewState extends State<PlatformViewWidget> {
  PlatformViewPlugin? _plugin;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: PlatformViewPlugin.CHANNEL,
        onPlatformViewCreated: onPlatformViewCreated,
        creationParamsCodec: const StandardMessageCodec(),
      );
    }
    else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: PlatformViewPlugin.CHANNEL,
        onPlatformViewCreated: onPlatformViewCreated,
        creationParamsCodec: const StandardMessageCodec(),
      );
    }
    return new Text(
        '$defaultTargetPlatform is not yet supported by this plugin : PlatformViewWidget');
  }

  void onPlatformViewCreated(int id) async {
    final plugin = _plugin;
    if(plugin != null && plugin.id != id) {
      widget.onPlugin(null);
      _plugin = null;
    }

    if(_plugin == null) {
      _plugin = PlatformViewPlugin(id);
      widget.onPlugin(_plugin);
    } else {
      print("PlatformViewWidget:onPlatformViewCreated Already $id");
    }
  }

  @override
  void dispose() {
    _plugin = null;
    widget.onPlugin(null);
    super.dispose();
  }
}
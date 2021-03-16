import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_engaged_2021/data/plugin_image.dart';
import 'package:flutter_engaged_2021/flutter_engaged_2021.dart';
import 'package:flutter_engaged_2021/platform_view/platform_view_plugin.dart';
import 'package:flutter_engaged_2021/platform_view/platform_view_widget.dart';
import 'package:flutter_engaged_2021/widget/plugin_thumbnail_widget.dart';
import 'package:flutter_engaged_2021_example/plugin_image_view_scaffold.dart';

class PluginImagesScaffold extends StatefulWidget {
  @override
  _PluginImagesScaffoldState createState() => _PluginImagesScaffoldState();
}

class _PluginImagesScaffoldState extends State<PluginImagesScaffold> {

  List<PluginImage>? _list;

  @override
  void initState() {
    super.initState();
    FlutterEngaged2021.getImages().then((value) {
      if(mounted) {
        setState(() {
          _list = value;
        });
      } else {
        _list = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Image album by plugin images'),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: GridView.builder(
            itemCount: _list?.length ?? 0,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (BuildContext context, int index) {
              final item = _list?[index];
              if(item != null) {
                return Material(
                    child: InkWell(child: PluginThumbnailWidget(image: item), onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PluginImageViewScaffold(pluginImage: item)));
                    },));
              } else {
                return Container();
              }
            },
          ),
        )
    );
  }
}
